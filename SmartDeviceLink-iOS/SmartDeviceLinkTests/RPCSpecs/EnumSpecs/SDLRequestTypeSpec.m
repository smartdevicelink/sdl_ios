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
        expect([SDLRequestType HTTP].value).to(equal(@"HTTP"));
        expect([SDLRequestType FILE_RESUME].value).to(equal(@"FILE_RESUME"));
        expect([SDLRequestType AUTH_REQUEST].value).to(equal(@"AUTH_REQUEST"));
        expect([SDLRequestType AUTH_CHALLENGE].value).to(equal(@"AUTH_CHALLENGE"));
        expect([SDLRequestType AUTH_ACK].value).to(equal(@"AUTH_ACK"));
        expect([SDLRequestType PROPRIETARY].value).to(equal(@"PROPRIETARY"));
        expect([SDLRequestType QUERY_APPS].value).to(equal(@"QUERY_APPS"));
        expect([SDLRequestType LAUNCH_APP].value).to(equal(@"LAUNCH_APP"));
        expect([SDLRequestType LOCK_SCREEN_ICON_URL].value).to(equal(@"LOCK_SCREEN_ICON_URL"));
        expect([SDLRequestType TRAFFIC_MESSAGE_CHANNEL].value).to(equal(@"TRAFFIC_MESSAGE_CHANNEL"));
        expect([SDLRequestType DRIVER_PROFILE].value).to(equal(@"DRIVER_PROFILE"));
        expect([SDLRequestType VOICE_SEARCH].value).to(equal(@"VOICE_SEARCH"));
        expect([SDLRequestType NAVIGATION].value).to(equal(@"NAVIGATION"));
        expect([SDLRequestType PHONE].value).to(equal(@"PHONE"));
        expect([SDLRequestType CLIMATE].value).to(equal(@"CLIMATE"));
        expect([SDLRequestType SETTINGS].value).to(equal(@"SETTINGS"));
        expect([SDLRequestType VEHICLE_DIAGNOSTICS].value).to(equal(@"VEHICLE_DIAGNOSTICS"));
        expect([SDLRequestType EMERGENCY].value).to(equal(@"EMERGENCY"));
        expect([SDLRequestType MEDIA].value).to(equal(@"MEDIA"));
        expect([SDLRequestType FOTA].value).to(equal(@"FOTA"));
    });
});

describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLRequestType valueOf:@"HTTP"]).to(equal([SDLRequestType HTTP]));
        expect([SDLRequestType valueOf:@"FILE_RESUME"]).to(equal([SDLRequestType FILE_RESUME]));
        expect([SDLRequestType valueOf:@"AUTH_REQUEST"]).to(equal([SDLRequestType AUTH_REQUEST]));
        expect([SDLRequestType valueOf:@"AUTH_CHALLENGE"]).to(equal([SDLRequestType AUTH_CHALLENGE]));
        expect([SDLRequestType valueOf:@"AUTH_ACK"]).to(equal([SDLRequestType AUTH_ACK]));
        expect([SDLRequestType valueOf:@"QUERY_APPS"]).to(equal([SDLRequestType QUERY_APPS]));
        expect([SDLRequestType valueOf:@"LAUNCH_APP"]).to(equal([SDLRequestType LAUNCH_APP]));
        expect([SDLRequestType valueOf:@"LOCK_SCREEN_ICON_URL"]).to(equal([SDLRequestType LOCK_SCREEN_ICON_URL]));
        expect([SDLRequestType valueOf:@"TRAFFIC_MESSAGE_CHANNEL"]).to(equal([SDLRequestType TRAFFIC_MESSAGE_CHANNEL]));
        expect([SDLRequestType valueOf:@"DRIVER_PROFILE"]).to(equal([SDLRequestType DRIVER_PROFILE]));
        expect([SDLRequestType valueOf:@"VOICE_SEARCH"]).to(equal([SDLRequestType VOICE_SEARCH]));
        expect([SDLRequestType valueOf:@"NAVIGATION"]).to(equal([SDLRequestType NAVIGATION]));
        expect([SDLRequestType valueOf:@"PHONE"]).to(equal([SDLRequestType PHONE]));
        expect([SDLRequestType valueOf:@"CLIMATE"]).to(equal([SDLRequestType CLIMATE]));
        expect([SDLRequestType valueOf:@"SETTINGS"]).to(equal([SDLRequestType SETTINGS]));
        expect([SDLRequestType valueOf:@"VEHICLE_DIAGNOSTICS"]).to(equal([SDLRequestType VEHICLE_DIAGNOSTICS]));
        expect([SDLRequestType valueOf:@"EMERGENCY"]).to(equal([SDLRequestType EMERGENCY]));
        expect([SDLRequestType valueOf:@"MEDIA"]).to(equal([SDLRequestType MEDIA]));
        expect([SDLRequestType valueOf:@"FOTA"]).to(equal([SDLRequestType FOTA]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLRequestType valueOf:nil]).to(beNil());
        expect([SDLRequestType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});

describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLRequestType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLRequestType HTTP],
                           [SDLRequestType FILE_RESUME],
                           [SDLRequestType AUTH_REQUEST],
                           [SDLRequestType AUTH_CHALLENGE],
                           [SDLRequestType AUTH_ACK],
                           [SDLRequestType PROPRIETARY],
                           [SDLRequestType QUERY_APPS],
                           [SDLRequestType LAUNCH_APP],
                           [SDLRequestType LOCK_SCREEN_ICON_URL],
                           [SDLRequestType TRAFFIC_MESSAGE_CHANNEL],
                           [SDLRequestType DRIVER_PROFILE],
                           [SDLRequestType VOICE_SEARCH],
                           [SDLRequestType NAVIGATION],
                           [SDLRequestType PHONE],
                           [SDLRequestType CLIMATE],
                           [SDLRequestType SETTINGS],
                           [SDLRequestType VEHICLE_DIAGNOSTICS],
                           [SDLRequestType EMERGENCY],
                           [SDLRequestType MEDIA],
                           [SDLRequestType FOTA]] copy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd