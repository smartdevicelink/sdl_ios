//
//  SDLDisplayTypeSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/21/15.
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDisplayType.h"

QuickSpecBegin(SDLDisplayTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLDisplayType CID].value).to(equal(@"CID"));
        expect([SDLDisplayType TYPE2].value).to(equal(@"TYPE2"));
        expect([SDLDisplayType TYPE5].value).to(equal(@"TYPE5"));
        expect([SDLDisplayType NGN].value).to(equal(@"NGN"));
        expect([SDLDisplayType GEN2_6_DMA].value).to(equal(@"GEN2_6_DMA"));
        expect([SDLDisplayType GEN2_8_DMA].value).to(equal(@"GEN2_8_DMA"));
        expect([SDLDisplayType MFD3].value).to(equal(@"MFD3"));
        expect([SDLDisplayType MFD4].value).to(equal(@"MFD4"));
        expect([SDLDisplayType MFD5].value).to(equal(@"MFD5"));
        //NOT DEFINED IN SPEC
        expect([SDLDisplayType GEN3_8_INCH].value).to(equal(@"GEN3_8-INCH"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLDisplayType valueOf:@"CID"]).to(equal([SDLDisplayType CID]));
        expect([SDLDisplayType valueOf:@"TYPE2"]).to(equal([SDLDisplayType TYPE2]));
        expect([SDLDisplayType valueOf:@"TYPE5"]).to(equal([SDLDisplayType TYPE5]));
        expect([SDLDisplayType valueOf:@"NGN"]).to(equal([SDLDisplayType NGN]));
        expect([SDLDisplayType valueOf:@"GEN2_6_DMA"]).to(equal([SDLDisplayType GEN2_6_DMA]));
        expect([SDLDisplayType valueOf:@"GEN2_8_DMA"]).to(equal([SDLDisplayType GEN2_8_DMA]));
        expect([SDLDisplayType valueOf:@"MFD3"]).to(equal([SDLDisplayType MFD3]));
        expect([SDLDisplayType valueOf:@"MFD4"]).to(equal([SDLDisplayType MFD4]));
        expect([SDLDisplayType valueOf:@"MFD5"]).to(equal([SDLDisplayType MFD5]));
        //NOT DEFINED IN SPEC
        expect([SDLDisplayType valueOf:@"GEN3_8-INCH"]).to(equal([SDLDisplayType GEN3_8_INCH]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLDisplayType valueOf:nil]).to(beNil());
        expect([SDLDisplayType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLDisplayType values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLDisplayType CID],
                        [SDLDisplayType TYPE2],
                        [SDLDisplayType TYPE5],
                        [SDLDisplayType NGN],
                        [SDLDisplayType GEN2_6_DMA],
                        [SDLDisplayType GEN2_8_DMA],
                        [SDLDisplayType MFD3],
                        [SDLDisplayType MFD4],
                        [SDLDisplayType MFD5],
                        //NOT DEFINED IN SPEC
                        [SDLDisplayType GEN3_8_INCH]] mutableCopy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain([definedValues objectAtIndex:i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain([storedValues objectAtIndex:i]));
        }
    });
});

QuickSpecEnd