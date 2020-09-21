Pod::Spec.new do |s|

s.name         = "SmartDeviceLink"
s.version      = "7.0.0-rc.1"
s.summary      = "Connect your app with cars!"
s.homepage     = "https://github.com/smartdevicelink/SmartDeviceLink-iOS"
s.license      = { :type => "New BSD", :file => "LICENSE" }
s.author       = { "SmartDeviceLink Team" => "developer@smartdevicelink.com" }
s.platform     = :ios, "10.0"
s.dependency     'BiSON', '~> 1.2.0'
s.source       = { :git => "https://github.com/smartdevicelink/sdl_ios.git", :tag => s.version.to_s }
s.requires_arc = true
s.swift_version = '5.2'

s.default_subspec = 'Default'

s.subspec 'Default' do |sdefault|
sdefault.source_files = 'SmartDeviceLink/public/*.{h,m}', 'SmartDeviceLink/private/*.{h,m}'
sdefault.resource_bundles = { 'SmartDeviceLink' => ['SmartDeviceLink/Assets/**/*'] }

sdefault.public_header_files = 'SmartDeviceLink/public/*.h'
sdefault.private_header_files = 'SmartDeviceLink/private/*.h'
end

s.subspec 'Swift' do |sswift|
sswift.dependency 'SmartDeviceLink/Default'
sswift.source_files = 'SmartDeviceLinkSwift/*.swift'
end

end
