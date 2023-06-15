//
//  SDLSeatControlDataSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLRPCParameterNames.h"
#import "SDLSeatControlData.h"
#import "SDLMassageModeData.h"
#import "SDLMassageCushionFirmness.h"
#import "SDLSeatMemoryAction.h"


QuickSpecBegin(SDLSeatControlDataSpec)

SDLMassageCushionFirmness *massageCushionFirmness = [[SDLMassageCushionFirmness alloc] init];
SDLMassageModeData *massageModeData = [[SDLMassageModeData alloc] init];
SDLSeatMemoryAction *seatMemoryAction = [[SDLSeatMemoryAction alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSeatControlData *testStruct = [[SDLSeatControlData alloc] init];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testStruct.id = SDLSupportedSeatDriver;
#pragma clang diagnostic pop

        testStruct.heatingEnabled = @NO;
        testStruct.coolingEnabled = @YES;
        testStruct.heatingLevel = @25;
        testStruct.coolingLevel = @10;

        testStruct.horizontalPosition = @23;
        testStruct.verticalPosition = @25;
        testStruct.frontVerticalPosition = @12;
        testStruct.backVerticalPosition = @34;
        testStruct.backTiltAngle = @12;

        testStruct.headSupportHorizontalPosition = @3;
        testStruct.headSupportVerticalPosition = @43;

        testStruct.massageEnabled = @YES;
        testStruct.massageMode = @[massageModeData];
        testStruct.massageCushionFirmness = @[massageCushionFirmness];
        testStruct.memory = seatMemoryAction;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.id).to(equal(SDLSupportedSeatDriver));
#pragma clang diagnostic pop
        expect(testStruct.heatingEnabled).to(equal(@NO));
        expect(testStruct.coolingEnabled).to(equal(@YES));
        expect(testStruct.heatingLevel).to(equal(@25));
        expect(testStruct.coolingLevel).to(equal(@10));
        expect(testStruct.horizontalPosition).to(equal(@23));
        expect(testStruct.verticalPosition).to(equal(@25));
        expect(testStruct.frontVerticalPosition).to(equal(@12));
        expect(testStruct.backVerticalPosition).to(equal(@34));
        expect(testStruct.backTiltAngle).to(equal(@12));
        expect(testStruct.headSupportHorizontalPosition).to(equal(@3));
        expect(testStruct.headSupportVerticalPosition).to(equal(@43));
        expect(testStruct.massageEnabled).to(equal(@YES));
        expect(testStruct.massageMode).to(equal(@[massageModeData]));
        expect(testStruct.massageCushionFirmness).to(equal(@[massageCushionFirmness]));
        expect(testStruct.memory).to(equal(seatMemoryAction));
    });

    it(@"Should get correctly when initialized with initWithHeatingEnabled:coolingEnabled:heatingLevel:coolingLevel:horizontalPosition:verticalPosition:frontVerticalPosition:backVerticalPosition:backTiltAngle:headSupportHorizontalPosition:headSupportVerticalPosition:massageEnabled:massageMode:massageCushionFirmness:memory:", ^ {
        SDLSeatControlData *testStruct = [[SDLSeatControlData alloc] initWithHeatingEnabled:@NO coolingEnabled:@YES heatingLevel:@25 coolingLevel:@10 horizontalPosition:@23 verticalPosition:@25 frontVerticalPosition:@12 backVerticalPosition:@25 backTiltAngle:@2 headSupportHorizontalPosition:@3 headSupportVerticalPosition:@43 massageEnabled:@YES massageMode:@[massageModeData] massageCushionFirmness:@[massageCushionFirmness] memory:seatMemoryAction];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.id).to(beNil());
#pragma clang diagnostic pop
        expect(testStruct.heatingEnabled).to(equal(@NO));
        expect(testStruct.coolingEnabled).to(equal(@YES));
        expect(testStruct.heatingLevel).to(equal(@25));
        expect(testStruct.coolingLevel).to(equal(@10));
        expect(testStruct.horizontalPosition).to(equal(@23));
        expect(testStruct.verticalPosition).to(equal(@25));
        expect(testStruct.frontVerticalPosition).to(equal(@12));
        expect(testStruct.backVerticalPosition).to(equal(@25));
        expect(testStruct.backTiltAngle).to(equal(@2));
        expect(testStruct.headSupportHorizontalPosition).to(equal(@3));
        expect(testStruct.headSupportVerticalPosition).to(equal(@43));
        expect(testStruct.massageEnabled).to(equal(@YES));
        expect(testStruct.massageMode).to(equal(@[massageModeData]));
        expect(testStruct.massageCushionFirmness).to(equal(@[massageCushionFirmness]));
        expect(testStruct.memory).to(equal(seatMemoryAction));
    });

    it(@"Should get correctly when initialized with initWithId:heatingEnabled:coolingEnable:heatingLevel:coolingLevel:horizontalPostion:verticalPostion:frontVerticalPostion:backVerticalPostion:backTiltAngle: headSupportedHorizontalPostion:headSupportedVerticalPostion:massageEnabled:massageMode:massageCussionFirmness:memory:", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSeatControlData *testStruct = [[SDLSeatControlData alloc] initWithId:SDLSupportedSeatDriver heatingEnabled:NO coolingEnable:YES heatingLevel:25 coolingLevel:10 horizontalPostion:23 verticalPostion:25 frontVerticalPostion:12 backVerticalPostion:25 backTiltAngle:2 headSupportedHorizontalPostion:3 headSupportedVerticalPostion:43 massageEnabled:YES massageMode:@[massageModeData] massageCussionFirmness:@[massageCushionFirmness] memory:seatMemoryAction];
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.id).to(equal(SDLSupportedSeatDriver));
#pragma clang diagnostic pop
        expect(testStruct.heatingEnabled).to(equal(@NO));
        expect(testStruct.coolingEnabled).to(equal(@YES));
        expect(testStruct.heatingLevel).to(equal(@25));
        expect(testStruct.coolingLevel).to(equal(@10));
        expect(testStruct.horizontalPosition).to(equal(@23));
        expect(testStruct.verticalPosition).to(equal(@25));
        expect(testStruct.frontVerticalPosition).to(equal(@12));
        expect(testStruct.backVerticalPosition).to(equal(@25));
        expect(testStruct.backTiltAngle).to(equal(@2));
        expect(testStruct.headSupportHorizontalPosition).to(equal(@3));
        expect(testStruct.headSupportVerticalPosition).to(equal(@43));
        expect(testStruct.massageEnabled).to(equal(@YES));
        expect(testStruct.massageMode).to(equal(@[massageModeData]));
        expect(testStruct.massageCushionFirmness).to(equal(@[massageCushionFirmness]));
        expect(testStruct.memory).to(equal(seatMemoryAction));
    });

    it(@"Should get correctly when initialized with initWithId:", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSeatControlData *testStruct = [[SDLSeatControlData alloc] initWithId:SDLSupportedSeatDriver];
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.id).to(equal(SDLSupportedSeatDriver));
#pragma clang diagnostic pop
        expect(testStruct.heatingEnabled).to(beNil());
        expect(testStruct.coolingEnabled).to(beNil());
        expect(testStruct.heatingLevel).to(beNil());
        expect(testStruct.coolingLevel).to(beNil());
        expect(testStruct.horizontalPosition).to(beNil());
        expect(testStruct.verticalPosition).to(beNil());
        expect(testStruct.frontVerticalPosition).to(beNil());
        expect(testStruct.backVerticalPosition).to(beNil());
        expect(testStruct.backTiltAngle).to(beNil());
        expect(testStruct.headSupportHorizontalPosition).to(beNil());
        expect(testStruct.headSupportVerticalPosition).to(beNil());
        expect(testStruct.massageEnabled).to(beNil());
        expect(testStruct.massageMode).to(beNil());
        expect(testStruct.massageCushionFirmness).to(beNil());
        expect(testStruct.memory).to(beNil());

    });

    it(@"Should get correctly when initialized with a dictionary", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSDictionary *dict = @{SDLRPCParameterNameId:SDLSupportedSeatDriver,
                                       SDLRPCParameterNameHeatingEnabled:@NO,
                                       SDLRPCParameterNameCoolingEnabled:@YES,
                                       SDLRPCParameterNameHeatingLevel:@25,
                                       SDLRPCParameterNameCoolingLevel:@10,
                                       SDLRPCParameterNameHorizontalPosition:@23,
                                       SDLRPCParameterNameVerticalPosition:@25,
                                       SDLRPCParameterNameFrontVerticalPosition:@12,
                                       SDLRPCParameterNameBackVerticalPosition:@34,
                                       SDLRPCParameterNameBackTiltAngle:@2,
                                       SDLRPCParameterNameHeadSupportHorizontalPosition:@3,
                                       SDLRPCParameterNameHeadSupportVerticalPosition:@43,
                                       SDLRPCParameterNameMassageEnabled:@YES,
                                       SDLRPCParameterNameMassageMode:@[massageModeData],
                                       SDLRPCParameterNameMassageCushionFirmness:@[massageCushionFirmness],
                                       SDLRPCParameterNameMemory:seatMemoryAction
                                       };
#pragma clang diagnostic pop

        SDLSeatControlData *testStruct = [[SDLSeatControlData alloc] initWithDictionary:dict];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.id).to(equal(SDLSupportedSeatDriver));
#pragma clang diagnostic pop
        expect(testStruct.heatingEnabled).to(equal(@NO));
        expect(testStruct.coolingEnabled).to(equal(@YES));
        expect(testStruct.heatingLevel).to(equal(@25));
        expect(testStruct.coolingLevel).to(equal(@10));
        expect(testStruct.horizontalPosition).to(equal(@23));
        expect(testStruct.verticalPosition).to(equal(@25));
        expect(testStruct.frontVerticalPosition).to(equal(@12));
        expect(testStruct.backVerticalPosition).to(equal(@34));
        expect(testStruct.backTiltAngle).to(equal(@2));
        expect(testStruct.headSupportHorizontalPosition).to(equal(@3));
        expect(testStruct.headSupportVerticalPosition).to(equal(@43));
        expect(testStruct.massageEnabled).to(equal(@YES));
        expect(testStruct.massageMode).to(equal(@[massageModeData]));
        expect(testStruct.massageCushionFirmness).to(equal(@[massageCushionFirmness]));
        expect(testStruct.memory).to(equal(seatMemoryAction));
    });

    it(@"Should return nil if not set", ^ {
        SDLSeatControlData *testStruct = [[SDLSeatControlData alloc] init];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(testStruct.id).to(beNil());
#pragma clang diagnostic pop
        expect(testStruct.heatingEnabled).to(beNil());
        expect(testStruct.coolingEnabled).to(beNil());
        expect(testStruct.heatingLevel).to(beNil());
        expect(testStruct.coolingLevel).to(beNil());
        expect(testStruct.horizontalPosition).to(beNil());
        expect(testStruct.verticalPosition).to(beNil());
        expect(testStruct.frontVerticalPosition).to(beNil());
        expect(testStruct.backVerticalPosition).to(beNil());
        expect(testStruct.backTiltAngle).to(beNil());
        expect(testStruct.headSupportHorizontalPosition).to(beNil());
        expect(testStruct.headSupportVerticalPosition).to(beNil());
        expect(testStruct.massageEnabled).to(beNil());
        expect(testStruct.massageMode).to(beNil());
        expect(testStruct.massageCushionFirmness).to(beNil());
        expect(testStruct.memory).to(beNil());
    });
});

QuickSpecEnd
