//
//  SDLDisplayTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDisplayType.h"

QuickSpecBegin(SDLDisplayTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLDisplayTypeCID).to(equal(@"CID"));
        expect(SDLDisplayTypeType2).to(equal(@"TYPE2"));
        expect(SDLDisplayTypeType5).to(equal(@"TYPE5"));
        expect(SDLDisplayTypeNGN).to(equal(@"NGN"));
        expect(SDLDisplayTypeGen26DMA).to(equal(@"GEN2_6_DMA"));
        expect(SDLDisplayTypeGen28DMA).to(equal(@"GEN2_8_DMA"));
        expect(SDLDisplayTypeMFD3).to(equal(@"MFD3"));
        expect(SDLDisplayTypeMFD4).to(equal(@"MFD4"));
        expect(SDLDisplayTypeMFD5).to(equal(@"MFD5"));
        expect(SDLDisplayTypeGen38Inch).to(equal(@"GEN3_8-INCH"));
        expect(SDLDisplayTypeGeneric).to(equal(@"SDL_GENERIC"));
    });
});

QuickSpecEnd
