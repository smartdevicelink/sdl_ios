//
//  SDLRadioControlCapabilitiesSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRadioControlCapabilities.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLRadioControlCapabilitiesSpec)

describe(@"Initialization tests", ^{
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

    it(@"should properly initialize init", ^{
        SDLRadioControlCapabilities* testStruct = [[SDLRadioControlCapabilities alloc] init];
        
        expect(testStruct.moduleName).to(beNil());
        expect(testStruct.moduleInfo).to(beNil());
        expect(testStruct.radioEnableAvailable).to(beNil());
        expect(testStruct.radioBandAvailable).to(beNil());
        expect(testStruct.radioFrequencyAvailable).to(beNil());
        expect(testStruct.hdChannelAvailable).to(beNil());
        expect(testStruct.rdsDataAvailable).to(beNil());
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.availableHDsAvailable).to(beNil());
#pragma clang diagnostic pop
        
        expect(testStruct.availableHDChannelsAvailable).to(beNil());
        expect(testStruct.stateAvailable).to(beNil());
        expect(testStruct.signalStrengthAvailable).to(beNil());
        expect(testStruct.signalChangeThresholdAvailable).to(beNil());
        expect(testStruct.hdRadioEnableAvailable).to(beNil());
        expect(testStruct.siriusXMRadioAvailable).to(beNil());
        expect(testStruct.sisDataAvailable).to(beNil());
    });
    
    it(@"should properly initialize initWithDictionary", ^{
        
        NSDictionary *dict = @{SDLRPCParameterNameModuleName : @"someName",
                                       SDLRPCParameterNameModuleInfo: testModuleInfo,
                                       SDLRPCParameterNameRadioEnableAvailable : @YES,
                                       SDLRPCParameterNameRadioBandAvailable : @YES,
                                       SDLRPCParameterNameRadioFrequencyAvailable : @YES,
                                       SDLRPCParameterNameHDChannelAvailable : @NO,
                                       SDLRPCParameterNameRDSDataAvailable : @NO,
                                       SDLRPCParameterNameAvailableHDsAvailable : @NO,
                                       SDLRPCParameterNameAvailableHDChannelsAvailable : @NO,
                                       SDLRPCParameterNameStateAvailable : @YES,
                                       SDLRPCParameterNameSignalStrengthAvailable : @YES,
                                       SDLRPCParameterNameSignalChangeThresholdAvailable : @NO,
                                       SDLRPCParameterNameHDRadioEnableAvailable : @YES,
                                       SDLRPCParameterNameSiriusXMRadioAvailable : @NO,
                                       SDLRPCParameterNameSISDataAvailable: @YES
                                       };
        SDLRadioControlCapabilities *testStruct = [[SDLRadioControlCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.moduleName).to(equal(@"someName"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.radioEnableAvailable).to(equal(@YES));
        expect(testStruct.radioBandAvailable).to(equal(@YES));
        expect(testStruct.radioFrequencyAvailable).to(equal(@YES));
        expect(testStruct.hdChannelAvailable).to(equal(@NO));
        expect(testStruct.rdsDataAvailable).to(equal(@NO));
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.availableHDsAvailable).to(equal(@NO));
#pragma clang diagnostic pop
        
        expect(testStruct.availableHDChannelsAvailable).to(equal(@NO));
        expect(testStruct.stateAvailable).to(equal(@YES));
        expect(testStruct.signalStrengthAvailable).to(equal(@YES));
        expect(testStruct.signalChangeThresholdAvailable).to(equal(@NO));
        expect(testStruct.hdRadioEnableAvailable).to(equal(@YES));
        expect(testStruct.siriusXMRadioAvailable).to(equal(@NO));
        expect(testStruct.sisDataAvailable).to(equal(@YES));
    });
    
    it(@"Should set and get correctly", ^{
        SDLRadioControlCapabilities* testStruct = [[SDLRadioControlCapabilities alloc] init];
        
        testStruct.moduleName  = @"someName";
        testStruct.moduleInfo = testModuleInfo;
        testStruct.radioEnableAvailable = @YES;
        testStruct.radioBandAvailable = @YES;
        testStruct.radioFrequencyAvailable = @YES;
        testStruct.hdChannelAvailable = @NO;
        testStruct.rdsDataAvailable = @NO;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testStruct.availableHDsAvailable = @NO;
#pragma clang diagnostic pop
        
        testStruct.availableHDChannelsAvailable = @NO;
        testStruct.stateAvailable = @YES;
        testStruct.signalStrengthAvailable = @YES;
        testStruct.signalChangeThresholdAvailable = @NO;
        testStruct.hdRadioEnableAvailable = @YES;
        testStruct.siriusXMRadioAvailable = @YES;
        testStruct.sisDataAvailable = @YES;
        
        expect(testStruct.moduleName).to(equal(@"someName"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.radioEnableAvailable).to(equal(@YES));
        expect(testStruct.radioBandAvailable).to(equal(@YES));
        expect(testStruct.radioFrequencyAvailable).to(equal(@YES));
        expect(testStruct.hdChannelAvailable).to(equal(@NO));
        expect(testStruct.rdsDataAvailable).to(equal(@NO));
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.availableHDsAvailable).to(equal(@NO));
#pragma clang diagnostic pop
        
        expect(testStruct.availableHDChannelsAvailable).to(equal(@NO));
        expect(testStruct.stateAvailable).to(equal(@YES));
        expect(testStruct.signalStrengthAvailable).to(equal(@YES));
        expect(testStruct.signalChangeThresholdAvailable).to(equal(@NO));
        expect(testStruct.hdRadioEnableAvailable).to(equal(@YES));
        expect(testStruct.siriusXMRadioAvailable).to(equal(@YES));
        expect(testStruct.sisDataAvailable).to(equal(@YES));
    });

    it(@"Should get correctly when initialized with Module Name and other radio control capabilite's parameters", ^ {
    SDLRadioControlCapabilities* testStruct = [[SDLRadioControlCapabilities alloc] initWithModuleName:@"someName" moduleInfo:testModuleInfo radioEnableAvailable:YES radioBandAvailable:NO radioFrequencyAvailable:YES hdChannelAvailable:NO rdsDataAvailable:NO availableHDChannelsAvailable:NO stateAvailable:YES signalStrengthAvailable:YES signalChangeThresholdAvailable:NO hdRadioEnableAvailable:YES siriusXMRadioAvailable:YES sisDataAvailable:YES];

        expect(testStruct.moduleName).to(equal(@"someName"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.radioEnableAvailable).to(equal(@YES));
        expect(testStruct.radioBandAvailable).to(equal(@NO));
        expect(testStruct.radioFrequencyAvailable).to(equal(@YES));
        expect(testStruct.hdChannelAvailable).to(equal(@NO));
        expect(testStruct.rdsDataAvailable).to(equal(@NO));
        expect(testStruct.availableHDChannelsAvailable).to(equal(@NO));
        expect(testStruct.stateAvailable).to(equal(@YES));
        expect(testStruct.signalStrengthAvailable).to(equal(@YES));
        expect(testStruct.signalChangeThresholdAvailable).to(equal(@NO));
        expect(testStruct.hdRadioEnableAvailable).to(equal(YES));
        expect(testStruct.siriusXMRadioAvailable).to(equal(@YES));
        expect(testStruct.sisDataAvailable).to(equal(@YES));
    });
});

QuickSpecEnd
