//
//  SDLAppHMITypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppHMIType.h"

QuickSpecBegin(SDLAppHMITypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLAppHMITypeDefault).to(equal(@"DEFAULT"));
        expect(SDLAppHMITypeCommunication).to(equal(@"COMMUNICATION"));
        expect(SDLAppHMITypeMedia).to(equal(@"MEDIA"));
        expect(SDLAppHMITypeMessaging).to(equal(@"MESSAGING"));
        expect(SDLAppHMITypeNavigation).to(equal(@"NAVIGATION"));
        expect(SDLAppHMITypeInformation).to(equal(@"INFORMATION"));
        expect(SDLAppHMITypeSocial).to(equal(@"SOCIAL"));
        expect(SDLAppHMITypeProjection).to(equal(@"PROJECTION"));
        expect(SDLAppHMITypeBackgroundProcess).to(equal(@"BACKGROUND_PROCESS"));
        expect(SDLAppHMITypeTesting).to(equal(@"TESTING"));
        expect(SDLAppHMITypeSystem).to(equal(@"SYSTEM"));
        expect(SDLAppHMITypeRemoteControl).to(equal(@"REMOTE_CONTROL"));
        expect(SDLAppHMITypeWebView).to(equal(@"WEB_VIEW"));
    });
});

QuickSpecEnd
