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
        expect([SDLResult SUCCESS].value).to(equal(@"SUCCESS"));
        expect([SDLResult UNSUPPORTED_REQUEST].value).to(equal(@"UNSUPPORTED_REQUEST"));
        expect([SDLResult UNSUPPORTED_RESOURCE].value).to(equal(@"UNSUPPORTED_RESOURCE"));
        expect([SDLResult DISALLOWED].value).to(equal(@"DISALLOWED"));
        expect([SDLResult REJECTED].value).to(equal(@"REJECTED"));
        expect([SDLResult ABORTED].value).to(equal(@"ABORTED"));
        expect([SDLResult IGNORED].value).to(equal(@"IGNORED"));
        expect([SDLResult RETRY].value).to(equal(@"RETRY"));
        expect([SDLResult IN_USE].value).to(equal(@"IN_USE"));
        expect([SDLResult VEHICLE_DATA_NOT_AVAILABLE].value).to(equal(@"VEHICLE_DATA_NOT_AVAILABLE"));
        expect([SDLResult TIMED_OUT].value).to(equal(@"TIMED_OUT"));
        expect([SDLResult INVALID_DATA].value).to(equal(@"INVALID_DATA"));
        expect([SDLResult CHAR_LIMIT_EXCEEDED].value).to(equal(@"CHAR_LIMIT_EXCEEDED"));
        expect([SDLResult INVALID_ID].value).to(equal(@"INVALID_ID"));
        expect([SDLResult DUPLICATE_NAME].value).to(equal(@"DUPLICATE_NAME"));
        expect([SDLResult APPLICATION_NOT_REGISTERED].value).to(equal(@"APPLICATION_NOT_REGISTERED"));
        expect([SDLResult WRONG_LANGUAGE].value).to(equal(@"WRONG_LANGUAGE"));
        expect([SDLResult OUT_OF_MEMORY].value).to(equal(@"OUT_OF_MEMORY"));
        expect([SDLResult TOO_MANY_PENDING_REQUESTS].value).to(equal(@"TOO_MANY_PENDING_REQUESTS"));
        expect([SDLResult TOO_MANY_APPLICATIONS].value).to(equal(@"TOO_MANY_APPLICATIONS"));
        expect([SDLResult APPLICATION_REGISTERED_ALREADY].value).to(equal(@"APPLICATION_REGISTERED_ALREADY"));
        expect([SDLResult WARNINGS].value).to(equal(@"WARNINGS"));
        expect([SDLResult GENERIC_ERROR].value).to(equal(@"GENERIC_ERROR"));
        expect([SDLResult USER_DISALLOWED].value).to(equal(@"USER_DISALLOWED"));
        expect([SDLResult UNSUPPORTED_VERSION].value).to(equal(@"UNSUPPORTED_VERSION"));
        expect([SDLResult VEHICLE_DATA_NOT_ALLOWED].value).to(equal(@"VEHICLE_DATA_NOT_ALLOWED"));
        expect([SDLResult FILE_NOT_FOUND].value).to(equal(@"FILE_NOT_FOUND"));
        expect([SDLResult CANCEL_ROUTE].value).to(equal(@"CANCEL_ROUTE"));
        expect([SDLResult TRUNCATED_DATA].value).to(equal(@"TRUNCATED_DATA"));
        expect([SDLResult SAVED].value).to(equal(@"SAVED"));
        expect([SDLResult INVALID_CERT].value).to(equal(@"INVALID_CERT"));
        expect([SDLResult EXPIRED_CERT].value).to(equal(@"EXPIRED_CERT"));
        expect([SDLResult RESUME_FAILED].value).to(equal(@"RESUME_FAILED"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLResult valueOf:@"SUCCESS"]).to(equal([SDLResult SUCCESS]));
        expect([SDLResult valueOf:@"UNSUPPORTED_REQUEST"]).to(equal([SDLResult UNSUPPORTED_REQUEST]));
        expect([SDLResult valueOf:@"UNSUPPORTED_RESOURCE"]).to(equal([SDLResult UNSUPPORTED_RESOURCE]));
        expect([SDLResult valueOf:@"DISALLOWED"]).to(equal([SDLResult DISALLOWED]));
        expect([SDLResult valueOf:@"REJECTED"]).to(equal([SDLResult REJECTED]));
        expect([SDLResult valueOf:@"IGNORED"]).to(equal([SDLResult IGNORED]));
        expect([SDLResult valueOf:@"RETRY"]).to(equal([SDLResult RETRY]));
        expect([SDLResult valueOf:@"IN_USE"]).to(equal([SDLResult IN_USE]));
        expect([SDLResult valueOf:@"VEHICLE_DATA_NOT_AVAILABLE"]).to(equal([SDLResult VEHICLE_DATA_NOT_AVAILABLE]));
        expect([SDLResult valueOf:@"TIMED_OUT"]).to(equal([SDLResult TIMED_OUT]));
        expect([SDLResult valueOf:@"INVALID_DATA"]).to(equal([SDLResult INVALID_DATA]));
        expect([SDLResult valueOf:@"CHAR_LIMIT_EXCEEDED"]).to(equal([SDLResult CHAR_LIMIT_EXCEEDED]));
        expect([SDLResult valueOf:@"INVALID_ID"]).to(equal([SDLResult INVALID_ID]));
        expect([SDLResult valueOf:@"DUPLICATE_NAME"]).to(equal([SDLResult DUPLICATE_NAME]));
        expect([SDLResult valueOf:@"APPLICATION_NOT_REGISTERED"]).to(equal([SDLResult APPLICATION_NOT_REGISTERED]));
        expect([SDLResult valueOf:@"WRONG_LANGUAGE"]).to(equal([SDLResult WRONG_LANGUAGE]));
        expect([SDLResult valueOf:@"OUT_OF_MEMORY"]).to(equal([SDLResult OUT_OF_MEMORY]));
        expect([SDLResult valueOf:@"TOO_MANY_PENDING_REQUESTS"]).to(equal([SDLResult TOO_MANY_PENDING_REQUESTS]));
        expect([SDLResult valueOf:@"TOO_MANY_APPLICATIONS"]).to(equal([SDLResult TOO_MANY_APPLICATIONS]));
        expect([SDLResult valueOf:@"APPLICATION_REGISTERED_ALREADY"]).to(equal([SDLResult APPLICATION_REGISTERED_ALREADY]));
        expect([SDLResult valueOf:@"WARNINGS"]).to(equal([SDLResult WARNINGS]));
        expect([SDLResult valueOf:@"GENERIC_ERROR"]).to(equal([SDLResult GENERIC_ERROR]));
        expect([SDLResult valueOf:@"USER_DISALLOWED"]).to(equal([SDLResult USER_DISALLOWED]));
        expect([SDLResult valueOf:@"UNSUPPORTED_VERSION"]).to(equal([SDLResult UNSUPPORTED_VERSION]));
        expect([SDLResult valueOf:@"VEHICLE_DATA_NOT_ALLOWED"]).to(equal([SDLResult VEHICLE_DATA_NOT_ALLOWED]));
        expect([SDLResult valueOf:@"FILE_NOT_FOUND"]).to(equal([SDLResult FILE_NOT_FOUND]));
        expect([SDLResult valueOf:@"CANCEL_ROUTE"]).to(equal([SDLResult CANCEL_ROUTE]));
        expect([SDLResult valueOf:@"TRUNCATED_DATA"]).to(equal([SDLResult TRUNCATED_DATA]));
        expect([SDLResult valueOf:@"SAVED"]).to(equal([SDLResult SAVED]));
        expect([SDLResult valueOf:@"INVALID_CERT"]).to(equal([SDLResult INVALID_CERT]));
        expect([SDLResult valueOf:@"EXPIRED_CERT"]).to(equal([SDLResult EXPIRED_CERT]));
        expect([SDLResult valueOf:@"RESUME_FAILED"]).to(equal([SDLResult RESUME_FAILED]));
});
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLResult valueOf:nil]).to(beNil());
        expect([SDLResult valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLResult values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLResult SUCCESS],
                        [SDLResult UNSUPPORTED_REQUEST],
                        [SDLResult UNSUPPORTED_RESOURCE],
                        [SDLResult DISALLOWED],
                        [SDLResult REJECTED],
                        [SDLResult ABORTED],
                        [SDLResult IGNORED],
                        [SDLResult RETRY],
                        [SDLResult IN_USE],
                        [SDLResult VEHICLE_DATA_NOT_AVAILABLE],
                        [SDLResult TIMED_OUT],
                        [SDLResult INVALID_DATA],
                        [SDLResult CHAR_LIMIT_EXCEEDED],
                        [SDLResult INVALID_ID],
                        [SDLResult DUPLICATE_NAME],
                        [SDLResult APPLICATION_NOT_REGISTERED],
                        [SDLResult WRONG_LANGUAGE],
                        [SDLResult OUT_OF_MEMORY],
                        [SDLResult TOO_MANY_PENDING_REQUESTS],
                        [SDLResult TOO_MANY_APPLICATIONS],
                        [SDLResult APPLICATION_REGISTERED_ALREADY],
                        [SDLResult WARNINGS],
                        [SDLResult GENERIC_ERROR],
                        [SDLResult USER_DISALLOWED],
                        [SDLResult UNSUPPORTED_VERSION],
                        [SDLResult VEHICLE_DATA_NOT_ALLOWED],
                        [SDLResult FILE_NOT_FOUND],
                        [SDLResult CANCEL_ROUTE],
                        [SDLResult TRUNCATED_DATA],
                        [SDLResult SAVED],
                        [SDLResult INVALID_CERT],
                        [SDLResult EXPIRED_CERT],
                        [SDLResult RESUME_FAILED]] copy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd