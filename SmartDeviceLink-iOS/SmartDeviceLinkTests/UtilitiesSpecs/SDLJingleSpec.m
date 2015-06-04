//
//  SDLJingleSpec.m
//  SmartDeviceLink-iOS

#import <UIKit/UIKit.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLJingle.h"


QuickSpecBegin(SDLJingleSpec)

describe(@"retrieving jingle strings", ^{
    it(@"returns each jingle correctly", ^{
        expect([SDLJingle NEGATIVE_JINGLE]).to(equal(@"NEGATIVE_JINGLE"));
        expect([SDLJingle POSITIVE_JINGLE]).to(equal(@"POSITIVE_JINGLE"));
        expect([SDLJingle LISTEN_JINGLE]).to(equal(@"LISTEN_JINGLE"));
        expect([SDLJingle INITIAL_JINGLE]).to(equal(@"INITIAL_JINGLE"));
        expect([SDLJingle HELP_JINGLE]).to(equal(@"HELP_JINGLE"));
    });
});

QuickSpecEnd
