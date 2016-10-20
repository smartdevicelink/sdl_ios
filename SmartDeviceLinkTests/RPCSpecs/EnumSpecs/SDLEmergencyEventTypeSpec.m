//
//  SDLEmergencyEventTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEmergencyEventType.h"

QuickSpecBegin(SDLEmergencyEventTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLEmergencyEventTypeNoEvent).to(equal(@"NO_EVENT"));
        expect(SDLEmergencyEventTypeFrontal).to(equal(@"FRONTAL"));
        expect(SDLEmergencyEventTypeSide).to(equal(@"SIDE"));
        expect(SDLEmergencyEventTypeRear).to(equal(@"REAR"));
        expect(SDLEmergencyEventTypeRollover).to(equal(@"ROLLOVER"));
        expect(SDLEmergencyEventTypeNotSupported).to(equal(@"NOT_SUPPORTED"));
        expect(SDLEmergencyEventTypeFault).to(equal(@"FAULT"));
    });
});

QuickSpecEnd
