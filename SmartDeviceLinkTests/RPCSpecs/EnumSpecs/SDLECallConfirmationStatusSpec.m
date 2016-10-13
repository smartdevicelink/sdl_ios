//
//  SDLECallConfirmationStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLECallConfirmationStatus.h"

QuickSpecBegin(SDLECallConfirmationStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLECallConfirmationStatusNormal).to(equal(@"NORMAL"));
        expect(SDLECallConfirmationStatusInProgress).to(equal(@"CALL_IN_PROGRESS"));
        expect(SDLECallConfirmationStatusCancelled).to(equal(@"CALL_CANCELLED"));
        expect(SDLECallConfirmationStatusCompleted).to(equal(@"CALL_COMPLETED"));
        expect(SDLECallConfirmationStatusUnsuccessful).to(equal(@"CALL_UNSUCCESSFUL"));
        expect(SDLECallConfirmationStatusConfiguredOff).to(equal(@"ECALL_CONFIGURED_OFF"));
        expect(SDLECallConfirmationStatusCompleteDTMFTimeout).to(equal(@"CALL_COMPLETE_DTMF_TIMEOUT"));
    });
});

QuickSpecEnd
