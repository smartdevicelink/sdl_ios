//
//  SDLServiceUpdateReasonSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLServiceUpdateReason.h"

QuickSpecBegin(SDLServiceUpdateReasonSpec)

describe(@"Individual Enum Value Tests", ^{
    it(@"Should match internal values", ^{
        expect(SDLServiceUpdatePublished).to(equal(@"PUBLISHED"));
        expect(SDLServiceUpdateRemoved).to(equal(@"REMOVED"));
        expect(SDLServiceUpdateActivated).to(equal(@"ACTIVATED"));
        expect(SDLServiceUpdateDeactivated).to(equal(@"DEACTIVATED"));
        expect(SDLServiceUpdateManifestUpdate).to(equal(@"MANIFEST_UPDATE"));
    });
});

QuickSpecEnd
