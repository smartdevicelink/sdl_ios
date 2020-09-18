//
//  SDLSeatControlCapabilitiesSpec.m
//  SmartDeviceLinkTests
//
#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLSeatControlCapabilities.h"


QuickSpecBegin(SDLSeatControlCapabilitiesSpec)

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
        SDLSeatControlCapabilities* testStruct = [[SDLSeatControlCapabilities alloc] init];

        testStruct.moduleName = @"moduleName";
        testStruct.moduleInfo = testModuleInfo;
        testStruct.heatingEnabledAvailable = @YES;
        testStruct.coolingEnabledAvailable = @NO;
        testStruct.heatingLevelAvailable = @YES;
        testStruct.coolingLevelAvailable = @NO;
        testStruct.horizontalPositionAvailable = @NO;
        testStruct.verticalPositionAvailable = @NO;
        testStruct.frontVerticalPositionAvailable = @NO;
        testStruct.backVerticalPositionAvailable = @NO;
        testStruct.backTiltAngleAvailable = @YES;
        testStruct.headSupportVerticalPositionAvailable = @NO;
        testStruct.headSupportHorizontalPositionAvailable = @YES;
        testStruct.massageEnabledAvailable = @NO;
        testStruct.massageModeAvailable = @YES;
        testStruct.massageCushionFirmnessAvailable = @NO;
        testStruct.memoryAvailable = @NO;

        expect(testStruct.moduleName).to(equal(@"moduleName"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.heatingEnabledAvailable).to(equal(@YES));
        expect(testStruct.coolingEnabledAvailable).to(equal(@NO));
        expect(testStruct.heatingLevelAvailable).to(equal(@YES));
        expect(testStruct.coolingLevelAvailable).to(equal(@NO));
        expect(testStruct.horizontalPositionAvailable).to(equal(@NO));
        expect(testStruct.verticalPositionAvailable).to(equal(@NO));
        expect(testStruct.frontVerticalPositionAvailable).to(equal(@NO));
        expect(testStruct.backVerticalPositionAvailable).to(equal(@NO));
        expect(testStruct.backTiltAngleAvailable).to(equal(@YES));
        expect(testStruct.headSupportVerticalPositionAvailable).to(equal(@NO));
        expect(testStruct.headSupportHorizontalPositionAvailable).to(equal(@YES));
        expect(testStruct.massageEnabledAvailable).to(equal(@NO));
        expect(testStruct.massageModeAvailable).to(equal(@YES));
        expect(testStruct.massageCushionFirmnessAvailable).to(equal(@NO));
        expect(testStruct.memoryAvailable).to(equal(@NO));
    });
    
    it(@"Should set and get correctly", ^ {
        SDLSeatControlCapabilities* testStruct = [[SDLSeatControlCapabilities alloc] initWithName:@"moduleName" moduleInfo:testModuleInfo];
        
        expect(testStruct.moduleName).to(equal(@"moduleName"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.heatingEnabledAvailable).to(beNil());
        expect(testStruct.heatingEnabledAvailable).to(beNil());
        expect(testStruct.heatingLevelAvailable).to(beNil());
        expect(testStruct.coolingLevelAvailable).to(beNil());
        expect(testStruct.horizontalPositionAvailable).to(beNil());
        expect(testStruct.verticalPositionAvailable).to(beNil());
        expect(testStruct.frontVerticalPositionAvailable).to(beNil());
        expect(testStruct.backVerticalPositionAvailable).to(beNil());
        expect(testStruct.backTiltAngleAvailable).to(beNil());
        expect(testStruct.headSupportHorizontalPositionAvailable).to(beNil());
        expect(testStruct.headSupportVerticalPositionAvailable).to(beNil());
        expect(testStruct.massageEnabledAvailable).to(beNil());
        expect(testStruct.massageModeAvailable).to(beNil());
        expect(testStruct.massageCushionFirmnessAvailable).to(beNil());
        expect(testStruct.memoryAvailable).to(beNil());
    });
    
    it(@"Should set and get correctly", ^ {
        SDLSeatControlCapabilities* testStruct = [[SDLSeatControlCapabilities alloc] initWithName:@"moduleName" moduleInfo:testModuleInfo heatingEnabledAvailable:YES coolingEnabledAvailable:NO heatingLevelAvailable:YES coolingLevelAvailable:NO horizontalPositionAvailable:NO verticalPositionAvailable:NO frontVerticalPositionAvailable:NO backVerticalPositionAvailable:NO backTiltAngleAvailable:YES headSupportHorizontalPositionAvailable:NO headSupportVerticalPositionAvailable:YES massageEnabledAvailable:NO massageModeAvailable:YES massageCushionFirmnessAvailable:NO memoryAvailable:YES];
        
        expect(testStruct.moduleName).to(equal(@"moduleName"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.heatingEnabledAvailable).to(equal(@YES));
        expect(testStruct.coolingEnabledAvailable).to(equal(@NO));
        expect(testStruct.heatingLevelAvailable).to(equal(@YES));
        expect(testStruct.coolingLevelAvailable).to(equal(@NO));
        expect(testStruct.horizontalPositionAvailable).to(equal(@NO));
        expect(testStruct.verticalPositionAvailable).to(equal(@NO));
        expect(testStruct.frontVerticalPositionAvailable).to(equal(@NO));
        expect(testStruct.backVerticalPositionAvailable).to(equal(@NO));
        expect(testStruct.backTiltAngleAvailable).to(equal(@YES));
        expect(testStruct.headSupportHorizontalPositionAvailable).to(equal(@NO));
        expect(testStruct.headSupportVerticalPositionAvailable).to(equal(@YES));
        expect(testStruct.massageEnabledAvailable).to(equal(@NO));
        expect(testStruct.massageModeAvailable).to(equal(@YES));
        expect(testStruct.massageCushionFirmnessAvailable).to(equal(@NO));
        expect(testStruct.memoryAvailable).to(equal(@YES));
        
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameModuleName:@"moduleName",
                                       SDLRPCParameterNameModuleInfo:testModuleInfo,
                                       SDLRPCParameterNameHeatingEnabledAvailable:(@YES),
                                       SDLRPCParameterNameCoolingEnabledAvailable:@YES,
                                       SDLRPCParameterNameHeatingLevelAvailable:@YES,
                                       SDLRPCParameterNameCoolingLevelAvailable:@NO,
                                       SDLRPCParameterNameHorizontalPositionAvailable:@NO,
                                       SDLRPCParameterNameVerticalPositionAvailable:@NO,
                                       SDLRPCParameterNameFrontVerticalPositionAvailable:@NO,
                                       SDLRPCParameterNameBackVerticalPositionAvailable:@NO,
                                       SDLRPCParameterNameBackTiltAngleAvailable:@YES,
                                       SDLRPCParameterNameHeadSupportHorizontalPositionAvailable:@NO,
                                       SDLRPCParameterNameHeadSupportVerticalPositionAvailable:@YES,
                                       SDLRPCParameterNameMassageEnabledAvailable:@NO,
                                       SDLRPCParameterNameMassageModeAvailable:@YES,
                                       SDLRPCParameterNameMassageCushionFirmnessAvailable:@NO,
                                       SDLRPCParameterNameMemoryAvailable:@NO
                                       } mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSeatControlCapabilities *testStruct = [[SDLSeatControlCapabilities alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.moduleName).to(equal(@"moduleName"));
        expect(testStruct.moduleInfo).to(equal(testModuleInfo));
        expect(testStruct.heatingEnabledAvailable).to(equal(@YES));
        expect(testStruct.coolingEnabledAvailable).to(equal(@YES));
        expect(testStruct.heatingLevelAvailable).to(equal(@YES));
        expect(testStruct.coolingLevelAvailable).to(equal(@NO));
        expect(testStruct.horizontalPositionAvailable).to(equal(@NO));
        expect(testStruct.verticalPositionAvailable).to(equal(@NO));
        expect(testStruct.frontVerticalPositionAvailable).to(equal(@NO));
        expect(testStruct.backVerticalPositionAvailable).to(equal(@NO));
        expect(testStruct.backTiltAngleAvailable).to(equal(@YES));
        expect(testStruct.headSupportHorizontalPositionAvailable).to(equal(@NO));
        expect(testStruct.headSupportVerticalPositionAvailable).to(equal(@YES));
        expect(testStruct.massageEnabledAvailable).to(equal(@NO));
        expect(testStruct.massageModeAvailable).to(equal(@YES));
        expect(testStruct.massageCushionFirmnessAvailable).to(equal(@NO));
        expect(testStruct.memoryAvailable).to(equal(@NO));
    });

    it(@"Should return nil if not set", ^ {
        SDLSeatControlCapabilities* testStruct = [[SDLSeatControlCapabilities alloc] init];

        expect(testStruct.moduleName).to(beNil());
        expect(testStruct.moduleInfo).to(beNil());
        expect(testStruct.heatingEnabledAvailable).to(beNil());
        expect(testStruct.heatingEnabledAvailable).to(beNil());
        expect(testStruct.heatingLevelAvailable).to(beNil());
        expect(testStruct.coolingLevelAvailable).to(beNil());
        expect(testStruct.horizontalPositionAvailable).to(beNil());
        expect(testStruct.verticalPositionAvailable).to(beNil());
        expect(testStruct.frontVerticalPositionAvailable).to(beNil());
        expect(testStruct.backVerticalPositionAvailable).to(beNil());
        expect(testStruct.backTiltAngleAvailable).to(beNil());
        expect(testStruct.headSupportHorizontalPositionAvailable).to(beNil());
        expect(testStruct.headSupportVerticalPositionAvailable).to(beNil());
        expect(testStruct.massageEnabledAvailable).to(beNil());
        expect(testStruct.massageModeAvailable).to(beNil());
        expect(testStruct.massageCushionFirmnessAvailable).to(beNil());
        expect(testStruct.memoryAvailable).to(beNil());
    });
});

QuickSpecEnd
