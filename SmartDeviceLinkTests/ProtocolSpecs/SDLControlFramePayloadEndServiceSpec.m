
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLControlFramePayloadConstants.h"
#import "SDLControlFramePayloadEndService.h"

QuickSpecBegin(SDLControlFramePayloadEndServiceSpec)

describe(@"Test encoding data", ^{
    __block SDLControlFramePayloadEndService *testPayload = nil;
    __block int32_t testHashId = 0;

    context(@"with paramaters", ^{
        beforeEach(^{
            testHashId = 145768957;
            testPayload = [[SDLControlFramePayloadEndService alloc] initWithHashId:testHashId];
        });

        it(@"should create the correct data", ^{
            expect(testPayload.data.description).to(equal(@"<11000000 10686173 68496400 fd41b008 00>"));
        });
    });

    context(@"without parameters", ^{
        beforeEach(^{
            testHashId = SDLControlFrameInt32NotFound;
            testPayload = [[SDLControlFramePayloadEndService alloc] initWithHashId:testHashId];
        });

        it(@"should create no data", ^{
            expect(testPayload.data.length).to(equal(0));
        });
    });
});

describe(@"Test decoding data", ^{
    __block SDLControlFramePayloadEndService *testPayload = nil;
    __block NSData *testData = nil;
    __block int32_t testHashId = 0;

    beforeEach(^{
        testHashId = 15457845;

        SDLControlFramePayloadEndService *firstPayload = [[SDLControlFramePayloadEndService alloc] initWithHashId:testHashId];
        testData = firstPayload.data;

        testPayload = [[SDLControlFramePayloadEndService alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.hashId).to(equal(testHashId));
    });
});

describe(@"Test nil data", ^{
    __block SDLControlFramePayloadEndService *testPayload = nil;
    __block NSData *testData = nil;

    beforeEach(^{
        testPayload = [[SDLControlFramePayloadEndService alloc] initWithData:testData];
    });

    it(@"should output the correct params", ^{
        expect(testPayload.hashId).to(equal(-1));
        expect(testPayload.data.length).to(equal(0));
    });
});

QuickSpecEnd
