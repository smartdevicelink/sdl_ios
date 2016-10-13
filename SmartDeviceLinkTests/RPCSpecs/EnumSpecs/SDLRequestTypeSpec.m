//
//  SDLRequestTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRequestType.h"

QuickSpecBegin(SDLRequestTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLRequestTypeHTTP).to(equal(@"HTTP"));
        expect(SDLRequestTypeFileResume).to(equal(@"FILE_RESUME"));
        expect(SDLRequestTypeAuthenticationRequest).to(equal(@"AUTH_REQUEST"));
        expect(SDLRequestTypeAuthenticationChallenge).to(equal(@"AUTH_CHALLENGE"));
        expect(SDLRequestTypeAuthenticationAck).to(equal(@"AUTH_ACK"));
        expect(SDLRequestTypeProprietary).to(equal(@"PROPRIETARY"));
        expect(SDLRequestTypeQueryApps).to(equal(@"QUERY_APPS"));
        expect(SDLRequestTypeLaunchApp).to(equal(@"LAUNCH_APP"));
        expect(SDLRequestTypeLockScreenIconURL).to(equal(@"LOCK_SCREEN_ICON_URL"));
        expect(SDLRequestTypeTrafficMessageChannel).to(equal(@"TRAFFIC_MESSAGE_CHANNEL"));
        expect(SDLRequestTypeDriverProfile).to(equal(@"DRIVER_PROFILE"));
        expect(SDLRequestTypeVoiceSearch).to(equal(@"VOICE_SEARCH"));
        expect(SDLRequestTypeNavigation).to(equal(@"NAVIGATION"));
        expect(SDLRequestTypePhone).to(equal(@"PHONE"));
        expect(SDLRequestTypeClimate).to(equal(@"CLIMATE"));
        expect(SDLRequestTypeSettings).to(equal(@"SETTINGS"));
        expect(SDLRequestTypeVehicleDiagnostics).to(equal(@"VEHICLE_DIAGNOSTICS"));
        expect(SDLRequestTypeEmergency).to(equal(@"EMERGENCY"));
        expect(SDLRequestTypeMedia).to(equal(@"MEDIA"));
        expect(SDLRequestTypeFOTA).to(equal(@"FOTA"));
    });
});

QuickSpecEnd
