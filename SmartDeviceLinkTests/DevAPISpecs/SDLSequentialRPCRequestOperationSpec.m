#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLAddCommandResponse.h"
#import "SDLRPCResponse.h"
#import "SDLSequentialRPCRequestOperation.h"
#import "SDLSpecUtilities.h"

#import "TestMultipleRequestsConnectionManager.h"
#import "TestRequestProgressResponse.h"
#import "TestResponse.h"

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
        beforeEach(^{
            for (int i = 0; i < 3; i++) {
                SDLAddCommand *addCommand = [[SDLAddCommand alloc] init];
                addCommand.correlationID = @(i);
                [sendRequests addObject:addCommand];

                testConnectionManager.responses[addCommand.correlationID] = [SDLSpecUtilities addCommandRPCResponseWithCorrelationId:addCommand.correlationID];
                testProgressResponses[addCommand.correlationID] = [[TestRequestProgressResponse alloc] initWithCorrelationId:addCommand.correlationID percentComplete:((float)(i+1)/3.0) error:nil];
            }
        });

        context(@"where the requests are continued", ^{
            __block NSMutableArray<SDLRPCResponse *> *resultResponses = [NSMutableArray array];

            it(@"Should correctly send all requests", ^{
                testOperation = [[SDLSequentialRPCRequestOperation alloc] initWithConnectionManager:testConnectionManager requests:sendRequests.copy progressHandler:^BOOL(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
                    TestRequestProgressResponse *progressResponse = testProgressResponses[request.correlationID];

                    expect(progressResponse.percentComplete).to(beCloseTo(percentComplete));
                    expect(response).toNot(beNil());
                    expect(error).to(beNil());

                    [resultResponses addObject:response];

                    return YES;
                } completionHandler:^(BOOL success) {
                    expect(resultResponses).to(haveCount(3));
                    expect(success).to(beTruthy());
                }];

                [testOperationQueue addOperation:testOperation];
            });
        });

        context(@"where the requests are cancelled", ^{
            __block NSMutableArray<SDLRPCResponse *> *resultResponses = [NSMutableArray array];

            it(@"Should only send the one before cancellation", ^{
                testOperation = [[SDLSequentialRPCRequestOperation alloc] initWithConnectionManager:testConnectionManager requests:sendRequests.copy progressHandler:^BOOL(__kindof SDLRPCRequest * _Nonnull request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error, float percentComplete) {
                    TestRequestProgressResponse *progressResponse = testProgressResponses[request.correlationID];

                    expect(progressResponse.percentComplete).to(beCloseTo(percentComplete));
                    expect(response).toNot(beNil());
                    expect(error).to(beNil());

                    [resultResponses addObject:response];

                    return NO;
                } completionHandler:^(BOOL success) {
                    expect(resultResponses).to(haveCount(1));
                    expect(success).to(beFalsy());
                }];

                [testOperationQueue addOperation:testOperation];
            });
        });
    });
});

QuickSpecEnd
