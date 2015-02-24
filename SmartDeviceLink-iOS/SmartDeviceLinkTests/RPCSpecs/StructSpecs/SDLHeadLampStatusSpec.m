//
//  SDLHeadLampStatusSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHeadLampStatus.h"
#import "SDLNames.h"

QuickSpecBegin(SDLHeadLampStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLHeadLampStatus* testStruct = [[SDLHeadLampStatus alloc] init];
        
        testStruct.lowBeamsOn = [NSNumber numberWithBool:YES];
        testStruct.highBeamsOn = [NSNumber numberWithBool:NO];
        testStruct.ambientLightSensorStatus = [SDLAmbientLightStatus TWILIGHT_3];
        
        expect(testStruct.lowBeamsOn).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.highBeamsOn).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.ambientLightSensorStatus).to(equal([SDLAmbientLightStatus TWILIGHT_3]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_lowBeamsOn:[NSNumber numberWithBool:YES],
                                       NAMES_highBeamsOn:[NSNumber numberWithBool:NO],
                                       NAMES_ambientLightSensorStatus:[SDLAmbientLightStatus TWILIGHT_3]} mutableCopy];
        SDLHeadLampStatus* testStruct = [[SDLHeadLampStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.lowBeamsOn).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.highBeamsOn).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.ambientLightSensorStatus).to(equal([SDLAmbientLightStatus TWILIGHT_3]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLHeadLampStatus* testStruct = [[SDLHeadLampStatus alloc] init];
        
        expect(testStruct.lowBeamsOn).to(beNil());
        expect(testStruct.highBeamsOn).to(beNil());
        expect(testStruct.ambientLightSensorStatus).to(beNil());
    });
});

QuickSpecEnd