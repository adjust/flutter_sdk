Pod::Spec.new do |s|
  s.name                  = 'adjust_sdk_google_odm'
  s.version               = '5.8.0'
  s.summary               = 'Adjust Flutter SDK Google ODM plugin for iOS platform'
  s.description           = <<-DESC
                            Adjust Flutter SDK Google On-Device Measurement (ODM) plugin for iOS platform.
                            DESC
  s.homepage              = 'http://www.adjust.com'
  s.license               = { :file => '../LICENSE' }
  s.author                = { 'Adjust' => 'sdk@adjust.com' }
  s.source                = { :path => '.' }
  s.source_files          = 'adjust_sdk_google_odm/Sources/adjust_sdk_google_odm/**/*'
  s.public_header_files   = 'adjust_sdk_google_odm/Sources/adjust_sdk_google_odm/include/**/*.h'
  s.ios.deployment_target = '12.0'

  s.dependency 'Flutter'
  s.dependency 'Adjust/AdjustGoogleOdm', '5.8.0'
end
