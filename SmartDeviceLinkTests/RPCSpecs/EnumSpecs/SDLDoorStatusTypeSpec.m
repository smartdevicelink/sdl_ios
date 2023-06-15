//
//  SDLDoorStatusTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLDoorStatusType.h"

QuickSpecBegin(SDLDoorStatusTypeSpec)

describe(@"individual enum value tests", ^{
    it(@"should match internal values", ^{
        expect(SDLDoorStatusTypeClosed).to(equal(@"CLOSED"));
        expect(SDLDoorStatusTypeLocked).to(equal(@"LOCKED"));
        expect(SDLDoorStatusTypeAjar).to(equal(@"AJAR"));
        expect(SDLDoorStatusTypeRemoved).to(equal(@"REMOVED"));
    });
});

QuickSpecEnd
