//
//  SDLScrollableMessageSpec.m
//  SmartDeviceLink

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLScrollableMessage.h"
#import "SDLSoftButton.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLScrollableMessageSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLScrollableMessage *testRequest = nil;
    __block NSString *testScrollableMessageBody = nil;
    __block int testTimeout = 6542;
    __block NSArray<SDLSoftButton *> *testSoftButtons = nil;
    __block int testCancelID = 69;

    beforeEach(^{
        testScrollableMessageBody = @"Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.\nNow we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battle-field of that war.";
        testSoftButtons = @[[[SDLSoftButton alloc] init]];
    });

    context(@"Getter/Setter Tests", ^{
        it(@"Should set and get correctly", ^ {
            testRequest = [[SDLScrollableMessage alloc] init];

            testRequest.scrollableMessageBody = testScrollableMessageBody;
            testRequest.timeout = @(testTimeout);
            testRequest.softButtons = testSoftButtons;
            testRequest.cancelID = @(testCancelID);

            expect(testRequest.scrollableMessageBody).to(equal(testScrollableMessageBody));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(equal(testCancelID));

            expect(testRequest.parameters.count).to(equal(4));
        });

        it(@"Should return nil if not set", ^{
            testRequest = [[SDLScrollableMessage alloc] init];

            expect(testRequest.scrollableMessageBody).to(beNil());
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(beNil());

            expect(testRequest.parameters.count).to(equal(0));
        });
    });

    describe(@"Initializing", ^{
        it(@"Should initialize correctly with a dictionary", ^ {
            NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameRequest:
                                                               @{SDLRPCParameterNameParameters:
                                                                     @{SDLRPCParameterNameScrollableMessageBody:testScrollableMessageBody,
                                                                       SDLRPCParameterNameTimeout:@(testTimeout),
                                                                       SDLRPCParameterNameSoftButtons:testSoftButtons,
                                                                       SDLRPCParameterNameCancelID:@(testCancelID)},
                                                                 SDLRPCParameterNameOperationName:SDLRPCFunctionNameScrollableMessage}};
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLScrollableMessage alloc] initWithDictionary:dict];
            #pragma clang diagnostic pop

            expect(testRequest.scrollableMessageBody).to(equal(testScrollableMessageBody));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithMessage:cancelID:", ^{
            testRequest = [[SDLScrollableMessage alloc] initWithMessage:testScrollableMessageBody cancelID:testCancelID];

            expect(testRequest.scrollableMessageBody).to(equal(testScrollableMessageBody));
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithMessage:timeout:softButtons:cancelID:", ^{
            testRequest = [[SDLScrollableMessage alloc] initWithMessage:testScrollableMessageBody timeout:testTimeout softButtons:testSoftButtons cancelID:testCancelID];

            expect(testRequest.scrollableMessageBody).to(equal(testScrollableMessageBody));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(equal(testCancelID));
        });

        it(@"Should initialize correctly with initWithMessage:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLScrollableMessage alloc] initWithMessage:testScrollableMessageBody];
            #pragma clang diagnostic pop

            expect(testRequest.scrollableMessageBody).to(equal(testScrollableMessageBody));
            expect(testRequest.timeout).to(beNil());
            expect(testRequest.softButtons).to(beNil());
            expect(testRequest.cancelID).to(beNil());
        });

        it(@"Should initialize correctly with initWithMessage:timeout:softButtons:", ^{
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            testRequest = [[SDLScrollableMessage alloc] initWithMessage:testScrollableMessageBody timeout:testTimeout softButtons:testSoftButtons];
            #pragma clang diagnostic pop

            expect(testRequest.scrollableMessageBody).to(equal(testScrollableMessageBody));
            expect(testRequest.timeout).to(equal(testTimeout));
            expect(testRequest.softButtons).to(equal(testSoftButtons));
            expect(testRequest.cancelID).to(beNil());
        });
    });

    afterEach(^{
        expect(testRequest.name).to(equal(SDLRPCFunctionNameScrollableMessage));
    });
});

QuickSpecEnd
