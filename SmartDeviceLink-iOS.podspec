Pod::Spec.new do |s|

  s.name         = "SmartDeviceLink-iOS"
  s.version      = "3.0.0"
  s.summary      = "Connect your app with cars!"
  s.homepage     = "https://github.com/smartdevicelink/SmartDeviceLink-iOS"
  s.license      = { :type => "New BSD", :file => "LICENSE" }
  s.author             = { "SmartDeviceLink Team" => "joel@livioradio.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/smartdevicelink/SmartDeviceLink-iOS.git", :tag => "3.0.0" }
  s.source_files  = "SmartDeviceLink-iOS/Library/*.{h,m}"
  s.requires_arc = true

end