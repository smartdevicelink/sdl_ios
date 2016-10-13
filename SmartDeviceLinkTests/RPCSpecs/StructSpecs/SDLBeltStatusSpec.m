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
        
        testStruct.driverBeltDeployed = SDLVehicleDataEventStatusYes;
        testStruct.passengerBeltDeployed = SDLVehicleDataEventStatusNoEvent;
        testStruct.passengerBuckleBelted = SDLVehicleDataEventStatusFault;
        testStruct.driverBuckleBelted = SDLVehicleDataEventStatusYes;
        testStruct.leftRow2BuckleBelted = SDLVehicleDataEventStatusFault;
        testStruct.passengerChildDetected = SDLVehicleDataEventStatusNotSupported;
        testStruct.rightRow2BuckleBelted = SDLVehicleDataEventStatusYes;
        testStruct.middleRow2BuckleBelted = SDLVehicleDataEventStatusNoEvent;
        testStruct.middleRow3BuckleBelted = SDLVehicleDataEventStatusNotSupported;
        testStruct.leftRow3BuckleBelted = SDLVehicleDataEventStatusYes;
        testStruct.rightRow3BuckleBelted = SDLVehicleDataEventStatusNo;
        testStruct.leftRearInflatableBelted = SDLVehicleDataEventStatusNotSupported;
        testStruct.rightRearInflatableBelted = SDLVehicleDataEventStatusFault;
        testStruct.middleRow1BeltDeployed = SDLVehicleDataEventStatusYes;
        testStruct.middleRow1BuckleBelted = SDLVehicleDataEventStatusNo;
        
        expect(testStruct.driverBeltDeployed).to(equal(SDLVehicleDataEventStatusYes));
        expect(testStruct.passengerBeltDeployed).to(equal(SDLVehicleDataEventStatusNoEvent));
        expect(testStruct.passengerBuckleBelted).to(equal(SDLVehicleDataEventStatusFault));
        expect(testStruct.driverBuckleBelted).to(equal(SDLVehicleDataEventStatusYes));
        expect(testStruct.leftRow2BuckleBelted).to(equal(SDLVehicleDataEventStatusFault));
        expect(testStruct.passengerChildDetected).to(equal(SDLVehicleDataEventStatusNotSupported));
        expect(testStruct.rightRow2BuckleBelted).to(equal(SDLVehicleDataEventStatusYes));
        expect(testStruct.middleRow2BuckleBelted).to(equal(SDLVehicleDataEventStatusNoEvent));
        expect(testStruct.middleRow3BuckleBelted).to(equal(SDLVehicleDataEventStatusNotSupported));
        expect(testStruct.leftRow3BuckleBelted).to(equal(SDLVehicleDataEventStatusYes));
        expect(testStruct.rightRow3BuckleBelted).to(equal(SDLVehicleDataEventStatusNo));
        expect(testStruct.leftRearInflatableBelted).to(equal(SDLVehicleDataEventStatusNotSupported));
        expect(testStruct.rightRearInflatableBelted).to(equal(SDLVehicleDataEventStatusFault));
        expect(testStruct.middleRow1BeltDeployed).to(equal(SDLVehicleDataEventStatusYes));
        expect(testStruct.middleRow1BuckleBelted).to(equal(SDLVehicleDataEventStatusNo));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameDriverBeltDeployed:SDLVehicleDataEventStatusNoEvent,
                                       SDLNamePassengerBeltDeployed:SDLVehicleDataEventStatusYes,
                                       SDLNamePassengerBuckleBelted:SDLVehicleDataEventStatusNo,
                                       SDLNameDriverBuckleBelted:SDLVehicleDataEventStatusFault,
                                       SDLNameLeftRow2BuckleBelted:SDLVehicleDataEventStatusYes,
                                       SDLNamePassengerChildDetected:SDLVehicleDataEventStatusNo,
                                       SDLNameRightRow2BuckleBelted:SDLVehicleDataEventStatusNotSupported,
                                       SDLNameMiddleRow2BuckleBelted:SDLVehicleDataEventStatusNoEvent,
                                       SDLNameMiddleRow3BuckleBelted:SDLVehicleDataEventStatusYes,
                                       SDLNameLeftRow3BuckleBelted:SDLVehicleDataEventStatusFault,
                                       SDLNameRightRow3BuckleBelted:SDLVehicleDataEventStatusNo,
                                       SDLNameLeftRearInflatableBelted:SDLVehicleDataEventStatusNotSupported,
                                       SDLNameRightRearInflatableBelted:SDLVehicleDataEventStatusFault,
                                       SDLNameMiddleRow1BeltDeployed:SDLVehicleDataEventStatusNoEvent,
                                       SDLNameMiddleRow1BuckleBelted:SDLVehicleDataEventStatusNotSupported} mutableCopy];
        SDLBeltStatus* testStruct = [[SDLBeltStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.driverBeltDeployed).to(equal(SDLVehicleDataEventStatusNoEvent));
        expect(testStruct.passengerBeltDeployed).to(equal(SDLVehicleDataEventStatusYes));
        expect(testStruct.passengerBuckleBelted).to(equal(SDLVehicleDataEventStatusNo));
        expect(testStruct.driverBuckleBelted).to(equal(SDLVehicleDataEventStatusFault));
        expect(testStruct.leftRow2BuckleBelted).to(equal(SDLVehicleDataEventStatusYes));
        expect(testStruct.passengerChildDetected).to(equal(SDLVehicleDataEventStatusNo));
        expect(testStruct.rightRow2BuckleBelted).to(equal(SDLVehicleDataEventStatusNotSupported));
        expect(testStruct.middleRow2BuckleBelted).to(equal(SDLVehicleDataEventStatusNoEvent));
        expect(testStruct.middleRow3BuckleBelted).to(equal(SDLVehicleDataEventStatusYes));
        expect(testStruct.leftRow3BuckleBelted).to(equal(SDLVehicleDataEventStatusFault));
        expect(testStruct.rightRow3BuckleBelted).to(equal(SDLVehicleDataEventStatusNo));
        expect(testStruct.leftRearInflatableBelted).to(equal(SDLVehicleDataEventStatusNotSupported));
        expect(testStruct.rightRearInflatableBelted).to(equal(SDLVehicleDataEventStatusFault));
        expect(testStruct.middleRow1BeltDeployed).to(equal(SDLVehicleDataEventStatusNoEvent));
        expect(testStruct.middleRow1BuckleBelted).to(equal(SDLVehicleDataEventStatusNotSupported));
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
