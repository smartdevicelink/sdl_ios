//
//  SDLTireStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTireStatus.h"
#import "SDLSingleTireStatus.h"
#import "SDLWarningLightStatus.h"
#import "SDLNames.h"

QuickSpecBegin(SDLTireStatusSpec)

SDLSingleTireStatus* tire1 = [[SDLSingleTireStatus alloc] init];
SDLSingleTireStatus* tire2 = [[SDLSingleTireStatus alloc] init];
SDLSingleTireStatus* tire3 = [[SDLSingleTireStatus alloc] init];
SDLSingleTireStatus* tire4 = [[SDLSingleTireStatus alloc] init];
SDLSingleTireStatus* tire5 = [[SDLSingleTireStatus alloc] init];
SDLSingleTireStatus* tire6 = [[SDLSingleTireStatus alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLTireStatus* testStruct = [[SDLTireStatus alloc] init];
        
        testStruct.pressureTelltale = [SDLWarningLightStatus OFF];
        testStruct.leftFront = tire1;
        testStruct.rightFront = tire2;
        testStruct.leftRear = tire3;
        testStruct.rightRear = tire4;
        testStruct.innerLeftRear = tire5;
        testStruct.innerRightRear = tire6;
        
        expect(testStruct.pressureTelltale).to(equal([SDLWarningLightStatus OFF]));
        expect(testStruct.leftFront).to(equal(tire1));
        expect(testStruct.rightFront).to(equal(tire2));
        expect(testStruct.leftRear).to(equal(tire3));
        expect(testStruct.rightRear).to(equal(tire4));
        expect(testStruct.innerLeftRear).to(equal(tire5));
        expect(testStruct.innerRightRear).to(equal(tire6));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_pressureTelltale:[SDLWarningLightStatus OFF],
                                       NAMES_leftFront:tire1,
                                       NAMES_rightFront:tire2,
                                       NAMES_leftRear:tire3,
                                       NAMES_rightRear:tire4,
                                       NAMES_innerLeftRear:tire5,
                                       NAMES_innerRightRear:tire6} mutableCopy];
        SDLTireStatus* testStruct = [[SDLTireStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.pressureTelltale).to(equal([SDLWarningLightStatus OFF]));
        expect(testStruct.leftFront).to(equal(tire1));
        expect(testStruct.rightFront).to(equal(tire2));
        expect(testStruct.leftRear).to(equal(tire3));
        expect(testStruct.rightRear).to(equal(tire4));
        expect(testStruct.innerLeftRear).to(equal(tire5));
        expect(testStruct.innerRightRear).to(equal(tire6));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTireStatus* testStruct = [[SDLTireStatus alloc] init];
        
        expect(testStruct.pressureTelltale).to(beNil());
        expect(testStruct.leftFront).to(beNil());
        expect(testStruct.rightFront).to(beNil());
        expect(testStruct.leftRear).to(beNil());
        expect(testStruct.rightRear).to(beNil());
        expect(testStruct.innerLeftRear).to(beNil());
        expect(testStruct.innerRightRear).to(beNil());
    });
});

QuickSpecEnd