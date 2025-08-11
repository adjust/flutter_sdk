Pod::Spec.new do |s|
  s.name                  = 'test_lib'
  s.version               = '5.4.2'
  s.summary               = 'Adjust test library for iOS platform'
  s.description           = <<-DESC
                            Adjust test library for iOS platform.
                            DESC
  s.homepage              = 'http://www.adjust.com'
  s.license               = { :file => '../LICENSE' }
  s.author                = { 'Adjust' => 'sdk@adjust.com' }
  s.source                = { :path => '.' }
  s.source_files          = 'Classes/**/*'
  s.public_header_files   = 'Classes/**/*.h'
  s.preserve_paths        = 'AdjustTestLibrary.framework'
  s.xcconfig              = { 'OTHER_LDFLAGS' => '-framework AdjustTestLibrary' }
  s.vendored_frameworks   = 'AdjustTestLibrary.framework'
  s.ios.deployment_target = '8.0'

  s.dependency 'Flutter'
end
