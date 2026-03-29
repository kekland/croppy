import 'dart:math';

import 'package:flutter/widgets.dart';

/// Computes a projective transformation (homography) that maps the four
/// [srcPoints] to the four [dstPoints] using the Direct Linear Transform (DLT)
/// algorithm with Hartley normalization for numerical stability.
///
/// Returns a Flutter [Matrix4] that can be used directly as a canvas transform.
/// The matrix maps a 2D point (x, y, 0, 1) to a perspective-divided result,
/// encoding the full 3×3 homography.
///
/// Point order must be consistent between [srcPoints] and [dstPoints]
/// (e.g. both in TL, TR, BR, BL order).
Matrix4 computeHomography(List<Offset> srcPoints, List<Offset> dstPoints) {
  assert(srcPoints.length == 4);
  assert(dstPoints.length == 4);

  // Normalize coordinates for numerical stability (Hartley normalization).
  final srcT = _normalizationTransform(srcPoints);
  final dstT = _normalizationTransform(dstPoints);
  final srcN = srcPoints.map((p) => _applyNorm(srcT, p)).toList();
  final dstN = dstPoints.map((p) => _applyNorm(dstT, p)).toList();

  // Build the 8×8 linear system (DLT with h33 = 1 constraint).
  final a = List.generate(8, (_) => List.filled(8, 0.0));
  final b = List.filled(8, 0.0);

  for (int i = 0; i < 4; i++) {
    final x = srcN[i].dx;
    final y = srcN[i].dy;
    final xp = dstN[i].dx;
    final yp = dstN[i].dy;

    // Row 2i:   [x, y, 1, 0, 0, 0, -xp·x, -xp·y] · h = xp
    a[2 * i] = [x, y, 1, 0, 0, 0, -xp * x, -xp * y];
    b[2 * i] = xp;

    // Row 2i+1: [0, 0, 0, x, y, 1, -yp·x, -yp·y] · h = yp
    a[2 * i + 1] = [0, 0, 0, x, y, 1, -yp * x, -yp * y];
    b[2 * i + 1] = yp;
  }

  // Solve Ax = b via Gaussian elimination with partial pivoting.
  final h8 = _gaussianElimination(a, b);
  // h = [h11, h12, h13, h21, h22, h23, h31, h32, h33=1]

  // Build normalized 3×3 homography matrix.
  final hn = _build3x3([...h8, 1.0]);

  // Denormalize: H = dstT⁻¹ · Hn · srcT
  final h = _mat3Mul(_mat3Mul(_mat3Inverse(dstT), hn), srcT);

  return _toMatrix4(h);
}

// ---------------------------------------------------------------------------
// Normalization helpers
// ---------------------------------------------------------------------------

/// Returns the 3×3 normalization transform for [points].
/// Translates centroid to origin and scales so RMS distance = √2.
List<List<double>> _normalizationTransform(List<Offset> points) {
  final cx = points.map((p) => p.dx).reduce((a, b) => a + b) / points.length;
  final cy = points.map((p) => p.dy).reduce((a, b) => a + b) / points.length;

  final meanDist = points
          .map((p) {
            final dx = p.dx - cx;
            final dy = p.dy - cy;
            return sqrt(dx * dx + dy * dy);
          })
          .reduce((a, b) => a + b) /
      points.length;

  final s = meanDist > 1e-10 ? sqrt(2.0) / meanDist : 1.0;

  // T = [[s, 0, -s·cx], [0, s, -s·cy], [0, 0, 1]]
  return [
    [s, 0.0, -s * cx],
    [0.0, s, -s * cy],
    [0.0, 0.0, 1.0],
  ];
}

/// Applies the 3×3 normalization transform to a 2D point.
Offset _applyNorm(List<List<double>> t, Offset p) {
  final w = t[2][0] * p.dx + t[2][1] * p.dy + t[2][2];
  return Offset(
    (t[0][0] * p.dx + t[0][1] * p.dy + t[0][2]) / w,
    (t[1][0] * p.dx + t[1][1] * p.dy + t[1][2]) / w,
  );
}

// ---------------------------------------------------------------------------
// Linear algebra helpers
// ---------------------------------------------------------------------------

/// Solves the n×n system A·x = b via Gaussian elimination with partial
/// pivoting. Throws if the matrix is singular.
List<double> _gaussianElimination(List<List<double>> a, List<double> b) {
  final n = a.length;
  // Build augmented matrix [A|b].
  final aug = List.generate(n, (i) => [...a[i], b[i]]);

  for (int col = 0; col < n; col++) {
    // Partial pivot: find row with largest absolute value in this column.
    int maxRow = col;
    for (int row = col + 1; row < n; row++) {
      if (aug[row][col].abs() > aug[maxRow][col].abs()) maxRow = row;
    }
    final tmp = aug[col];
    aug[col] = aug[maxRow];
    aug[maxRow] = tmp;

    final pivot = aug[col][col];
    if (pivot.abs() < 1e-12) {
      throw StateError('Homography: degenerate point configuration (singular matrix).');
    }

    // Eliminate below.
    for (int row = col + 1; row < n; row++) {
      final factor = aug[row][col] / pivot;
      for (int k = col; k <= n; k++) {
        aug[row][k] -= factor * aug[col][k];
      }
    }
  }

  // Back substitution.
  final x = List.filled(n, 0.0);
  for (int i = n - 1; i >= 0; i--) {
    x[i] = aug[i][n];
    for (int j = i + 1; j < n; j++) {
      x[i] -= aug[i][j] * x[j];
    }
    x[i] /= aug[i][i];
  }

  return x;
}

/// Builds a 3×3 matrix from a flat 9-element list (row-major order).
List<List<double>> _build3x3(List<double> h) => [
      [h[0], h[1], h[2]],
      [h[3], h[4], h[5]],
      [h[6], h[7], h[8]],
    ];

/// Multiplies two 3×3 matrices.
List<List<double>> _mat3Mul(List<List<double>> a, List<List<double>> b) {
  final c = List.generate(3, (_) => List.filled(3, 0.0));
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      for (int k = 0; k < 3; k++) {
        c[i][j] += a[i][k] * b[k][j];
      }
    }
  }
  return c;
}

/// Inverts a 3×3 matrix via the adjugate / determinant formula.
List<List<double>> _mat3Inverse(List<List<double>> m) {
  final det = m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1]) -
      m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]) +
      m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);

  if (det.abs() < 1e-12) {
    throw StateError('Homography: degenerate normalization (singular matrix).');
  }
  final inv = 1.0 / det;
  return [
    [
      (m[1][1] * m[2][2] - m[1][2] * m[2][1]) * inv,
      (m[0][2] * m[2][1] - m[0][1] * m[2][2]) * inv,
      (m[0][1] * m[1][2] - m[0][2] * m[1][1]) * inv,
    ],
    [
      (m[1][2] * m[2][0] - m[1][0] * m[2][2]) * inv,
      (m[0][0] * m[2][2] - m[0][2] * m[2][0]) * inv,
      (m[0][2] * m[1][0] - m[0][0] * m[1][2]) * inv,
    ],
    [
      (m[1][0] * m[2][1] - m[1][1] * m[2][0]) * inv,
      (m[0][1] * m[2][0] - m[0][0] * m[2][1]) * inv,
      (m[0][0] * m[1][1] - m[0][1] * m[1][0]) * inv,
    ],
  ];
}

/// Converts a 3×3 homography to a Flutter [Matrix4] that correctly performs
/// perspective division when used with [Canvas.transform].
///
/// For a 2D input point (x, y, 0, 1):
///   result_x = H[0][0]·x + H[0][1]·y + H[0][2]
///   result_y = H[1][0]·x + H[1][1]·y + H[1][2]
///   result_w = H[2][0]·x + H[2][1]·y + H[2][2]
/// Final canvas position = (result_x / result_w, result_y / result_w).
Matrix4 _toMatrix4(List<List<double>> h) {
  final m = Matrix4.zero();
  m.setEntry(0, 0, h[0][0]);
  m.setEntry(0, 1, h[0][1]);
  m.setEntry(0, 3, h[0][2]);
  m.setEntry(1, 0, h[1][0]);
  m.setEntry(1, 1, h[1][1]);
  m.setEntry(1, 3, h[1][2]);
  m.setEntry(2, 2, 1.0);
  m.setEntry(3, 0, h[2][0]);
  m.setEntry(3, 1, h[2][1]);
  m.setEntry(3, 3, h[2][2]);
  return m;
}
