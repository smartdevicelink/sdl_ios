//
//  SDLSeatControlDataSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSeatControlData.h"
#import "SDLMassageModeData.h"
#import "SDLMassageCushionFirmness.h"
#import "SDLSeatMemoryAction.h"


QuickSpecBegin(SDLSeatControlDataSpec)

SDLMassageCushionFirmness* massageCushionFirmness = [[SDLMassageCushionFirmness alloc] init];
SDLMassageModeData *massageModeData = [[SDLMassageModeData alloc] init];
SDLSeatMemoryAction *seatMemoryAction = [[SDLSeatMemoryAction alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSeatControlData* testStruct = [[SDLSeatControlData alloc] init];

        testStruct.id = SDLSupportedSeatDriver;
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
        testStruct.massageMode = [@[massageModeData] copy];
        testStruct.massageCushionFirmness = [@[massageCushionFirmness] copy];
        testStruct.memory = seatMemoryAction;

        expect(testStruct.id).to(equal(SDLSupportedSeatDriver));
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
        expect(testStruct.massageMode).to(equal([@[massageModeData] copy]));
        expect(testStruct.massageCushionFirmness).to(equal([@[massageCushionFirmness] copy]));
        expect(testStruct.memory).to(equal(seatMemoryAction));

    });

    it(@"Should set and get correctly", ^ {
        SDLSeatControlData* testStruct = [[SDLSeatControlData alloc] initWithId:SDLSupportedSeatDriver heatingEnabled:NO coolingEnable:YES heatingLevel:25 coolingLevel:10 horizontalPostion:23 verticalPostion:25 frontVerticalPostion:12 backVerticalPostion:25 backTiltAngle:2 headSupportedHorizontalPostion:3 headSupportedVerticalPostion:43 massageEnabled:YES massageMode:[@[massageModeData] copy] massageCussionFirmness:[@[massageCushionFirmness] copy] memory:seatMemoryAction];

        expect(testStruct.id).to(equal(SDLSupportedSeatDriver));
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
        expect(testStruct.massageMode).to(equal([@[massageModeData] copy]));
        expect(testStruct.massageCushionFirmness).to(equal([@[massageCushionFirmness] copy]));
        expect(testStruct.memory).to(equal(seatMemoryAction));

    });

    it(@"Should set and get correctly", ^ {
        SDLSeatControlData* testStruct = [[SDLSeatControlData alloc] initWithId:SDLSupportedSeatDriver];

        expect(testStruct.id).to(equal(SDLSupportedSeatDriver));
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

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameId:SDLSupportedSeatDriver,
                                       SDLNameHeatingEnabled:@NO,
                                       SDLNameCoolingEnabled:@YES,
                                       SDLNameHeatingLevel:@25,
                                       SDLNameCoolingLevel:@10,
                                       SDLNameHorizontalPosition:@23,
                                       SDLNameVerticalPosition:@25,
                                       SDLNameFrontVerticalPosition:@12,
                                       SDLNameBackVerticalPosition:@34,
                                       SDLNameBackTiltAngle:@2,
                                       SDLNameHeadSupportHorizontalPosition:@3,
                                       SDLNameHeadSupportVerticalPosition:@43,
                                       SDLNameMassageEnabled:@YES,
                                       SDLNameMassageMode:[@[massageModeData] mutableCopy],
                                       SDLNameMassageCushionFirmness:[@[massageCushionFirmness] mutableCopy],
                                       SDLNameMemory:seatMemoryAction
                                       } mutableCopy];
        SDLSeatControlData *testStruct = [[SDLSeatControlData alloc] initWithDictionary:dict];

        expect(testStruct.id).to(equal(SDLSupportedSeatDriver));
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
        expect(testStruct.massageMode).to(equal([@[massageModeData] mutableCopy]));
        expect(testStruct.massageCushionFirmness).to(equal([@[massageCushionFirmness] mutableCopy]));
        expect(testStruct.memory).to(equal(seatMemoryAction));
    });

    it(@"Should return nil if not set", ^ {
        SDLSeatControlData* testStruct = [[SDLSeatControlData alloc] init];

        expect(testStruct.id).to(beNil());
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
