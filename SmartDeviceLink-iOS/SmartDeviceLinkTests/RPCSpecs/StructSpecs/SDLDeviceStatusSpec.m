//
//  SDLDeviceStatusSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeviceStatus.h"
#import "SDLNames.h"

QuickSpecBegin(SDLDeviceStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeviceStatus* testStruct = [[SDLDeviceStatus alloc] init];
        
        testStruct.voiceRecOn = [NSNumber numberWithBool:NO];
        testStruct.btIconOn = [NSNumber numberWithBool:NO];
        testStruct.callActive = [NSNumber numberWithBool:YES];
        testStruct.phoneRoaming = [NSNumber numberWithBool:NO];
        testStruct.textMsgAvailable = [NSNumber numberWithBool:YES];
        testStruct.battLevelStatus = [SDLDeviceLevelStatus FOUR_LEVEL_BARS];
        testStruct.stereoAudioOutputMuted = [NSNumber numberWithBool:YES];
        testStruct.monoAudioOutputMuted = [NSNumber numberWithBool:YES];
        testStruct.signalLevelStatus = [SDLDeviceLevelStatus TWO_LEVEL_BARS];
        testStruct.primaryAudioSource = [SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST];
        testStruct.eCallEventActive = [NSNumber numberWithBool:NO];
        
        expect(testStruct.voiceRecOn).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.btIconOn).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.callActive).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.phoneRoaming).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.textMsgAvailable).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.battLevelStatus).to(equal([SDLDeviceLevelStatus FOUR_LEVEL_BARS]));
        expect(testStruct.stereoAudioOutputMuted).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.monoAudioOutputMuted).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.signalLevelStatus).to(equal([SDLDeviceLevelStatus TWO_LEVEL_BARS]));
        expect(testStruct.primaryAudioSource).to(equal([SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST]));
        expect(testStruct.eCallEventActive).to(equal([NSNumber numberWithBool:NO]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_voiceRecOn:[NSNumber numberWithBool:NO],
                                       NAMES_btIconOn:[NSNumber numberWithBool:NO],
                                       NAMES_callActive:[NSNumber numberWithBool:YES],
                                       NAMES_phoneRoaming:[NSNumber numberWithBool:NO],
                                       NAMES_textMsgAvailable:[NSNumber numberWithBool:YES],
                                       NAMES_battLevelStatus:[SDLDeviceLevelStatus FOUR_LEVEL_BARS],
                                       NAMES_stereoAudioOutputMuted:[NSNumber numberWithBool:YES],
                                       NAMES_monoAudioOutputMuted:[NSNumber numberWithBool:YES],
                                       NAMES_signalLevelStatus:[SDLDeviceLevelStatus TWO_LEVEL_BARS],
                                       NAMES_primaryAudioSource:[SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST],
                                       NAMES_eCallEventActive:[NSNumber numberWithBool:NO]} mutableCopy];
        SDLDeviceStatus* testStruct = [[SDLDeviceStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.voiceRecOn).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.btIconOn).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.callActive).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.phoneRoaming).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.textMsgAvailable).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.battLevelStatus).to(equal([SDLDeviceLevelStatus FOUR_LEVEL_BARS]));
        expect(testStruct.stereoAudioOutputMuted).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.monoAudioOutputMuted).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.signalLevelStatus).to(equal([SDLDeviceLevelStatus TWO_LEVEL_BARS]));
        expect(testStruct.primaryAudioSource).to(equal([SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST]));
        expect(testStruct.eCallEventActive).to(equal([NSNumber numberWithBool:NO]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLDeviceStatus* testStruct = [[SDLDeviceStatus alloc] init];
        
        expect(testStruct.voiceRecOn).to(beNil());
        expect(testStruct.btIconOn).to(beNil());
        expect(testStruct.callActive).to(beNil());
        expect(testStruct.phoneRoaming).to(beNil());
        expect(testStruct.textMsgAvailable).to(beNil());
        expect(testStruct.battLevelStatus).to(beNil());
        expect(testStruct.stereoAudioOutputMuted).to(beNil());
        expect(testStruct.monoAudioOutputMuted).to(beNil());
        expect(testStruct.signalLevelStatus).to(beNil());
        expect(testStruct.primaryAudioSource).to(beNil());
        expect(testStruct.eCallEventActive).to(beNil());
    });
});

QuickSpecEnd