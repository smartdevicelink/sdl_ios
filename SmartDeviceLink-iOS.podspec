Pod::Spec.new do |s|

  s.name         = "SmartDeviceLink-iOS"
  s.version      = "4.0.3"
  s.summary      = "Connect your app with cars!"
  s.homepage     = "https://github.com/smartdevicelink/SmartDeviceLink-iOS"
  s.license      = { :type => "New BSD", :file => "LICENSE" }
  s.author       = { "SmartDeviceLink Team" => "joel@livio.io" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/smartdevicelink/sdl_ios.git", :tag => "4.0.3" }
  s.source_files = "SmartDeviceLink-iOS/SmartDeviceLink/*.{h,m}"
  s.requires_arc = true

end
