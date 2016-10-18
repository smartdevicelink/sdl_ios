//
//  SDLDeviceStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeviceLevelStatus.h"
#import "SDLDeviceStatus.h"
#import "SDLNames.h"
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
        testStruct.battLevelStatus = [SDLDeviceLevelStatus FOUR_LEVEL_BARS];
        testStruct.stereoAudioOutputMuted = @YES;
        testStruct.monoAudioOutputMuted = @YES;
        testStruct.signalLevelStatus = [SDLDeviceLevelStatus TWO_LEVEL_BARS];
        testStruct.primaryAudioSource = [SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST];
        testStruct.eCallEventActive = @NO;
        
        expect(testStruct.voiceRecOn).to(equal(@NO));
        expect(testStruct.btIconOn).to(equal(@NO));
        expect(testStruct.callActive).to(equal(@YES));
        expect(testStruct.phoneRoaming).to(equal(@NO));
        expect(testStruct.textMsgAvailable).to(equal(@YES));
        expect(testStruct.battLevelStatus).to(equal([SDLDeviceLevelStatus FOUR_LEVEL_BARS]));
        expect(testStruct.stereoAudioOutputMuted).to(equal(@YES));
        expect(testStruct.monoAudioOutputMuted).to(equal(@YES));
        expect(testStruct.signalLevelStatus).to(equal([SDLDeviceLevelStatus TWO_LEVEL_BARS]));
        expect(testStruct.primaryAudioSource).to(equal([SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST]));
        expect(testStruct.eCallEventActive).to(equal(@NO));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameVoiceRecognitionOn:@NO,
                                                       SDLNameBluetoothIconOn:@NO,
                                                       SDLNameCallActive:@YES,
                                                       SDLNamePhoneRoaming:@NO,
                                                       SDLNameTextMessageAvailable:@YES,
                                                       SDLNameBatteryLevelStatus:[SDLDeviceLevelStatus FOUR_LEVEL_BARS],
                                                       SDLNameStereoAudioOutputMuted:@YES,
                                                       SDLNameMonoAudioOutputMuted:@YES,
                                                       SDLNameSignalLevelStatus:[SDLDeviceLevelStatus TWO_LEVEL_BARS],
                                                       SDLNamePrimaryAudioSource:[SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST],
                                                       SDLNameECallEventActive:@NO} mutableCopy];
        SDLDeviceStatus* testStruct = [[SDLDeviceStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.voiceRecOn).to(equal(@NO));
        expect(testStruct.btIconOn).to(equal(@NO));
        expect(testStruct.callActive).to(equal(@YES));
        expect(testStruct.phoneRoaming).to(equal(@NO));
        expect(testStruct.textMsgAvailable).to(equal(@YES));
        expect(testStruct.battLevelStatus).to(equal([SDLDeviceLevelStatus FOUR_LEVEL_BARS]));
        expect(testStruct.stereoAudioOutputMuted).to(equal(@YES));
        expect(testStruct.monoAudioOutputMuted).to(equal(@YES));
        expect(testStruct.signalLevelStatus).to(equal([SDLDeviceLevelStatus TWO_LEVEL_BARS]));
        expect(testStruct.primaryAudioSource).to(equal([SDLPrimaryAudioSource BLUETOOTH_STEREO_BTST]));
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
