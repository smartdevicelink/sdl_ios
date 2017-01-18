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
        
        testStruct.emergencyEventType = SDLEmergencyEventTypeFrontal;
        testStruct.fuelCutoffStatus = SDLFuelCutoffStatusNormalOperation;
        testStruct.rolloverEvent = SDLVehicleDataEventStatusYes;
        testStruct.maximumChangeVelocity = @33;
        testStruct.multipleEvents = SDLVehicleDataEventStatusNo;
        
        expect(testStruct.emergencyEventType).to(equal(SDLEmergencyEventTypeFrontal));
        expect(testStruct.fuelCutoffStatus).to(equal(SDLFuelCutoffStatusNormalOperation));
        expect(testStruct.rolloverEvent).to(equal(SDLVehicleDataEventStatusYes));
        expect(testStruct.maximumChangeVelocity).to(equal(@33));
        expect(testStruct.multipleEvents).to(equal(SDLVehicleDataEventStatusNo));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameEmergencyEventType:SDLEmergencyEventTypeFrontal,
                                       SDLNameFuelCutoffStatus:SDLFuelCutoffStatusNormalOperation,
                                       SDLNameRolloverEvent:SDLVehicleDataEventStatusYes,
                                       SDLNameMaximumChangeVelocity:@33,
                                       SDLNameMultipleEvents:SDLVehicleDataEventStatusNo} mutableCopy];
        SDLEmergencyEvent* testStruct = [[SDLEmergencyEvent alloc] initWithDictionary:dict];
        
        expect(testStruct.emergencyEventType).to(equal(SDLEmergencyEventTypeFrontal));
        expect(testStruct.fuelCutoffStatus).to(equal(SDLFuelCutoffStatusNormalOperation));
        expect(testStruct.rolloverEvent).to(equal(SDLVehicleDataEventStatusYes));
        expect(testStruct.maximumChangeVelocity).to(equal(@33));
        expect(testStruct.multipleEvents).to(equal(SDLVehicleDataEventStatusNo));
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
