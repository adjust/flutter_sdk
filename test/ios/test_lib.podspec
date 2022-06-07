Pod::Spec.new do |s|
  s.name                  = 'test_lib'
  s.version               = '4.30.0'
  s.summary               = 'Adjust test library Flutter plugin'
  s.description           = <<-DESC
A new flutter plugin project.
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
