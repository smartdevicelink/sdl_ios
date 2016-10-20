//
//  SDLSystemActionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSystemAction.h"

QuickSpecBegin(SDLSystemActionSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLSystemActionDefaultAction).to(equal(@"DEFAULT_ACTION"));
        expect(SDLSystemActionStealFocus).to(equal(@"STEAL_FOCUS"));
        expect(SDLSystemActionKeepContext).to(equal(@"KEEP_CONTEXT"));
    });
});

QuickSpecEnd
