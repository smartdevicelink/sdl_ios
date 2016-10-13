//
//  SDLEmergencyEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEmergencyEvent.h"
#import "SDLEmergencyEventType.h"
#import "SDLFuelCutoffStatus.h"
#import "SDLNames.h"
#import "SDLVehicleDataEventStatus.h"


QuickSpecBegin(SDLEmergencyEventSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLEmergencyEvent* testStruct = [[SDLEmergencyEvent alloc] init];
        
        testStruct.emergencyEventType = [SDLEmergencyEventType FRONTAL];
        testStruct.fuelCutoffStatus = [SDLFuelCutoffStatus NORMAL_OPERATION];
        testStruct.rolloverEvent = [SDLVehicleDataEventStatus _YES];
        testStruct.maximumChangeVelocity = @33;
        testStruct.multipleEvents = [SDLVehicleDataEventStatus _NO];
        
        expect(testStruct.emergencyEventType).to(equal([SDLEmergencyEventType FRONTAL]));
        expect(testStruct.fuelCutoffStatus).to(equal([SDLFuelCutoffStatus NORMAL_OPERATION]));
        expect(testStruct.rolloverEvent).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.maximumChangeVelocity).to(equal(@33));
        expect(testStruct.multipleEvents).to(equal([SDLVehicleDataEventStatus _NO]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameEmergencyEventType:[SDLEmergencyEventType FRONTAL],
                                       SDLNameFuelCutoffStatus:[SDLFuelCutoffStatus NORMAL_OPERATION],
                                       SDLNameRolloverEvent:[SDLVehicleDataEventStatus _YES],
                                       SDLNameMaximumChangeVelocity:@33,
                                       SDLNameMultipleEvents:[SDLVehicleDataEventStatus _NO]} mutableCopy];
        SDLEmergencyEvent* testStruct = [[SDLEmergencyEvent alloc] initWithDictionary:dict];
        
        expect(testStruct.emergencyEventType).to(equal([SDLEmergencyEventType FRONTAL]));
        expect(testStruct.fuelCutoffStatus).to(equal([SDLFuelCutoffStatus NORMAL_OPERATION]));
        expect(testStruct.rolloverEvent).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.maximumChangeVelocity).to(equal(@33));
        expect(testStruct.multipleEvents).to(equal([SDLVehicleDataEventStatus _NO]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLEmergencyEvent* testStruct = [[SDLEmergencyEvent alloc] init];
        
        expect(testStruct.emergencyEventType).to(beNil());
        expect(testStruct.fuelCutoffStatus).to(beNil());
        expect(testStruct.rolloverEvent).to(beNil());
        expect(testStruct.maximumChangeVelocity).to(beNil());
        expect(testStruct.multipleEvents).to(beNil());
    });
});

QuickSpecEnd
