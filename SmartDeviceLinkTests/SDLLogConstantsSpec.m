//
//  SDLLogConstantsSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 9/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLogConstants.h"

QuickSpecBegin(SDLLogConstantsSpec)

describe(@"log constants", ^{
    it(@"should assigned the correct integer value to each SDLLogLevel", ^{
        expect((int)SDLLogLevelOff).to(beGreaterThan((int)SDLLogLevelDefault));
        expect((int)SDLLogLevelOff).to(beLessThan((int)SDLLogLevelError));
        expect((int)SDLLogLevelOff).to(beLessThan((int)SDLLogLevelWarning));
        expect((int)SDLLogLevelOff).to(beLessThan((int)SDLLogLevelDebug));
        expect((int)SDLLogLevelOff).to(beLessThan((int)SDLLogLevelVerbose));

        expect((int)SDLLogLevelError).to(beGreaterThan((int)SDLLogLevelDefault));
        expect((int)SDLLogLevelError).to(beGreaterThan((int)SDLLogLevelOff));
        expect((int)SDLLogLevelError).to(beLessThan((int)SDLLogLevelWarning));
        expect((int)SDLLogLevelError).to(beLessThan((int)SDLLogLevelDebug));
        expect((int)SDLLogLevelError).to(beLessThan((int)SDLLogLevelVerbose));

        expect((int)SDLLogLevelWarning).to(beGreaterThan((int)SDLLogLevelDefault));
        expect((int)SDLLogLevelWarning).to(beGreaterThan((int)SDLLogLevelOff));
        expect((int)SDLLogLevelWarning).to(beGreaterThan((int)SDLLogLevelError));
        expect((int)SDLLogLevelWarning).to(beLessThan((int)SDLLogLevelDebug));
        expect((int)SDLLogLevelWarning).to(beLessThan((int)SDLLogLevelVerbose));

        expect((int)SDLLogLevelDebug).to(beGreaterThan((int)SDLLogLevelDefault));
        expect((int)SDLLogLevelDebug).to(beGreaterThan((int)SDLLogLevelOff));
        expect((int)SDLLogLevelDebug).to(beGreaterThan((int)SDLLogLevelError));
        expect((int)SDLLogLevelDebug).to(beGreaterThan((int)SDLLogLevelWarning));
        expect((int)SDLLogLevelDebug).to(beLessThan((int)SDLLogLevelVerbose));

        expect((int)SDLLogLevelVerbose).to(beGreaterThan((int)SDLLogLevelDefault));
        expect((int)SDLLogLevelVerbose).to(beGreaterThan((int)SDLLogLevelOff));
        expect((int)SDLLogLevelVerbose).to(beGreaterThan((int)SDLLogLevelError));
        expect((int)SDLLogLevelVerbose).to(beGreaterThan((int)SDLLogLevelWarning));
        expect((int)SDLLogLevelVerbose).to(beGreaterThan((int)SDLLogLevelDebug));
    });
});

QuickSpecEnd
