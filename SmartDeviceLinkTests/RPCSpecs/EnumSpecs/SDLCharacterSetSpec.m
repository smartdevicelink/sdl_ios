//
//  SDLCharacterSetSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLCharacterSet.h"

QuickSpecBegin(SDLCharacterSetSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLCharacterSetType2Set).to(equal(@"TYPE2SET"));
        expect(SDLCharacterSetType5Set).to(equal(@"TYPE5SET"));
        expect(SDLCharacterSetCid1Set).to(equal(@"CID1SET"));
        expect(SDLCharacterSetCid2Set).to(equal(@"CID2SET"));
    });
});

QuickSpecEnd
