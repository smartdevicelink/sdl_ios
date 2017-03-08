Pod::Spec.new do |s|

s.name         = "SmartDeviceLink-iOS"
s.version      = "4.5.5"
s.summary      = "Connect your app with cars!"
s.homepage     = "https://github.com/smartdevicelink/SmartDeviceLink-iOS"
s.license      = { :type => "New BSD", :file => "LICENSE" }
s.author       = { "SmartDeviceLink Team" => "developer@smartdevicelink.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/smartdevicelink/sdl_ios.git", :tag => s.version.to_s }
s.source_files = "SmartDeviceLink/**/*.{h,m}"
s.requires_arc = true
s.ios.resource_bundle = { "SmartDeviceLink" => "SmartDeviceLink/Internal/Assets/**/*" }
s.private_header_files = "SmartDeviceLink/Internal/**/*.h"

end
