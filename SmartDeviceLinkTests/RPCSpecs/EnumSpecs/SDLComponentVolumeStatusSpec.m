//
//  SDLComponentVolumeStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLComponentVolumeStatus.h"

QuickSpecBegin(SDLComponentVolumeStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLComponentVolumeStatusUnknown).to(equal(@"UNKNOWN"));
        expect(SDLComponentVolumeStatusNormal).to(equal(@"NORMAL"));
        expect(SDLComponentVolumeStatusLow).to(equal(@"LOW"));
        expect(SDLComponentVolumeStatusFault).to(equal(@"FAULT"));
        expect(SDLComponentVolumeStatusAlert).to(equal(@"ALERT"));
        expect(SDLComponentVolumeStatusNotSupported).to(equal(@"NOT_SUPPORTED"));
    });
});

QuickSpecEnd
