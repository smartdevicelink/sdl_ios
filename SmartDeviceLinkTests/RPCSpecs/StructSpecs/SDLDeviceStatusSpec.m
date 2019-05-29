//
//  SDLDeviceStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeviceLevelStatus.h"
#import "SDLDeviceStatus.h"
#import "SDLRPCParameterNames.h"
#import "SDLPrimaryAudioSource.h"


QuickSpecBegin(SDLDeviceStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeviceStatus* testStruct = [[SDLDeviceStatus alloc] init];
        
        testStruct.voiceRecOn = @NO;
        testStruct.btIconOn = @NO;
        testStruct.callActive = @YES;
        testStruct.phoneRoaming = @NO;
        testStruct.textMsgAvailable = @YES;
        testStruct.battLevelStatus = SDLDeviceLevelStatusFourBars;
        testStruct.stereoAudioOutputMuted = @YES;
        testStruct.monoAudioOutputMuted = @YES;
        testStruct.signalLevelStatus = SDLDeviceLevelStatusTwoBars;
        testStruct.primaryAudioSource = SDLPrimaryAudioSourceBluetoothStereo;
        testStruct.eCallEventActive = @NO;
        
        expect(testStruct.voiceRecOn).to(equal(@NO));
        expect(testStruct.btIconOn).to(equal(@NO));
        expect(testStruct.callActive).to(equal(@YES));
        expect(testStruct.phoneRoaming).to(equal(@NO));
        expect(testStruct.textMsgAvailable).to(equal(@YES));
        expect(testStruct.battLevelStatus).to(equal(SDLDeviceLevelStatusFourBars));
        expect(testStruct.stereoAudioOutputMuted).to(equal(@YES));
        expect(testStruct.monoAudioOutputMuted).to(equal(@YES));
        expect(testStruct.signalLevelStatus).to(equal(SDLDeviceLevelStatusTwoBars));
        expect(testStruct.primaryAudioSource).to(equal(SDLPrimaryAudioSourceBluetoothStereo));
        expect(testStruct.eCallEventActive).to(equal(@NO));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameVoiceRecognitionOn:@NO,
                                       SDLRPCParameterNameBluetoothIconOn:@NO,
                                       SDLRPCParameterNameCallActive:@YES,
                                       SDLRPCParameterNamePhoneRoaming:@NO,
                                       SDLRPCParameterNameTextMessageAvailable:@YES,
                                       SDLRPCParameterNameBatteryLevelStatus:SDLDeviceLevelStatusFourBars,
                                       SDLRPCParameterNameStereoAudioOutputMuted:@YES,
                                       SDLRPCParameterNameMonoAudioOutputMuted:@YES,
                                       SDLRPCParameterNameSignalLevelStatus:SDLDeviceLevelStatusTwoBars,
                                       SDLRPCParameterNamePrimaryAudioSource:SDLPrimaryAudioSourceBluetoothStereo,
                                       SDLRPCParameterNameECallEventActive:@NO} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLDeviceStatus* testStruct = [[SDLDeviceStatus alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.voiceRecOn).to(equal(@NO));
        expect(testStruct.btIconOn).to(equal(@NO));
        expect(testStruct.callActive).to(equal(@YES));
        expect(testStruct.phoneRoaming).to(equal(@NO));
        expect(testStruct.textMsgAvailable).to(equal(@YES));
        expect(testStruct.battLevelStatus).to(equal(SDLDeviceLevelStatusFourBars));
        expect(testStruct.stereoAudioOutputMuted).to(equal(@YES));
        expect(testStruct.monoAudioOutputMuted).to(equal(@YES));
        expect(testStruct.signalLevelStatus).to(equal(SDLDeviceLevelStatusTwoBars));
        expect(testStruct.primaryAudioSource).to(equal(SDLPrimaryAudioSourceBluetoothStereo));
        expect(testStruct.eCallEventActive).to(equal(@NO));
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
