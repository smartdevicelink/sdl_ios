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
        expect(SDLPRNDLPark).to(equal(@"PARK"));
        expect(SDLPRNDLReverse).to(equal(@"REVERSE"));
        expect(SDLPRNDLNeutral).to(equal(@"NEUTRAL"));
        expect(SDLPRNDLDrive).to(equal(@"DRIVE"));
        expect(SDLPRNDLSport).to(equal(@"SPORT"));
        expect(SDLPRNDLLowGear).to(equal(@"LOWGEAR"));
        expect(SDLPRNDLFirst).to(equal(@"FIRST"));
        expect(SDLPRNDLSecond).to(equal(@"SECOND"));
        expect(SDLPRNDLThird).to(equal(@"THIRD"));
        expect(SDLPRNDLFourth).to(equal(@"FOURTH"));
        expect(SDLPRNDLFifth).to(equal(@"FIFTH"));
        expect(SDLPRNDLSixth).to(equal(@"SIXTH"));
        expect(SDLPRNDLSeventh).to(equal(@"SEVENTH"));
        expect(SDLPRNDLEighth).to(equal(@"EIGHTH"));
        expect(SDLPRNDLUnknown).to(equal(@"UNKNOWN"));
        expect(SDLPRNDLFault).to(equal(@"FAULT"));
    });
});

QuickSpecEnd
