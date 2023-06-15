//
//  SDLAudioControlCapabilitiesSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLAudioControlCapabilities.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin( SDLAudioControlCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLModuleInfo *testModuleInfo = nil;
    __block SDLGrid *testGird = nil;
    
    beforeEach(^{
        testGird.col = @0;
        testGird.row = @0;
        testGird.level = @0;
        testGird.rowspan = @2;
        testGird.colspan = @3;
        testGird.levelspan = @1;
        testModuleInfo = [[SDLModuleInfo alloc] init];
        testModuleInfo.moduleId = @"123";
        testModuleInfo.allowMultipleAccess = @YES;
        testModuleInfo.serviceArea = testGird;
        testModuleInfo.location = testGird;
    });

    it(@"Should set and get correctly", ^ {
        SDLAudioControlCapabilities *testStruct = [[SDLAudioControlCapabilities alloc] init];

        testStruct.moduleName = @"module";
        testStruct.moduleInfo = testModuleInfo;
        testStruct.sourceAvailable = @(YES);
        testStruct.keepContextAvailable = @YES;
        testStruct.volumeAvailable = @(NO);
        testStruct.equalizerAvailable = @(NO);
        testStruct.equalizerMaxChannelId = @56;

        expect(testStruct.moduleName).to(equal(@"module"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.keepContextAvailable).to(equal(@YES));
        expect(testStruct.sourceAvailable).to(equal(@(YES)));
        expect(testStruct.volumeAvailable).to(equal(@(NO)));
        expect(testStruct.equalizerAvailable).to(equal(@(NO)));
        expect(testStruct.equalizerMaxChannelId).to(equal(@56));
    });

    it(@"Should initialize correctly with initWithModuleName:moduleInfo:", ^ {
        SDLAudioControlCapabilities *testStruct = [[SDLAudioControlCapabilities alloc] initWithModuleName:@"module" moduleInfo:testModuleInfo];
        
        expect(testStruct.moduleName).to(equal(@"module"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.sourceAvailable).to(beNil());
        expect(testStruct.keepContextAvailable).to(beNil());
        expect(testStruct.volumeAvailable).to(beNil());
        expect(testStruct.equalizerAvailable).to(beNil());
        expect(testStruct.equalizerMaxChannelId).to(beNil());
    });
    
    it(@"Should initialize correctly with initWithModuleName:moduleInfo:sourceAvailable:keepContextAvailable:volumeAvailable:equalizerAvailable:equalizerMaxChannelID:", ^ {
        SDLAudioControlCapabilities *testStruct = [[SDLAudioControlCapabilities alloc] initWithModuleName:@"module" moduleInfo:testModuleInfo sourceAvailable:@NO keepContextAvailable:@NO volumeAvailable:@YES equalizerAvailable:@NO equalizerMaxChannelID:@34];

        expect(testStruct.moduleName).to(equal(@"module"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.sourceAvailable).to(equal(@(NO)));
        expect(testStruct.keepContextAvailable).to(equal(@NO));
        expect(testStruct.volumeAvailable).to(equal(@(YES)));
        expect(testStruct.equalizerAvailable).to(equal(@(NO)));
        expect(testStruct.equalizerMaxChannelId).to(equal(@34));
    });

    it(@"Should initialize correctly with a dictionary", ^ {
        NSDictionary *dict = @{SDLRPCParameterNameModuleName:@"module",
                               SDLRPCParameterNameModuleInfo:testModuleInfo,
                               SDLRPCParameterNameSourceAvailable:@(NO),
                               SDLRPCParameterNameKeepContextAvailable: @YES,
                               SDLRPCParameterNameVolumeAvailable:@(YES),
                               SDLRPCParameterNameEqualizerAvailable:@(NO),
                               SDLRPCParameterNameEqualizerMaxChannelId:@12
        };
        SDLAudioControlCapabilities *testStruct = [[SDLAudioControlCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.moduleName).to(equal(@"module"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.sourceAvailable).to(equal(@(NO)));
        expect(testStruct.keepContextAvailable).to(equal(@YES));
        expect(testStruct.volumeAvailable).to(equal(@(YES)));
        expect(testStruct.equalizerAvailable).to(equal(@(NO)));
        expect(testStruct.equalizerMaxChannelId).to(equal(@12));
    });

    it(@"Should return nil if not set", ^ {
        SDLAudioControlCapabilities *testStruct = [[SDLAudioControlCapabilities alloc] init];

        expect(testStruct.moduleName).to(beNil());
        expect(testStruct.moduleInfo).to(beNil());
        expect(testStruct.sourceAvailable).to(beNil());
        expect(testStruct.keepContextAvailable).to(beNil());
        expect(testStruct.volumeAvailable).to(beNil());
        expect(testStruct.equalizerAvailable).to(beNil());
        expect(testStruct.equalizerMaxChannelId).to(beNil());
    });
});

QuickSpecEnd
