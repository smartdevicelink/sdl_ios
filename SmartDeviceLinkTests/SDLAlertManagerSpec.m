//
//  SDLAlertManagerSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 11/18/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLAlertManager.h"
#import "SDLAlertView.h"
#import "SDLFileManager.h"
#import "SDLPermissionElement.h"
#import "SDLPermissionManager.h"
#import "SDLPresentAlertOperation.h"
#import "SDLSystemCapabilityManager.h"
#import "SDLWindowCapability.h"
#import "TestConnectionManager.h"

@interface SDLAlertManager()

@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (assign, nonatomic) UInt16 nextCancelId;

@end

@interface SDLPresentAlertOperation()

@property (copy, nonatomic, nullable) NSError *internalError;
@property (assign, nonatomic) UInt16 cancelId;

@end

QuickSpecBegin(SDLAlertManagerSpec)

describe(@"alert manager tests", ^{
    __block SDLAlertManager *testAlertManager = nil;
    __block id mockConnectionManager = nil;
    __block id mockFileManager = nil;
    __block id mockSystemCapabilityManager = nil;
    __block id mockCurrentWindowCapability = nil;
    __block id mockPermissionManager = nil;

    beforeEach(^{
        mockConnectionManager = OCMProtocolMock(@protocol(SDLConnectionManagerType));
        mockFileManager = OCMClassMock([SDLFileManager class]);
        mockSystemCapabilityManager = OCMClassMock([SDLSystemCapabilityManager class]);
        mockCurrentWindowCapability = OCMClassMock([SDLWindowCapability class]);
        mockPermissionManager = OCMClassMock([SDLPermissionManager class]);
    });

    describe(@"when initialized", ^{
        it(@"should not start the transaction queue until the alert rpc has the correct permissions to be sent", ^{
            testAlertManager = [[SDLAlertManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager permissionManager:mockPermissionManager];

            expect(testAlertManager.transactionQueue.suspended).to(beTrue());
        });

        it(@"should start the transaction queue if the permission manager is nil", ^{
            testAlertManager = [[SDLAlertManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager permissionManager:nil];

            expect(testAlertManager.transactionQueue.suspended).to(beFalse());
        });
    });

    describe(@"when permissions state changes", ^{
        it(@"should start the transaction queue when the alert rpc has the correct permissions to be sent", ^{
            OCMStub([mockPermissionManager subscribeToRPCPermissions:[OCMArg any] groupType:SDLPermissionGroupTypeAny withHandler:([OCMArg invokeBlockWithArgs:[NSDictionary dictionary], @(SDLPermissionGroupStatusAllowed), nil])]);

            testAlertManager = [[SDLAlertManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager permissionManager:mockPermissionManager];

            expect(testAlertManager.transactionQueue.suspended).to(beFalse());
        });

        it(@"should suspend the transaction queue if the alert rpc does not have the correct permissions to be sent", ^{
            OCMStub([mockPermissionManager subscribeToRPCPermissions:[OCMArg any] groupType:SDLPermissionGroupTypeAny withHandler:([OCMArg invokeBlockWithArgs:[NSDictionary dictionary], @(SDLPermissionGroupStatusDisallowed), nil])]);

            testAlertManager = [[SDLAlertManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager permissionManager:mockPermissionManager];

            expect(testAlertManager.transactionQueue.suspended).to(beTrue());
        });
    });

    describe(@"generating a cancel id", ^{
        __block SDLAlertView *testAlertView = nil;
        beforeEach(^{
            testAlertView = [[SDLAlertView alloc] initWithText:@"alert text" secondaryText:nil tertiaryText:nil timeout:5.0 showWaitIndicator:false audioIndication:nil buttons:nil icon:nil];
            testAlertManager = [[SDLAlertManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager permissionManager:mockPermissionManager];
        });

        it(@"should set the first cancelID correctly", ^{
            [testAlertManager presentAlert:testAlertView withCompletionHandler:nil];

            expect(testAlertManager.transactionQueue.operations.count).to(equal(1));

            SDLPresentAlertOperation *testPresentOp = (SDLPresentAlertOperation *)testAlertManager.transactionQueue.operations.firstObject;
            expect(@(testPresentOp.cancelId)).to(equal(1));
        });

        it(@"should reset the cancelID correctly once the max has been reached", ^{
            testAlertManager.nextCancelId = 1000;
            [testAlertManager presentAlert:testAlertView withCompletionHandler:nil];

            expect(testAlertManager.transactionQueue.operations.count).to(equal(1));

            SDLPresentAlertOperation *testPresentOp = (SDLPresentAlertOperation *)testAlertManager.transactionQueue.operations[0];
            expect(@(testPresentOp.cancelId)).to(equal(1000));

            [testAlertManager presentAlert:testAlertView withCompletionHandler:nil];

            expect(testAlertManager.transactionQueue.operations.count).to(equal(2));

            SDLPresentAlertOperation *testPresentOp2 = (SDLPresentAlertOperation *)testAlertManager.transactionQueue.operations[1];
            expect(@(testPresentOp2.cancelId)).to(equal(1));
        });
    });

    describe(@"presenting an alert", ^{
        __block SDLAlertView *testAlertView = nil;
        __block SDLAlertView *testAlertView2 = nil;

        beforeEach(^{
            testAlertView = [[SDLAlertView alloc] initWithText:@"alert text" secondaryText:nil tertiaryText:nil timeout:5.0 showWaitIndicator:false audioIndication:nil buttons:nil icon:nil];
            testAlertView2 = [[SDLAlertView alloc] initWithText:@"alert 2 text" secondaryText:nil tertiaryText:nil timeout:5.0 showWaitIndicator:false audioIndication:nil buttons:nil icon:nil];
            testAlertManager = [[SDLAlertManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager systemCapabilityManager:mockSystemCapabilityManager permissionManager:mockPermissionManager];
        });

        it(@"should add the alert operation to the queue", ^{
            [testAlertManager presentAlert:testAlertView withCompletionHandler:nil];

            expect(testAlertManager.transactionQueue.operations.count).to(equal(1));
            expect(testAlertManager.transactionQueue.operations.firstObject).to(beAKindOf([SDLPresentAlertOperation class]));
        });

        describe(@"when the completion handler is called", ^{
            __block BOOL completionHandlerCalled = NO;
            __block NSError *completionHandlerError = nil;

            beforeEach(^{
                completionHandlerCalled = NO;
                completionHandlerError = nil;

                [testAlertManager presentAlert:testAlertView withCompletionHandler:^(NSError * _Nullable error) {
                    completionHandlerCalled = YES;
                    completionHandlerError = error;
                }];
            });

            context(@"without an error", ^{
                it(@"should call the handler", ^{
                    SDLPresentAlertOperation *op = testAlertManager.transactionQueue.operations.lastObject;
                    op.internalError = nil;
                    op.completionBlock();

                    expect(completionHandlerCalled).to(beTrue());
                    expect(completionHandlerError).to(beNil());
                });
            });

            context(@"with an error", ^{
                __block NSError *testError;

                beforeEach(^{
                    testError = [NSError errorWithDomain:@"com.sdl.testConnectionManager" code:-1 userInfo:nil];
                });

                it(@"should call the handler with the error", ^{
                    SDLPresentAlertOperation *op = testAlertManager.transactionQueue.operations.lastObject;
                    op.internalError = testError;
                    op.completionBlock();

                    expect(completionHandlerCalled).to(beTrue());
                    expect(completionHandlerError).to(equal(testError));
                });
            });
        });

        describe(@"when the manager shuts down during presentation", ^{
            beforeEach(^{
                [testAlertManager presentAlert:testAlertView withCompletionHandler:nil];
                [testAlertManager presentAlert:testAlertView2 withCompletionHandler:nil];
            });

            it(@"should cancel any pending operations", ^{
                SDLPresentAlertOperation *presentAlertOp1 = testAlertManager.transactionQueue.operations[0];
                SDLPresentAlertOperation *presentAlertOp2 = testAlertManager.transactionQueue.operations[1];

                [testAlertManager stop];

                expect(presentAlertOp1.isCancelled).to(beTrue());
                expect(presentAlertOp2.isCancelled).to(beTrue());
                expect(testAlertManager.transactionQueue.operationCount).to(equal(0));
            });
        });
    });
});

QuickSpecEnd
