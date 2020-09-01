//
//  SDLOnSubtleAlertPressedSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 7/28/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnSubtleAlertPressed.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLOnSubtleAlertPressedSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLOnSubtleAlertPressed *testOnSubtleAlertPressed = nil;

    it(@"Should init correctly", ^{
        testOnSubtleAlertPressed = [[SDLOnSubtleAlertPressed alloc] init];

        expect(testOnSubtleAlertPressed).toNot(beNil());
    });
});

QuickSpecEnd

