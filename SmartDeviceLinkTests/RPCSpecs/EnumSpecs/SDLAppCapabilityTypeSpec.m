//
//  SDLAppCapabilityTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppCapabilityType.h"


QuickSpecBegin(SDLAppCapabilityTypeSpec)

describe(@"individual enum value tests", ^{
    it(@"should match internal values", ^{
        expect(SDLAppCapabilityTypeVideoStreaming).to(equal(@"VIDEO_STREAMING"));
    });
});

QuickSpecEnd
