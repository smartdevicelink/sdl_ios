//
//  SDLSeatControlCapabilitiesSpec.m
//  SmartDeviceLinkTests
//
#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSeatControlCapabilities.h"


QuickSpecBegin(SDLSeatControlCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSeatControlCapabilities* testStruct = [[SDLSeatControlCapabilities alloc] init];

        testStruct.moduleName = @"moduleName";
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
        SDLSeatControlCapabilities* testStruct = [[SDLSeatControlCapabilities alloc] initWithName:@"moduleName" heatingEnabledAvailable:YES coolingEnabledAvailable:NO heatingLevelAvailable:YES coolingLevelAvailable:NO horizontalPositionAvailable:NO verticalPositionAvailable:NO frontVerticalPositionAvailable:NO backVerticalPositionAvailable:NO backTiltAngleAvailable:YES headSupportHorizontalPositionAvailable:NO headSupportVerticalPositionAvailable:YES massageEnabledAvailable:NO massageModeAvailable:YES massageCushionFirmnessAvailable:NO memoryAvailable:YES];

        expect(testStruct.moduleName).to(equal(@"moduleName"));
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

    it(@"Should set and get correctly", ^ {
        SDLSeatControlCapabilities* testStruct = [[SDLSeatControlCapabilities alloc] initWithName:@"moduleName"];

        expect(testStruct.moduleName).to(equal(@"moduleName"));
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

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameModuleName:@"moduleName",
                                       SDLNameHeatingEnabledAvailable:(@YES),
                                       SDLNameCoolingEnabledAvailable:@YES,
                                       SDLNameHeatingLevelAvailable:@YES,
                                       SDLNameCoolingLevelAvailable:@NO,
                                       SDLNameHorizontalPositionAvailable:@NO,
                                       SDLNameVerticalPositionAvailable:@NO,
                                       SDLNameFrontVerticalPositionAvailable:@NO,
                                       SDLNameBackVerticalPositionAvailable:@NO,
                                       SDLNameBackTiltAngleAvailable:@YES,
                                       SDLNameHeadSupportHorizontalPositionAvailable:@NO,
                                       SDLNameHeadSupportVerticalPositionAvailable:@YES,
                                       SDLNameMassageEnabledAvailable:@NO,
                                       SDLNameMassageModeAvailable:@YES,
                                       SDLNameMassageCushionFirmnessAvailable:@NO,
                                       SDLNameMemoryAvailable:@NO
                                       } mutableCopy];
        SDLSeatControlCapabilities *testStruct = [[SDLSeatControlCapabilities alloc] initWithDictionary:dict];

        expect(testStruct.moduleName).to(equal(@"moduleName"));
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
