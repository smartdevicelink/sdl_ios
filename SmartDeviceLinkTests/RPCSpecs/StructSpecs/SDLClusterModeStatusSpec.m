//
//  SDLClusterModeStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCarModeStatus.h"
#import "SDLClusterModeStatus.h"
#import "SDLPowerModeQualificationStatus.h"
#import "SDLPowerModeStatus.h"
#import "SDLNames.h"

QuickSpecBegin(SDLClusterModeStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLClusterModeStatus* testStruct = [[SDLClusterModeStatus alloc] init];
        
        testStruct.powerModeActive = @YES;
        testStruct.powerModeQualificationStatus = SDLPowerModeQualificationStatusEvaluationInProgress;
        testStruct.carModeStatus = SDLCarModeStatusCrash;
        testStruct.powerModeStatus = SDLPowerModeStatusIgnitionOn;
        
        expect(testStruct.powerModeActive).to(equal(@YES));
        expect(testStruct.powerModeQualificationStatus).to(equal(SDLPowerModeQualificationStatusEvaluationInProgress));
        expect(testStruct.carModeStatus).to(equal(SDLCarModeStatusCrash));
        expect(testStruct.powerModeStatus).to(equal(SDLPowerModeStatusIgnitionOn));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNamePowerModeActive:@NO,
                                       SDLNamePowerModeQualificationStatus:SDLPowerModeQualificationStatusOk,
                                       SDLNameCarModeStatus:SDLCarModeStatusCrash,
                                       SDLNamePowerModeStatus:SDLPowerModeStatusKeyOut} mutableCopy];
        SDLClusterModeStatus* testStruct = [[SDLClusterModeStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.powerModeActive).to(equal(@NO));
        expect(testStruct.powerModeQualificationStatus).to(equal(SDLPowerModeQualificationStatusOk));
        expect(testStruct.carModeStatus).to(equal(SDLCarModeStatusCrash));
        expect(testStruct.powerModeStatus).to(equal(SDLPowerModeStatusKeyOut));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLClusterModeStatus* testStruct = [[SDLClusterModeStatus alloc] init];
        
        expect(testStruct.powerModeActive).to(beNil());
        expect(testStruct.powerModeQualificationStatus).to(beNil());
        expect(testStruct.carModeStatus).to(beNil());
        expect(testStruct.powerModeStatus).to(beNil());
    });
});

QuickSpecEnd
