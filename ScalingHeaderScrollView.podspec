Pod::Spec.new do |s|
  s.name             = "ScalingHeaderScrollView"
  s.version          = "1.1.0"
  s.summary          = "A scroll view with a sticky header which shrinks as you scroll. Written with SwiftUI."

  s.homepage         = 'https://github.com/exyte/ScalingHeaderScrollView.git'
  s.license          = 'MIT'
  s.author           = { 'Exyte' => 'info@exyte.com' }
  s.source           = { :git => 'https://github.com/exyte/ScalingHeaderScrollView.git', :tag => s.version.to_s }
  s.social_media_url = 'http://exyte.com'

  s.ios.deployment_target = '14.0'
  
  s.requires_arc = true
  s.swift_version = "5.2"

  s.source_files = [
     'Source/*.h',
     'Source/*.swift',
     'Source/**/*.swift'
  ]

  s.dependency 'SwiftUIIntrospect'

end
