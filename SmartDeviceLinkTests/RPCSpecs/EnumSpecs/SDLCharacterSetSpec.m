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
        expect(SDLCharacterSetType2).to(equal(@"TYPE2SET"));
        expect(SDLCharacterSetType5).to(equal(@"TYPE5SET"));
        expect(SDLCharacterSetCID1).to(equal(@"CID1SET"));
        expect(SDLCharacterSetCID2).to(equal(@"CID2SET"));
    });
});

QuickSpecEnd
