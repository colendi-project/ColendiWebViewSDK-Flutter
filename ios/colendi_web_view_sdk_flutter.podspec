
Pod::Spec.new do |s|
  s.name             = 'colendi_web_view_sdk_flutter'
  s.version          = '1.4.0'
  s.summary          = 'The Colendi Web View Software Development Kit.'
  s.description      = <<-DESC
  The Colendi Web View is a Software Development Kit developed by Colendians to enable fast and simple integration to Colendi World.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'gokberkbar' => 'gokberk.bardakci@colendi.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '4.0'
end
