//
//  SDLEmergencyEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEmergencyEvent.h"
#import "SDLEmergencyEventType.h"
#import "SDLFuelCutoffStatus.h"
#import "SDLRPCParameterNames.h"
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
        NSMutableDictionary* dict = [@{SDLRPCParameterNameEmergencyEventType:SDLEmergencyEventTypeFrontal,
                                       SDLRPCParameterNameFuelCutoffStatus:SDLFuelCutoffStatusNormalOperation,
                                       SDLRPCParameterNameRolloverEvent:SDLVehicleDataEventStatusYes,
                                       SDLRPCParameterNameMaximumChangeVelocity:@33,
                                       SDLRPCParameterNameMultipleEvents:SDLVehicleDataEventStatusNo} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLEmergencyEvent* testStruct = [[SDLEmergencyEvent alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
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
