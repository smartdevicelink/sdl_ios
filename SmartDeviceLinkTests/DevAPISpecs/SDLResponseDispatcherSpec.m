#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLAlert.h"
#import "SDLButtonName.h"
#import "SDLDeleteCommand.h"
#import "SDLDeleteCommandResponse.h"
#import "SDLNotificationConstants.h"
#import "SDLReadDID.h"
#import "SDLReadDIDResponse.h"
#import "SDLResponseDispatcher.h"
#import "SDLRPCRequestFactory.h"
#import "SDLScrollableMessage.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonType.h"
#import "SDLSubscribeButton.h"
#import "SDLSystemAction.h"
#import "SDLTextAlignment.h"
#import "SDLUnsubscribeButton.h"
#import "SDLUnsubscribeButtonResponse.h"


QuickSpecBegin(SDLResponseDispatcherSpec)

describe(@"a response dispatcher", ^{
    __block SDLResponseDispatcher *testDispatcher = nil;
    
    beforeEach(^{
        testDispatcher = [[SDLResponseDispatcher alloc] init];
    });
    
    it(@"should initialize the NSMapTable properties", ^{
        expect(testDispatcher.rpcResponseHandlerMap).toNot(beNil());
        expect(testDispatcher.rpcRequestDictionary).toNot(beNil());
        expect(testDispatcher.commandHandlerMap).toNot(beNil());
        expect(testDispatcher.buttonHandlerMap).toNot(beNil());
        expect(testDispatcher.customButtonHandlerMap).toNot(beNil());
        
        expect(testDispatcher.rpcResponseHandlerMap).to(haveCount(@0));
        expect(testDispatcher.rpcRequestDictionary).to(haveCount(@0));
        expect(testDispatcher.commandHandlerMap).to(haveCount(@0));
        expect(testDispatcher.buttonHandlerMap).to(haveCount(@0));
        expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
    });
    
    context(@"storing a request without a handler", ^{
        it(@"should not store the request", ^{
            SDLReadDID *readDIDRPC = [[SDLReadDID alloc] init];
            [testDispatcher storeRequest:readDIDRPC handler:nil];
            
            expect(testDispatcher.rpcResponseHandlerMap).to(haveCount(@0));
            expect(testDispatcher.rpcRequestDictionary).to(haveCount(@0));
            expect(testDispatcher.commandHandlerMap).to(haveCount(@0));
            expect(testDispatcher.buttonHandlerMap).to(haveCount(@0));
            expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
        });
    });
    
    context(@"storing a request with a handler", ^{
        __block SDLRPCRequest *testRequest = nil;
        __block NSNumber *testCorrelationId = nil;
        __block BOOL handlerCalled = NO;
        
        beforeEach(^{
            testRequest = [[SDLReadDID alloc] init];
            testCorrelationId = @42;
            
            testRequest.correlationID = testCorrelationId;
            [testDispatcher storeRequest:testRequest handler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                handlerCalled = YES;
            }];
        });
        
        it(@"should store the request and response", ^{
            expect(testDispatcher.rpcRequestDictionary[testCorrelationId]).toNot(beNil());
            expect(testDispatcher.rpcRequestDictionary).to(haveCount(@1));
            
            expect(testDispatcher.rpcResponseHandlerMap[testCorrelationId]).toNot(beNil());
            expect(testDispatcher.rpcResponseHandlerMap).to(haveCount(@1));
        });
        
        describe(@"when a response arrives", ^{
            __block SDLRPCResponse *testResponse = nil;
            
            beforeEach(^{
                testResponse = [[SDLReadDIDResponse alloc] init];
                testResponse.correlationID = testCorrelationId;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveReadDIDResponse object:nil userInfo:@{ SDLNotificationUserInfoObject: testResponse }];
            });
            
            it(@"should run the handler", ^{
                expect(@(handlerCalled)).to(beTruthy());
                expect(testDispatcher.rpcRequestDictionary).to(haveCount(@0));
                expect(testDispatcher.rpcResponseHandlerMap).to(haveCount(@0));
            });
        });
    });
    
    context(@"storing a show request", ^{
        __block SDLShow *testShow = nil;
        __block SDLSoftButton *testSoftButton1 = nil;
        
        beforeEach(^{
            testShow = [SDLRPCRequestFactory buildShowWithMainField1:@"Test Show" mainField2:nil alignment:[SDLTextAlignment CENTERED] correlationID:@1];
        });
        
        context(@"with a correct soft button and handler", ^{
            beforeEach(^{
                testSoftButton1 = [SDLRPCRequestFactory buildSoftButtonWithType:[SDLSoftButtonType TEXT] text:@"test" image:nil highlighted:NO buttonID:1 systemAction:[SDLSystemAction DEFAULT_ACTION] handler:^(__kindof SDLRPCNotification * _Nonnull notification) {}];
                
                testShow.softButtons = [@[testSoftButton1] mutableCopy];
                [testDispatcher storeRequest:testShow handler:nil];
            });
            
            it(@"should add the soft button to the map", ^{
                expect(testDispatcher.customButtonHandlerMap[testSoftButton1.softButtonID]).toNot(beNil());
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@1));
            });
        });
        
        context(@"with a correct soft button but no handler", ^{
            beforeEach(^{
                testSoftButton1 = [SDLRPCRequestFactory buildSoftButtonWithType:[SDLSoftButtonType TEXT] text:@"test" image:nil highlighted:NO buttonID:1 systemAction:[SDLSystemAction DEFAULT_ACTION] handler:nil];
            });
            
            it(@"should not add the soft button", ^{
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });
        
        context(@"with a malformed soft button", ^{
            beforeEach(^{
                testSoftButton1 = [SDLRPCRequestFactory buildSoftButtonWithType:[SDLSoftButtonType TEXT] text:@"test" image:nil highlighted:NO buttonID:1 systemAction:[SDLSystemAction DEFAULT_ACTION] handler:^(__kindof SDLRPCNotification * _Nonnull notification) {}];
            });
            
            it(@"should throw an exception if there's no button id", ^{
                testSoftButton1.softButtonID = nil;
                testShow.softButtons = [@[testSoftButton1] mutableCopy];
                
                expectAction(^{ [testDispatcher storeRequest:testShow handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
        });
        
        context(@"without soft buttons", ^{
            it(@"should not store the request", ^{
                [testDispatcher storeRequest:testShow handler:nil];
                
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });
    });
    
    context(@"storing a command request", ^{
        __block SDLAddCommand *testAddCommand = nil;
        __block NSNumber *testCommandId = nil;
        
        __block NSNumber *testAddCommandCorrelationId = nil;
        __block NSNumber *testDeleteCommandCorrelationId = nil;
        
        context(@"with a handler", ^{
            beforeEach(^{
                testCommandId = @1;
                testAddCommandCorrelationId = @42;
                
                testAddCommand = [SDLRPCRequestFactory buildAddCommandWithID:testCommandId vrCommands:nil handler:^(__kindof SDLRPCNotification * _Nonnull notification) {}];
                testAddCommand.correlationID = testAddCommandCorrelationId;
            });
            
            it(@"should add the command to the map", ^{
                [testDispatcher storeRequest:testAddCommand handler:nil];
                
                expect(testDispatcher.commandHandlerMap[testAddCommand.cmdID]).toNot(beNil());
                expect(testDispatcher.commandHandlerMap).to(haveCount(@1));
            });
            
            it(@"should throw an exception if there's no command id", ^{
                testAddCommand.cmdID = nil;
                
                expectAction(^{ [testDispatcher storeRequest:testAddCommand handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
            
            describe(@"then deleting the command", ^{
                __block SDLDeleteCommand *testDeleteCommand = nil;
                __block SDLDeleteCommandResponse *testDeleteResponse = nil;
                
                beforeEach(^{
                    [testDispatcher storeRequest:testAddCommand handler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {}];
                    
                    // We need both the delete command and the response for this to work
                    testDeleteCommandCorrelationId = @43;
                    
                    testDeleteCommand = [[SDLDeleteCommand alloc] init];
                    testDeleteCommand.correlationID = testDeleteCommandCorrelationId;
                    testDeleteCommand.cmdID = testCommandId;
                    
                    [testDispatcher storeRequest:testDeleteCommand handler:nil];
                    
                    testDeleteResponse = [[SDLDeleteCommandResponse alloc] init];
                    testDeleteResponse.correlationID = testDeleteCommandCorrelationId;
                    testDeleteResponse.success = @YES;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveDeleteCommandResponse object:nil userInfo:@{ SDLNotificationUserInfoObject: testDeleteResponse }];
                });
                
                it(@"should have removed all the handlers", ^{
                    // There should still be the add command request & handler in the dictionaries since we never responded
                    expect(testDispatcher.commandHandlerMap).to(haveCount(@0));
                    expect(testDispatcher.rpcRequestDictionary).to(haveCount(@1));
                    expect(testDispatcher.rpcResponseHandlerMap).to(haveCount(@1));
                });
            });
        });
        
        context(@"without a handler", ^{
            beforeEach(^{
                testAddCommand = [SDLRPCRequestFactory buildAddCommandWithID:@1 vrCommands:nil handler:nil];
            });
                                  
            it(@"should not add the command", ^{
                expect(testDispatcher.commandHandlerMap).to(haveCount(@0));
            });
        });
    });
    
    context(@"storing a subscribe button request", ^{
        __block SDLSubscribeButton *testSubscribeButton = nil;
        __block SDLButtonName *testButtonName = nil;
        
        __block NSNumber *testSubscribeCorrelationId = nil;
        __block NSNumber *testUnsubscribeCorrelationId = nil;
        
        context(@"with a handler", ^{
            beforeEach(^{
                testButtonName = [SDLButtonName OK];
                testSubscribeCorrelationId = @42;
                
                testSubscribeButton = [SDLRPCRequestFactory buildSubscribeButtonWithName:testButtonName handler:^(__kindof SDLRPCNotification * _Nonnull notification) {}];
                testSubscribeButton.correlationID = testSubscribeCorrelationId;
            });
            
            it(@"should add the subscription to the map", ^{
                [testDispatcher storeRequest:testSubscribeButton handler:nil];
                
                expect(testDispatcher.buttonHandlerMap[testSubscribeButton.buttonName.value]).toNot(beNil());
                expect(testDispatcher.buttonHandlerMap).to(haveCount(@1));
            });
            
            it(@"should throw an exception if there's no button name", ^{
                testSubscribeButton.buttonName = nil;
                
                expectAction(^{ [testDispatcher storeRequest:testSubscribeButton handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
            
            describe(@"then unsubscribing", ^{
                __block SDLUnsubscribeButton *testUnsubscribe = nil;
                __block SDLUnsubscribeButtonResponse *testUnsubscribeResponse = nil;
                
                beforeEach(^{
                    [testDispatcher storeRequest:testSubscribeButton handler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {}];
                    
                    // We need both the delete command and the response for this to work
                    testUnsubscribeCorrelationId = @43;
                    
                    testUnsubscribe = [[SDLUnsubscribeButton alloc] init];
                    testUnsubscribe.correlationID = testUnsubscribeCorrelationId;
                    testUnsubscribe.buttonName = testButtonName;
                    
                    [testDispatcher storeRequest:testUnsubscribe handler:nil];
                    
                    testUnsubscribeResponse = [[SDLUnsubscribeButtonResponse alloc] init];
                    testUnsubscribeResponse.correlationID = testUnsubscribeCorrelationId;
                    testUnsubscribeResponse.success = @YES;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveUnsubscribeButtonResponse object:nil userInfo:@{ SDLNotificationUserInfoObject: testUnsubscribeResponse }];
                });
                
                it(@"should have removed all the handlers", ^{
                    // There should still be the add command request & handler in the dictionaries since we never responded
                    expect(testDispatcher.commandHandlerMap).to(haveCount(@0));
                    expect(testDispatcher.rpcRequestDictionary).to(haveCount(@1));
                    expect(testDispatcher.rpcResponseHandlerMap).to(haveCount(@1));
                });
            });
        });
    
        context(@"without a handler", ^{
            beforeEach(^{
                testSubscribeButton = [SDLRPCRequestFactory buildSubscribeButtonWithName:[SDLButtonName OK] handler:nil];
            });
            
            it(@"should not add the subscription", ^{
                expect(testDispatcher.buttonHandlerMap).to(haveCount(@0));
            });
        });
    });
    
    context(@"storing an alert request", ^{
        __block SDLAlert *testAlert = nil;
        __block SDLSoftButton *testSoftButton1 = nil;
        
        beforeEach(^{
            testAlert = [SDLRPCRequestFactory buildAlertWithAlertText1:@"test 1" alertText2:@"test 1" alertText3:nil duration:@1 softButtons:nil correlationID:@1];
        });
        
        context(@"with a correct soft button and handler", ^{
            beforeEach(^{
                testSoftButton1 = [SDLRPCRequestFactory buildSoftButtonWithType:[SDLSoftButtonType TEXT] text:@"test" image:nil highlighted:NO buttonID:1 systemAction:[SDLSystemAction DEFAULT_ACTION] handler:^(__kindof SDLRPCNotification * _Nonnull notification) {}];
                
                testAlert.softButtons = [@[testSoftButton1] mutableCopy];
                [testDispatcher storeRequest:testAlert handler:nil];
            });
            
            it(@"should add the soft button to the map", ^{
                expect(testDispatcher.customButtonHandlerMap[testSoftButton1.softButtonID]).toNot(beNil());
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@1));
            });
        });
        
        context(@"with a correct soft button but no handler", ^{
            beforeEach(^{
                testSoftButton1 = [SDLRPCRequestFactory buildSoftButtonWithType:[SDLSoftButtonType TEXT] text:@"test" image:nil highlighted:NO buttonID:1 systemAction:[SDLSystemAction DEFAULT_ACTION] handler:nil];
            });
            
            it(@"should not add the soft button", ^{
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });
        
        context(@"with a malformed soft button", ^{
            beforeEach(^{
                testSoftButton1 = [SDLRPCRequestFactory buildSoftButtonWithType:[SDLSoftButtonType TEXT] text:@"test" image:nil highlighted:NO buttonID:1 systemAction:[SDLSystemAction DEFAULT_ACTION] handler:^(__kindof SDLRPCNotification * _Nonnull notification) {}];
            });
            
            it(@"should throw an exception if there's no button id", ^{
                testSoftButton1.softButtonID = nil;
                testAlert.softButtons = [@[testSoftButton1] mutableCopy];
                
                expectAction(^{ [testDispatcher storeRequest:testAlert handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
        });
        
        context(@"without soft buttons", ^{
            it(@"should not store the request", ^{
                [testDispatcher storeRequest:testAlert handler:nil];
                
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });
    });
    
    context(@"storing a scrollable message request", ^{
        __block SDLScrollableMessage *testScrollableMessage = nil;
        __block SDLSoftButton *testSoftButton1 = nil;
        
        beforeEach(^{
            testScrollableMessage = [SDLRPCRequestFactory buildScrollableMessage:@"test" timeout:@1 softButtons:nil correlationID:@1];
        });
        
        context(@"with a correct soft button and handler", ^{
            beforeEach(^{
                testSoftButton1 = [SDLRPCRequestFactory buildSoftButtonWithType:[SDLSoftButtonType TEXT] text:@"test" image:nil highlighted:NO buttonID:1 systemAction:[SDLSystemAction DEFAULT_ACTION] handler:^(__kindof SDLRPCNotification * _Nonnull notification) {}];
                
                testScrollableMessage.softButtons = [@[testSoftButton1] mutableCopy];
                [testDispatcher storeRequest:testScrollableMessage handler:nil];
            });
            
            it(@"should add the soft button to the map", ^{
                expect(testDispatcher.customButtonHandlerMap[testSoftButton1.softButtonID]).toNot(beNil());
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@1));
            });
        });
        
        context(@"with a correct soft button but no handler", ^{
            beforeEach(^{
                testSoftButton1 = [SDLRPCRequestFactory buildSoftButtonWithType:[SDLSoftButtonType TEXT] text:@"test" image:nil highlighted:NO buttonID:1 systemAction:[SDLSystemAction DEFAULT_ACTION] handler:nil];
            });
            
            it(@"should not add the soft button", ^{
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });
        
        context(@"with a malformed soft button", ^{
            beforeEach(^{
                testSoftButton1 = [SDLRPCRequestFactory buildSoftButtonWithType:[SDLSoftButtonType TEXT] text:@"test" image:nil highlighted:NO buttonID:1 systemAction:[SDLSystemAction DEFAULT_ACTION] handler:^(__kindof SDLRPCNotification * _Nonnull notification) {}];
            });
            
            it(@"should throw an exception if there's no button id", ^{
                testSoftButton1.softButtonID = nil;
                testScrollableMessage.softButtons = [@[testSoftButton1] mutableCopy];
                
                expectAction(^{ [testDispatcher storeRequest:testScrollableMessage handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
        });
        
        context(@"without soft buttons", ^{
            it(@"should not store the request", ^{
                [testDispatcher storeRequest:testScrollableMessage handler:nil];
                
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });
    });
});

QuickSpecEnd
