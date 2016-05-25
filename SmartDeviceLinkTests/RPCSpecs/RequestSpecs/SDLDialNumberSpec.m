//
//  SDLDialNumberSpec.m
//  SmartDeviceLink-iOS

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDialNumber.h"
#import "SDLNames.h"


QuickSpecBegin(SDLDialNumberSpec)

describe(@"Dial Number RPC", ^{
    describe(@"when initialized with 'init'", ^{
        __block SDLDialNumber *testRequest = nil;
        beforeEach(^{
            testRequest = [[SDLDialNumber alloc] init];
        });
        
        context(@"when parameters are set correctly", ^{
            __block NSString *somePhoneNumber = nil;
            beforeEach(^{
                somePhoneNumber = @"1234567890";
                testRequest.number = [somePhoneNumber copy];
            });
            
            it(@"should get 'number' correctly", ^{
                expect(testRequest.number).to(equal(somePhoneNumber));
            });
        });
        
        context(@"when parameters are not set correctly", ^{
            it(@"should return nil for number", ^{
                expect(testRequest.number).to(beNil());
            });
        });
    });
    
    describe(@"when initialized with a dictionary and parameters are set correctly", ^{
        __block SDLDialNumber *testRequest = nil;
        __block NSString *somePhoneNumber = nil;
        beforeEach(^{
            somePhoneNumber = @"1234567890";
            NSDictionary *initDict = @{
                                       NAMES_request: @{
                                               NAMES_parameters: @{
                                                       NAMES_number: [somePhoneNumber copy]
                                                       }
                                               }
                                       };
            
            testRequest = [[SDLDialNumber alloc] initWithDictionary:[initDict mutableCopy]];
        });
        
        it(@"should get 'number' correctly", ^{
            expect(testRequest.number).to(equal(somePhoneNumber));
        });
    });
    
    describe(@"when initialized with a dictionary and parameters are not set correctly", ^{
        __block SDLDialNumber *testRequest = nil;
        beforeEach(^{
            NSDictionary *initDict = @{
                                       NAMES_request: @{
                                               NAMES_parameters: @{
                                                       }
                                               }
                                       };
            
            testRequest = [[SDLDialNumber alloc] initWithDictionary:[initDict mutableCopy]];
        });
        
        it(@"should return nil for number", ^{
            expect(testRequest.number).to(beNil());
        });
    });
});

QuickSpecEnd
