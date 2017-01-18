//
//  SDLPermissionStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPermissionStatus.h"

QuickSpecBegin(SDLPermissionStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLPermissionStatusAllowed).to(equal(@"ALLOWED"));
        expect(SDLPermissionStatusDisallowed).to(equal(@"DISALLOWED"));
        expect(SDLPermissionStatusUserDisallowed).to(equal(@"USER_DISALLOWED"));
        expect(SDLPermissionStatusUserConsentPending).to(equal(@"USER_CONSENT_PENDING"));
    });
});

QuickSpecEnd
