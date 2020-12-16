//
//  SDLEqualizerSettingsSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEqualizerSettings.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLEqualizerSettingsSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLEqualizerSettings* testStruct = [[SDLEqualizerSettings alloc] init];

        testStruct.channelId = @2;
        testStruct.channelName = @"channel";
        testStruct.channelSetting = @45;

        expect(testStruct.channelId).to(equal(@2));
        expect(testStruct.channelName).to(equal(@"channel"));
        expect(testStruct.channelSetting).to(equal(@45));
    });

    it(@"Should set and get correctly", ^ {
        SDLEqualizerSettings* testStruct = [[SDLEqualizerSettings alloc] initWithChannelId:2 channelSetting:45];

        expect(testStruct.channelId).to(equal(@2));
        expect(testStruct.channelName).to(beNil());
        expect(testStruct.channelSetting).to(equal(@45));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameChannelId:@2,
                                       SDLRPCParameterNameChannelName:@"channel",
                                       SDLRPCParameterNameChannelSetting:@45
                                       } mutableCopy];
        SDLEqualizerSettings* testStruct = [[SDLEqualizerSettings alloc] initWithDictionary:dict];

        expect(testStruct.channelId).to(equal(@2));
        expect(testStruct.channelName).to(equal(@"channel"));
        expect(testStruct.channelSetting).to(equal(@45));

    });

    it(@"Should return nil if not set", ^ {
        SDLEqualizerSettings* testStruct = [[SDLEqualizerSettings alloc] init];

        expect(testStruct.channelId).to(beNil());
        expect(testStruct.channelName).to(beNil());
        expect(testStruct.channelSetting).to(beNil());
    });
});

QuickSpecEnd
