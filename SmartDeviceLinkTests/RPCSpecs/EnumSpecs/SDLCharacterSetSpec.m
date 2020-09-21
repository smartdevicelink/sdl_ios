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
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(SDLCharacterSetType2).to(equal(@"TYPE2SET"));
        expect(SDLCharacterSetType5).to(equal(@"TYPE5SET"));
        expect(SDLCharacterSetCID1).to(equal(@"CID1SET"));
        expect(SDLCharacterSetCID2).to(equal(@"CID2SET"));
        #pragma clang diagnostic pop
        expect(SDLCharacterSetAscii).to(equal(@"ASCII"));
        expect(SDLCharacterSetIso88591).to(equal(@"ISO_8859_1"));
        expect(SDLCharacterSetUtf8).to(equal(@"UTF_8"));
    });
});

QuickSpecEnd
