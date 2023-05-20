#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint croppy.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'croppy'
  s.version          = '0.0.1'
  s.summary          = 'A fully customizable image cropper for Flutter..'
  s.description      = <<-DESC
  A fully customizable image cropper for Flutter..
                       DESC
  s.homepage         = 'https://github.com/kekland/croppy'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Erzhan' => 'kk.erzhan@gmail.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
