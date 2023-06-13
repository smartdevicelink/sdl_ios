#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLAsynchronousRPCRequestOperation.h"
#import "SDLSpecUtilities.h"

#import "TestMultipleRequestsConnectionManager.h"
#import "TestRequestProgressResponse.h"

QuickSpecBegin(SDLAsynchronousRPCRequestOperationSpec)

describe(@"sending asynchronous requests", ^{
    __block TestMultipleRequestsConnectionManager *testConnectionManager = nil;
    __block SDLAsynchronousRPCRequestOperation *testOperation = nil;
    __block NSOperationQueue *testOperationQueue = nil;

    __block NSMutableArray<SDLAddCommand *> *sendRequests = nil;
    __block NSMutableDictionary<NSNumber<SDLInt> *, TestRequestProgressResponse *> *testProgressResponses;
    __block NSMutableArray<SDLRPCResponse *> *resultResponses = nil;

    beforeEach(^{
        testOperation = nil;
        testConnectionManager = [[TestMultipleRequestsConnectionManager alloc] init];

        sendRequests = [NSMutableArray array];
        testProgressResponses = [NSMutableDictionary dictionary];
        resultResponses = [NSMutableArray array];

        testOperationQueue = [[NSOperationQueue alloc] init];
        testOperationQueue.name = @"com.sdl.asynchronousRPCOp.testqueue";
        testOperationQueue.maxConcurrentOperationCount = 1;
    });

    context(@"where all requests succeed", ^{
        beforeEach(^{
            for (int i = 0; i < 3; i++) {
                SDLAddCommand *addCommand = [[SDLAddCommand alloc] init];
                addCommand.correlationID = @(i);
                [sendRequests addObject:addCommand];

                testConnectionManager.responses[addCommand.correlationID] = [SDLSpecUtilities addCommandRPCResponseWithCorrelationId:addCommand.correlationID];
                testProgressResponses[addCommand.correlationID] = [[TestRequestProgressResponse alloc] initWithCorrelationId:addCommand.correlationID percentComplete:((float)(i+1)/3.0) error:nil];
            }
        });

        it(@"should correctly send all requests", ^{
            __block NSError *testError = nil;
            __block BOOL testSuccess = NO;

            testOperation = [[SDLAsynchronousRPCRequestOperation alloc] initWithConnectionManager:testConnectionManager requests:sendRequests.copy progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
                if (testError == nil) { testError = error; }
                if (response != nil) { [resultResponses addObject:response]; }
            } completionHandler:^(BOOL success) {
                testSuccess = success;
            }];

            [testOperationQueue addOperation:testOperation];

            expect(testSuccess).withTimeout(3.0).to(beTrue());
            expect(testError).withTimeout(3.0).to(beNil());
        });
    });

    context(@"when request are cancelled", ^{
        beforeEach(^{
            for (int i = 0; i < 3; i++) {
                SDLAddCommand *addCommand = [[SDLAddCommand alloc] init];
                addCommand.correlationID = @(i);
                [sendRequests addObject:addCommand];

                testProgressResponses[addCommand.correlationID] = [[TestRequestProgressResponse alloc] initWithCorrelationId:addCommand.correlationID percentComplete:((float)(i+1)/3.0) error:nil];
            }
        });

        it(@"should fail correctly", ^{
            testOperation = [[SDLAsynchronousRPCRequestOperation alloc] initWithConnectionManager:testConnectionManager requests:[sendRequests copy] progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
                expect(percentComplete).to(beCloseTo(0));
                expect(response).to(beNil());
                expect(error).toNot(beNil());
                expect(error.code).to(equal(-8));
            } completionHandler:^(BOOL success) {
                expect(success).to(beFalsy());
            }];

            [testOperationQueue addOperation:testOperation];
            [testOperationQueue cancelAllOperations];
        });
    });

    context(@"where not all requests succeed", ^{
        __block NSError *testError = [NSError errorWithDomain:@"com.test" code:-3 userInfo:nil];

        beforeEach(^{
            for (int i = 0; i < 3; i++) {
                SDLAddCommand *addCommand = [[SDLAddCommand alloc] init];
                addCommand.correlationID = @(i);
                [sendRequests addObject:addCommand];

                NSError *error = (i == 1) ? testError : nil;

                testConnectionManager.responses[addCommand.correlationID] = [SDLSpecUtilities addCommandRPCResponseWithCorrelationId:addCommand.correlationID];
                testProgressResponses[addCommand.correlationID] = [[TestRequestProgressResponse alloc] initWithCorrelationId:addCommand.correlationID percentComplete:((float)(i+1)/3.0) error:error];
            }
        });

        it(@"should pass along the error", ^{
            testOperation = [[SDLAsynchronousRPCRequestOperation alloc] initWithConnectionManager:testConnectionManager requests:sendRequests.copy progressHandler:^(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
                TestRequestProgressResponse *progressResponse = testProgressResponses[request.correlationID];

                expect(progressResponse.percentComplete).to(beCloseTo(percentComplete));
                expect(response).toNot(beNil());
                if (![request.correlationID isEqualToNumber:@1]) {
                    expect(error).to(beNil());
                } else {
                    expect(error.code).to(equal(testError.code));
                }

                [resultResponses addObject:response];
            } completionHandler:^(BOOL success) {
                expect(resultResponses).to(haveCount(3));
                expect(success).to(beFalse());
            }];

            [testOperationQueue addOperation:testOperation];
        });
    });
});

QuickSpecEnd
