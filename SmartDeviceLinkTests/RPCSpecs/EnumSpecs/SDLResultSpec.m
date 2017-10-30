//
//  SDLResultSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLResult.h"

QuickSpecBegin(SDLResultSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLResultSuccess).to(equal(@"SUCCESS"));
        expect(SDLResultUnsupportedRequest).to(equal(@"UNSUPPORTED_REQUEST"));
        expect(SDLResultUnsupportedResource).to(equal(@"UNSUPPORTED_RESOURCE"));
        expect(SDLResultDisallowed).to(equal(@"DISALLOWED"));
        expect(SDLResultRejected).to(equal(@"REJECTED"));
        expect(SDLResultAborted).to(equal(@"ABORTED"));
        expect(SDLResultIgnored).to(equal(@"IGNORED"));
        expect(SDLResultRetry).to(equal(@"RETRY"));
        expect(SDLResultInUse).to(equal(@"IN_USE"));
        expect(SDLResultVehicleDataNotAvailable).to(equal(@"VEHICLE_DATA_NOT_AVAILABLE"));
        expect(SDLResultTimedOut).to(equal(@"TIMED_OUT"));
        expect(SDLResultInvalidData).to(equal(@"INVALID_DATA"));
        expect(SDLResultCharacterLimitExceeded).to(equal(@"CHAR_LIMIT_EXCEEDED"));
        expect(SDLResultInvalidId).to(equal(@"INVALID_ID"));
        expect(SDLResultDuplicateName).to(equal(@"DUPLICATE_NAME"));
        expect(SDLResultApplicationNotRegistered).to(equal(@"APPLICATION_NOT_REGISTERED"));
        expect(SDLResultWrongLanguage).to(equal(@"WRONG_LANGUAGE"));
        expect(SDLResultOutOfMemory).to(equal(@"OUT_OF_MEMORY"));
        expect(SDLResultTooManyPendingRequests).to(equal(@"TOO_MANY_PENDING_REQUESTS"));
        expect(SDLResultTooManyApplications).to(equal(@"TOO_MANY_APPLICATIONS"));
        expect(SDLResultApplicationRegisteredAlready).to(equal(@"APPLICATION_REGISTERED_ALREADY"));
        expect(SDLResultWarnings).to(equal(@"WARNINGS"));
        expect(SDLResultGenericError).to(equal(@"GENERIC_ERROR"));
        expect(SDLResultUserDisallowed).to(equal(@"USER_DISALLOWED"));
        expect(SDLResultUnsupportedVersion).to(equal(@"UNSUPPORTED_VERSION"));
        expect(SDLResultVehicleDataNotAllowed).to(equal(@"VEHICLE_DATA_NOT_ALLOWED"));
        expect(SDLResultFileNotFound).to(equal(@"FILE_NOT_FOUND"));
        expect(SDLResultCancelRoute).to(equal(@"CANCEL_ROUTE"));
        expect(SDLResultTruncatedData).to(equal(@"TRUNCATED_DATA"));
        expect(SDLResultSaved).to(equal(@"SAVED"));
        expect(SDLResultInvalidCertificate).to(equal(@"INVALID_CERT"));
        expect(SDLResultExpiredCertificate).to(equal(@"EXPIRED_CERT"));
        expect(SDLResultResumeFailed).to(equal(@"RESUME_FAILED"));
        expect(SDLResultDataNotAvailable).to(equal(@"DATA_NOT_AVAILABLE"));
        expect(SDLResultReadOnly).to(equal(@"READ_ONLY"));
        
    });
});

QuickSpecEnd
