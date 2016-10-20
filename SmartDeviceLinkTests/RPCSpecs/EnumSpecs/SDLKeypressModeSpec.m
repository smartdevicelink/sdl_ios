//
//  SDLKeypressModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeypressMode.h"

QuickSpecBegin(SDLKeypressModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLKeypressModeSingleKeypress).to(equal(@"SINGLE_KEYPRESS"));
        expect(SDLKeypressModeQueueKeypresses).to(equal(@"QUEUE_KEYPRESSES"));
        expect(SDLKeypressModeResendCurrentEntry).to(equal(@"RESEND_CURRENT_ENTRY"));
    });
});

QuickSpecEnd
