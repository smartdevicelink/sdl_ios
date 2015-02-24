//
//  SDLClusterModeStatusSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLClusterModeStatus.h"
#import "SDLNames.h"

QuickSpecBegin(SDLClusterModeStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLClusterModeStatus* testStruct = [[SDLClusterModeStatus alloc] init];
        
        testStruct.powerModeActive = [NSNumber numberWithBool:YES];
        testStruct.powerModeQualificationStatus = [SDLPowerModeQualificationStatus POWER_MODE_EVALUATION_IN_PROGRESS];
        testStruct.carModeStatus = [SDLCarModeStatus CRASH];
        testStruct.powerModeStatus = [SDLPowerModeStatus IGNITION_ON_2];
        
        expect(testStruct.powerModeActive).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.powerModeQualificationStatus).to(equal([SDLPowerModeQualificationStatus POWER_MODE_EVALUATION_IN_PROGRESS]));
        expect(testStruct.carModeStatus).to(equal([SDLCarModeStatus CRASH]));
        expect(testStruct.powerModeStatus).to(equal([SDLPowerModeStatus IGNITION_ON_2]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_powerModeActive:[NSNumber numberWithBool:NO],
                                       NAMES_powerModeQualificationStatus:[SDLPowerModeQualificationStatus POWER_MODE_OK],
                                       NAMES_carModeStatus:[SDLCarModeStatus CRASH],
                                       NAMES_powerModeStatus:[SDLPowerModeStatus KEY_OUT]} mutableCopy];
        SDLClusterModeStatus* testStruct = [[SDLClusterModeStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.powerModeActive).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.powerModeQualificationStatus).to(equal([SDLPowerModeQualificationStatus POWER_MODE_OK]));
        expect(testStruct.carModeStatus).to(equal([SDLCarModeStatus CRASH]));
        expect(testStruct.powerModeStatus).to(equal([SDLPowerModeStatus KEY_OUT]));
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