#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLAddCommandResponse.h"
#import "SDLRPCResponse.h"
#import "SDLSequentialRPCRequestOperation.h"
#import "SDLSpecUtilities.h"

#import "TestMultipleRequestsConnectionManager.h"
#import "TestRequestProgressResponse.h"

QuickSpecBegin(SDLSequentialRPCRequestOperationSpec)

fdescribe(@"Sending sequential requests", ^{
    __block TestMultipleRequestsConnectionManager *testConnectionManager = nil;
    __block SDLSequentialRPCRequestOperation *testOperation = nil;
    __block NSOperationQueue *testOperationQueue = nil;

    __block NSMutableArray<SDLAddCommand *> *sendRequests = nil;
    __block NSMutableDictionary<NSNumber<SDLInt> *, TestRequestProgressResponse *> *testProgressResponses;

    beforeEach(^{
        testOperation = nil;
        testConnectionManager = [[TestMultipleRequestsConnectionManager alloc] init];

        sendRequests = [NSMutableArray array];
        testProgressResponses = [NSMutableDictionary dictionary];

        testOperationQueue = [[NSOperationQueue alloc] init];
        testOperationQueue.name = @"com.sdl.sequentialrpcop.testqueue";
        testOperationQueue.maxConcurrentOperationCount = 1;
    });

    context(@"where all requests succeed", ^{
        context(@"where the requests are continued", ^{
            it(@"Should correctly send all requests", ^{
                for (int i = 0; i < 3; i++) {
                    SDLAddCommand *addCommand = [[SDLAddCommand alloc] init];
                    addCommand.correlationID = @(i);
                    [sendRequests addObject:addCommand];

                    testConnectionManager.responses[addCommand.correlationID] = [SDLSpecUtilities addCommandRPCResponseWithCorrelationId:addCommand.correlationID];
                    testProgressResponses[addCommand.correlationID] = [[TestRequestProgressResponse alloc] initWithCorrelationId:addCommand.correlationID percentComplete:(i/3) error:nil];
                }

                testOperation = [[SDLSequentialRPCRequestOperation alloc] initWithConnectionManager:testConnectionManager requests:sendRequests.copy progressHandler:^BOOL(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
                    TestRequestProgressResponse *progressResponse = testProgressResponses[request.correlationID];

                    expect(progressResponse.percentComplete).to(beCloseTo(percentComplete));
                    expect(response).toNot(beNil());
                    expect(error).to(beNil());

                    return YES;
                } completionHandler:^(BOOL success) {
                    expect(success).to(beTrue());
                }];

                [testOperationQueue addOperation:testOperation];

                for (int i = 0; i < 3; i++) {
                    [NSThread sleepForTimeInterval:0.1];
                    [testConnectionManager respondToLastRequestWithResponse:testConnectionManager.responses[@(i)]];
                }
            });
        });

        context(@"where the requests are cancelled", ^{
            it(@"Should only send the one before cancellation", ^{
                for (int i = 0; i < 3; i++) {
                    SDLAddCommand *addCommand = [[SDLAddCommand alloc] init];
                    addCommand.correlationID = @(i);
                    [sendRequests addObject:addCommand];

                    testConnectionManager.responses[addCommand.correlationID] = [SDLSpecUtilities addCommandRPCResponseWithCorrelationId:addCommand.correlationID];
                    testProgressResponses[addCommand.correlationID] = [[TestRequestProgressResponse alloc] initWithCorrelationId:addCommand.correlationID percentComplete:(i/3) error:nil];
                }

                testOperation = [[SDLSequentialRPCRequestOperation alloc] initWithConnectionManager:testConnectionManager requests:sendRequests.copy progressHandler:^BOOL(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
                    TestRequestProgressResponse *progressResponse = testProgressResponses[request.correlationID];

                    expect(progressResponse.percentComplete).to(beCloseTo(percentComplete));
                    expect(response).toNot(beNil());
                    expect(error).toNot(beNil());

                    return NO;
                } completionHandler:^(BOOL success) {
                    expect(success).to(beFalse());
                }];

                [testOperationQueue addOperation:testOperation];
            });
        });
    });
});

QuickSpecEnd
