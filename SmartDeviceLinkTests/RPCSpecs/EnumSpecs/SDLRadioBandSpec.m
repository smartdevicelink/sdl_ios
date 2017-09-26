//
//  SDLRadioBandSpec.m
//  SmartDeviceLink-iOS

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRadioBand.h"

QuickSpecBegin(SDLRadioBandSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLRadioBandAM).to(equal(@"AM"));
        expect(SDLRadioBandFM).to(equal(@"FM"));
        expect(SDLRadioBandXM).to(equal(@"XM"));
    });
});

QuickSpecEnd
