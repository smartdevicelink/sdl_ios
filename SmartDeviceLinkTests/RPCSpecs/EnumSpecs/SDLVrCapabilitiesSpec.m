//
//  SDLVrCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVrCapabilities.h"

QuickSpecBegin(SDLVrCapabilitiesSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLVRCapabilitiesText).to(equal(@"TEXT"));
    });
});

QuickSpecEnd
