//
//  SDLBeltStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLBeltStatus.h"
#import "SDLNames.h"
#import "SDLVehicleDataEventStatus.h"


QuickSpecBegin(SDLBeltStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLBeltStatus* testStruct = [[SDLBeltStatus alloc] init];
        
        testStruct.driverBeltDeployed = [SDLVehicleDataEventStatus _YES];
        testStruct.passengerBeltDeployed = [SDLVehicleDataEventStatus NO_EVENT];
        testStruct.passengerBuckleBelted = [SDLVehicleDataEventStatus FAULT];
        testStruct.driverBuckleBelted = [SDLVehicleDataEventStatus _YES];
        testStruct.leftRow2BuckleBelted = [SDLVehicleDataEventStatus FAULT];
        testStruct.passengerChildDetected = [SDLVehicleDataEventStatus NOT_SUPPORTED];
        testStruct.rightRow2BuckleBelted = [SDLVehicleDataEventStatus _YES];
        testStruct.middleRow2BuckleBelted = [SDLVehicleDataEventStatus NO_EVENT];
        testStruct.middleRow3BuckleBelted = [SDLVehicleDataEventStatus NOT_SUPPORTED];
        testStruct.leftRow3BuckleBelted = [SDLVehicleDataEventStatus _YES];
        testStruct.rightRow3BuckleBelted = [SDLVehicleDataEventStatus _NO];
        testStruct.leftRearInflatableBelted = [SDLVehicleDataEventStatus NOT_SUPPORTED];
        testStruct.rightRearInflatableBelted = [SDLVehicleDataEventStatus FAULT];
        testStruct.middleRow1BeltDeployed = [SDLVehicleDataEventStatus _YES];
        testStruct.middleRow1BuckleBelted = [SDLVehicleDataEventStatus _NO];
        
        expect(testStruct.driverBeltDeployed).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.passengerBeltDeployed).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
        expect(testStruct.passengerBuckleBelted).to(equal([SDLVehicleDataEventStatus FAULT]));
        expect(testStruct.driverBuckleBelted).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.leftRow2BuckleBelted).to(equal([SDLVehicleDataEventStatus FAULT]));
        expect(testStruct.passengerChildDetected).to(equal([SDLVehicleDataEventStatus NOT_SUPPORTED]));
        expect(testStruct.rightRow2BuckleBelted).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.middleRow2BuckleBelted).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
        expect(testStruct.middleRow3BuckleBelted).to(equal([SDLVehicleDataEventStatus NOT_SUPPORTED]));
        expect(testStruct.leftRow3BuckleBelted).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.rightRow3BuckleBelted).to(equal([SDLVehicleDataEventStatus _NO]));
        expect(testStruct.leftRearInflatableBelted).to(equal([SDLVehicleDataEventStatus NOT_SUPPORTED]));
        expect(testStruct.rightRearInflatableBelted).to(equal([SDLVehicleDataEventStatus FAULT]));
        expect(testStruct.middleRow1BeltDeployed).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.middleRow1BuckleBelted).to(equal([SDLVehicleDataEventStatus _NO]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_driverBeltDeployed:[SDLVehicleDataEventStatus NO_EVENT],
                                       NAMES_passengerBeltDeployed:[SDLVehicleDataEventStatus _YES],
                                       NAMES_passengerBuckleBelted:[SDLVehicleDataEventStatus _NO],
                                       NAMES_driverBuckleBelted:[SDLVehicleDataEventStatus FAULT],
                                       NAMES_leftRow2BuckleBelted:[SDLVehicleDataEventStatus _YES],
                                       NAMES_passengerChildDetected:[SDLVehicleDataEventStatus _NO],
                                       NAMES_rightRow2BuckleBelted:[SDLVehicleDataEventStatus NOT_SUPPORTED],
                                       NAMES_middleRow2BuckleBelted:[SDLVehicleDataEventStatus NO_EVENT],
                                       NAMES_middleRow3BuckleBelted:[SDLVehicleDataEventStatus _YES],
                                       NAMES_leftRow3BuckleBelted:[SDLVehicleDataEventStatus FAULT],
                                       NAMES_rightRow3BuckleBelted:[SDLVehicleDataEventStatus _NO],
                                       NAMES_leftRearInflatableBelted:[SDLVehicleDataEventStatus NOT_SUPPORTED],
                                       NAMES_rightRearInflatableBelted:[SDLVehicleDataEventStatus FAULT],
                                       NAMES_middleRow1BeltDeployed:[SDLVehicleDataEventStatus NO_EVENT],
                                       NAMES_middleRow1BuckleBelted:[SDLVehicleDataEventStatus NOT_SUPPORTED]} mutableCopy];
        SDLBeltStatus* testStruct = [[SDLBeltStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.driverBeltDeployed).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
        expect(testStruct.passengerBeltDeployed).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.passengerBuckleBelted).to(equal([SDLVehicleDataEventStatus _NO]));
        expect(testStruct.driverBuckleBelted).to(equal([SDLVehicleDataEventStatus FAULT]));
        expect(testStruct.leftRow2BuckleBelted).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.passengerChildDetected).to(equal([SDLVehicleDataEventStatus _NO]));
        expect(testStruct.rightRow2BuckleBelted).to(equal([SDLVehicleDataEventStatus NOT_SUPPORTED]));
        expect(testStruct.middleRow2BuckleBelted).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
        expect(testStruct.middleRow3BuckleBelted).to(equal([SDLVehicleDataEventStatus _YES]));
        expect(testStruct.leftRow3BuckleBelted).to(equal([SDLVehicleDataEventStatus FAULT]));
        expect(testStruct.rightRow3BuckleBelted).to(equal([SDLVehicleDataEventStatus _NO]));
        expect(testStruct.leftRearInflatableBelted).to(equal([SDLVehicleDataEventStatus NOT_SUPPORTED]));
        expect(testStruct.rightRearInflatableBelted).to(equal([SDLVehicleDataEventStatus FAULT]));
        expect(testStruct.middleRow1BeltDeployed).to(equal([SDLVehicleDataEventStatus NO_EVENT]));
        expect(testStruct.middleRow1BuckleBelted).to(equal([SDLVehicleDataEventStatus NOT_SUPPORTED]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLBeltStatus* testStruct = [[SDLBeltStatus alloc] init];
        
        expect(testStruct.driverBeltDeployed).to(beNil());
        expect(testStruct.passengerBeltDeployed).to(beNil());
        expect(testStruct.passengerBuckleBelted).to(beNil());
        expect(testStruct.driverBuckleBelted).to(beNil());
        expect(testStruct.leftRow2BuckleBelted).to(beNil());
        expect(testStruct.passengerChildDetected).to(beNil());
        expect(testStruct.rightRow2BuckleBelted).to(beNil());
        expect(testStruct.middleRow2BuckleBelted).to(beNil());
        expect(testStruct.middleRow3BuckleBelted).to(beNil());
        expect(testStruct.leftRow3BuckleBelted).to(beNil());
        expect(testStruct.rightRow3BuckleBelted).to(beNil());
        expect(testStruct.leftRearInflatableBelted).to(beNil());
        expect(testStruct.rightRearInflatableBelted).to(beNil());
        expect(testStruct.middleRow1BeltDeployed).to(beNil());
        expect(testStruct.middleRow1BuckleBelted).to(beNil());
    });
});

QuickSpecEnd