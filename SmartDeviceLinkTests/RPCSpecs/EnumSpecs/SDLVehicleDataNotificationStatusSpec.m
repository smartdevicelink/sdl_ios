//
//  SDLVehicleDataNotificationStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVehicleDataNotificationStatus.h"

QuickSpecBegin(SDLVehicleDataNotificationStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLVehicleDataNotificationStatusNotSupported).to(equal(@"NOT_SUPPORTED"));
        expect(SDLVehicleDataNotificationStatusNormal).to(equal(@"NORMAL"));
        expect(SDLVehicleDataNotificationStatusActive).to(equal(@"ACTIVE"));
        expect(SDLVehicleDataNotificationStatusNotUsed).to(equal(@"NOT_USED"));
    });
});

QuickSpecEnd
