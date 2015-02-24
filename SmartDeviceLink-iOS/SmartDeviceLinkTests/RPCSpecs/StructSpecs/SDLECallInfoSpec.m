//
//  SDLECallInfoSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/23/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLECallInfo.h"
#import "SDLNames.h"

QuickSpecBegin(SDLECallInfoSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLECallInfo* testStruct = [[SDLECallInfo alloc] init];
        
        testStruct.eCallNotificationStatus = [SDLVehicleDataNotificationStatus NORMAL];
        testStruct.auxECallNotificationStatus = [SDLVehicleDataNotificationStatus ACTIVE];
        testStruct.eCallConfirmationStatus = [SDLECallConfirmationStatus CALL_IN_PROGRESS];
        
        expect(testStruct.eCallNotificationStatus).to(equal([SDLVehicleDataNotificationStatus NORMAL]));
        expect(testStruct.auxECallNotificationStatus).to(equal([SDLVehicleDataNotificationStatus ACTIVE]));
        expect(testStruct.eCallConfirmationStatus).to(equal([SDLECallConfirmationStatus CALL_IN_PROGRESS]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_eCallNotificationStatus:[SDLVehicleDataNotificationStatus NORMAL],
                                       NAMES_auxECallNotificationStatus:[SDLVehicleDataNotificationStatus ACTIVE],
                                       NAMES_eCallConfirmationStatus:[SDLECallConfirmationStatus CALL_IN_PROGRESS]} mutableCopy];
        SDLECallInfo* testStruct = [[SDLECallInfo alloc] initWithDictionary:dict];
        
        expect(testStruct.eCallNotificationStatus).to(equal([SDLVehicleDataNotificationStatus NORMAL]));
        expect(testStruct.auxECallNotificationStatus).to(equal([SDLVehicleDataNotificationStatus ACTIVE]));
        expect(testStruct.eCallConfirmationStatus).to(equal([SDLECallConfirmationStatus CALL_IN_PROGRESS]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLECallInfo* testStruct = [[SDLECallInfo alloc] init];
        
        expect(testStruct.eCallNotificationStatus).to(beNil());
        expect(testStruct.auxECallNotificationStatus).to(beNil());
        expect(testStruct.eCallConfirmationStatus).to(beNil());
    });
});

QuickSpecEnd