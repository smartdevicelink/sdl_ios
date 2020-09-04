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
        expect(SDLServiceUpdateReasonPublished).to(equal(@"PUBLISHED"));
        expect(SDLServiceUpdateReasonRemoved).to(equal(@"REMOVED"));
        expect(SDLServiceUpdateReasonActivated).to(equal(@"ACTIVATED"));
        expect(SDLServiceUpdateReasonDeactivated).to(equal(@"DEACTIVATED"));
        expect(SDLServiceUpdateReasonManifestUpdate).to(equal(@"MANIFEST_UPDATE"));

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        expect(SDLServiceUpdatePublished).to(equal(@"PUBLISHED"));
        expect(SDLServiceUpdateRemoved).to(equal(@"REMOVED"));
        expect(SDLServiceUpdateActivated).to(equal(@"ACTIVATED"));
        expect(SDLServiceUpdateDeactivated).to(equal(@"DEACTIVATED"));
        expect(SDLServiceUpdateManifestUpdate).to(equal(@"MANIFEST_UPDATE"));
#pragma clang diagnostic pop
    });
});

QuickSpecEnd
