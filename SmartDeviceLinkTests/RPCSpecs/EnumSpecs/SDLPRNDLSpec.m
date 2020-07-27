//
//  SDLPRNDLSpec.m
//  SmartDeviceLink

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPRNDL.h"

QuickSpecBegin(SDLPRNDLSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLPRNDLDrive).to(equal(@"DRIVE"));
        expect(SDLPRNDLEighth).to(equal(@"EIGHTH"));
        expect(SDLPRNDLFault).to(equal(@"FAULT"));
        expect(SDLPRNDLFifth).to(equal(@"FIFTH"));
        expect(SDLPRNDLFirst).to(equal(@"FIRST"));
        expect(SDLPRNDLFourth).to(equal(@"FOURTH"));
        expect(SDLPRNDLLowGear).to(equal(@"LOWGEAR"));
        expect(SDLPRNDLNeutral).to(equal(@"NEUTRAL"));
        expect(SDLPRNDLNinth).to(equal(@"NINTH"));
        expect(SDLPRNDLPark).to(equal(@"PARK"));
        expect(SDLPRNDLReverse).to(equal(@"REVERSE"));
        expect(SDLPRNDLSecond).to(equal(@"SECOND"));
        expect(SDLPRNDLSeventh).to(equal(@"SEVENTH"));
        expect(SDLPRNDLSixth).to(equal(@"SIXTH"));
        expect(SDLPRNDLSport).to(equal(@"SPORT"));
        expect(SDLPRNDLTenth).to(equal(@"TENTH"));
        expect(SDLPRNDLThird).to(equal(@"THIRD"));
        expect(SDLPRNDLUnknown).to(equal(@"UNKNOWN"));
    });
});

QuickSpecEnd
