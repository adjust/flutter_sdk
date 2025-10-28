Pod::Spec.new do |s|
  s.name                  = 'adjust_sdk'
  s.version               = '5.4.5'
  s.summary               = 'Adjust Flutter SDK for iOS platform'
  s.description           = <<-DESC
                            Adjust Flutter SDK for iOS platform.
                            DESC
  s.homepage              = 'http://www.adjust.com'
  s.license               = { :file => '../LICENSE' }
  s.author                = { 'Adjust' => 'sdk@adjust.com' }
  s.source                = { :path => '.' }
  s.source_files          = 'adjust_sdk/Sources/adjust_sdk/**/*.{h,m}'
  s.public_header_files   = 'adjust_sdk/Sources/adjust_sdk/include/**/*.h'
  s.ios.deployment_target = '12.0'

  s.dependency 'Flutter'
  s.dependency 'Adjust', '5.4.6'
end
