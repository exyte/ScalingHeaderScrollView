Pod::Spec.new do |s|
  s.name             = "ScalingHeaderView"
  s.version          = "0.0.1"
  s.summary          = "SwiftUI library providing a ScrollView with a sticky scaling header"

  s.homepage         = 'https://github.com/exyte/ScalingHeaderView.git'
  s.license          = 'MIT'
  s.author           = { 'Exyte' => 'info@exyte.com' }
  s.source           = { :git => 'https://github.com/exyte/ScalingHeaderView.git', :tag => s.version.to_s }
  s.social_media_url = 'http://exyte.com'

  s.ios.deployment_target = '14.0'
  
  s.requires_arc = true
  s.swift_version = "5.2"

  s.source_files = [
     'Source/*.h',
     'Source/*.swift',
     'Source/**/*.swift'
  ]

  s.dependency 'Introspect'

end
