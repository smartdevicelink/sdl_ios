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
        expect(SDLDisplayTypeCid).to(equal(@"CID"));
        expect(SDLDisplayTypeType2).to(equal(@"TYPE2"));
        expect(SDLDisplayTypeType5).to(equal(@"TYPE5"));
        expect(SDLDisplayTypeNgn).to(equal(@"NGN"));
        expect(SDLDisplayTypeGen26Dma).to(equal(@"GEN2_6_DMA"));
        expect(SDLDisplayTypeGen28Dma).to(equal(@"GEN2_8_DMA"));
        expect(SDLDisplayTypeMfd3).to(equal(@"MFD3"));
        expect(SDLDisplayTypeMfd4).to(equal(@"MFD4"));
        expect(SDLDisplayTypeMfd5).to(equal(@"MFD5"));
        //NOT DEFINED IN SPEC
        expect(SDLDisplayTypeGen38Inch).to(equal(@"GEN3_8-INCH"));
    });
});

QuickSpecEnd
