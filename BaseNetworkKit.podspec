Pod::Spec.new do |s|
  s.name               = "BaseNetworkKit"
  s.version            = "1.1.0"
  s.summary            = "BaseNetworkKit is the easiest way to create your network layer in Swift"
  s.requires_arc       = true
  s.homepage           = "https://github.com/limadeveloper/BaseNetworkKit"
  s.license            = "MIT"
  s.author             = { "John Lima" => "thejohnlima@icloud.com" }
  s.social_media_url   = "https://twitter.com/thejohnlima"
  s.platform           = :ios, "9.3"
  s.source             = { :git => "https://github.com/limadeveloper/BaseNetworkKit.git", :tag => "#{s.version}" }
  s.source_files       = "Sources/BaseNetworkKit/**/*.{swift}"
  s.swift_version      = "5.0"
end