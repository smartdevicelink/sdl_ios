//
//  SDLIAPConstantsSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 5/29/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLIAPConstants.h"

QuickSpecBegin(SDLIAPConstantsSpec)

describe(@"SDLIAPConstants", ^{
    it(@"Should return the correct protocol string", ^ {
        expect(ControlProtocolString).to(match(@"com.smartdevicelink.prot0"));
        expect(IndexedProtocolStringPrefix).to(match(@"com.smartdevicelink.prot"));
        expect(LegacyProtocolString).to(match(@"com.ford.sync.prot0"));
        expect(MultiSessionProtocolString).to(match(@"com.smartdevicelink.multisession"));
    });
});

QuickSpecEnd
