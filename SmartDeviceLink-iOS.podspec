Pod::Spec.new do |s|

s.name         = "SmartDeviceLink-iOS"
s.version      = "7.1.0"
s.summary      = "Connect your app with cars!"
s.homepage     = "https://github.com/smartdevicelink/SmartDeviceLink-iOS"
s.license      = { :type => "New BSD", :file => "LICENSE" }
s.author       = { "SmartDeviceLink Team" => "developer@smartdevicelink.com" }
s.platform     = :ios, "10.0"
s.dependency     'BiSON', '~> 1.2'
s.source       = { :git => "https://github.com/smartdevicelink/sdl_ios.git", :tag => s.version.to_s }
s.requires_arc = true

s.source_files = 'SmartDeviceLink/public/*.{h,m}', 'SmartDeviceLink/private/*.{h,m}'
s.resource_bundles = { 'SmartDeviceLink' => ['SmartDeviceLink/Assets/**/*'] }

s.public_header_files = 'SmartDeviceLink/public/*.h'
s.private_header_files = 'SmartDeviceLink/private/*.h'

end
