#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLAlert.h"
#import "SDLAlertManeuver.h"
#import "SDLButtonName.h"
#import "SDLDeleteCommand.h"
#import "SDLDeleteCommandResponse.h"
#import "SDLNotificationConstants.h"
#import "SDLOnAudioPassThru.h"
#import "SDLOnButtonEvent.h"
#import "SDLOnButtonPress.h"
#import "SDLOnCommand.h"
#import "SDLPerformAudioPassThru.h"
#import "SDLPerformAudioPassThruResponse.h"
#import "SDLReadDID.h"
#import "SDLReadDIDResponse.h"
#import "SDLResponseDispatcher.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScrollableMessage.h"
#import "SDLShow.h"
#import "SDLShowConstantTBT.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonType.h"
#import "SDLSubscribeButton.h"
#import "SDLSubtleAlert.h"
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
        expect(testDispatcher.showButtonHandlerMap).toNot(beNil());
        expect(testDispatcher.alertButtonHandlerMap).toNot(beNil());
        expect(testDispatcher.scrollMsgButtonHandlerMap).toNot(beNil());
//        expect(testDispatcher.audioPassThruHandler).to(beNil());

        expect(testDispatcher.rpcResponseHandlerMap).to(haveCount(@0));
        expect(testDispatcher.rpcRequestDictionary).to(haveCount(@0));
        expect(testDispatcher.commandHandlerMap).to(haveCount(@0));
        expect(testDispatcher.buttonHandlerMap).to(haveCount(@0));
        expect(testDispatcher.showButtonHandlerMap).to(haveCount(@0));
        expect(testDispatcher.alertButtonHandlerMap).to(haveCount(@0));
        expect(testDispatcher.scrollMsgButtonHandlerMap).to(haveCount(@0));
    });
    
    context(@"storing a request without a handler", ^{
        __block SDLReadDID *testRPC = nil;
        __block NSNumber *testCorrelationId = nil;
        
        beforeEach(^{
            testRPC = [[SDLReadDID alloc] init];
            testCorrelationId = @111;
            testRPC.correlationID = testCorrelationId;
        });
        
        it(@"should not store the request", ^{
            [testDispatcher storeRequest:testRPC handler:nil];
            
            expect(testDispatcher.rpcResponseHandlerMap).to(haveCount(@0));
            expect(testDispatcher.rpcRequestDictionary).to(haveCount(@1));
            expect(testDispatcher.commandHandlerMap).to(haveCount(@0));
            expect(testDispatcher.buttonHandlerMap).to(haveCount(@0));
            expect(testDispatcher.showButtonHandlerMap).to(haveCount(@0));
            expect(testDispatcher.alertButtonHandlerMap).to(haveCount(@0));
            expect(testDispatcher.scrollMsgButtonHandlerMap).to(haveCount(@0));
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
                
                SDLRPCResponseNotification *responseNotification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveReadDIDResponse object:nil rpcResponse:testResponse];
                [[NSNotificationCenter defaultCenter] postNotification:responseNotification];
            });
            
            it(@"should run the handler", ^{
                expect(@(handlerCalled)).toEventually(beTrue());
                expect(testDispatcher.rpcRequestDictionary).to(haveCount(@0));
                expect(testDispatcher.rpcResponseHandlerMap).to(haveCount(@0));
            });
        });
    });
    
    context(@"storing a show request", ^{
        __block SDLShow *testShow = nil;
        __block SDLSoftButton *testSoftButton1 = nil;
        __block NSUInteger numTimesHandlerCalled = 0;
        
        beforeEach(^{
            testShow = [[SDLShow alloc] initWithMainField1:@"Test Show" mainField2:nil alignment:SDLTextAlignmentCenter];
            testShow.correlationID = @1;
        });
        
        context(@"with a correct soft button and handler", ^{
            beforeEach(^{
                numTimesHandlerCalled = 0;
                
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
                    numTimesHandlerCalled++;
                }];
                testShow.softButtons = [@[testSoftButton1] mutableCopy];
                testShow.correlationID = @1;
                [testDispatcher storeRequest:testShow handler:nil];
            });
            
            it(@"should add the soft button to the map", ^{
                expect(testDispatcher.showButtonHandlerMap[testSoftButton1.softButtonID]).toNot(beNil());
                expect(testDispatcher.showButtonHandlerMap).to(haveCount(@1));
            });
            
            describe(@"when button press and button event notifications arrive", ^{
                __block SDLOnButtonEvent *testButtonEvent = nil;
                __block SDLOnButtonPress *testButtonPress = nil;
                
                context(@"that correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.customButtonID = testSoftButton1.softButtonID;
                        testButtonEvent.buttonName = SDLButtonNameCustomButton;
                        
                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.customButtonID = testSoftButton1.softButtonID;
                        testButtonPress.buttonName = SDLButtonNameCustomButton;
                        
                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });
                    
                    it(@"should run the handler for each", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@2));
                    });
                });
                
                context(@"that do not correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameOk;
                        
                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameOk;
                        
                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });
                    
                    it(@"should not run the handler", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@0));
                    });
                });
            });
        });
        
        context(@"with a correct soft button but no handler", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });
            
            it(@"should not add the soft button", ^{
                expect(testDispatcher.showButtonHandlerMap).to(haveCount(@0));
            });
        });
        
        context(@"with a malformed soft button", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });
            
            it(@"should throw an exception if there's no button id", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
                testSoftButton1.softButtonID = nil;
#pragma clang diagnostic pop
                testShow.softButtons = [@[testSoftButton1] mutableCopy];
                
                expectAction(^{ [testDispatcher storeRequest:testShow handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
        });
        
        context(@"without soft buttons", ^{
            it(@"should not store the request", ^{
                [testDispatcher storeRequest:testShow handler:nil];
                
                expect(testDispatcher.showButtonHandlerMap).to(haveCount(@0));
            });
        });
    });
    
    context(@"storing a command request", ^{
        __block SDLAddCommand *testAddCommand = nil;
        __block UInt32 testCommandId = 0;
        __block NSUInteger numTimesHandlerCalled = 0;
        
        __block NSNumber *testAddCommandCorrelationId = nil;
        __block NSNumber *testDeleteCommandCorrelationId = nil;
        
        context(@"with a handler", ^{
            beforeEach(^{
                testCommandId = 1;
                testAddCommandCorrelationId = @42;
                numTimesHandlerCalled = 0;
                
                testAddCommand = [[SDLAddCommand alloc] initWithId:testCommandId vrCommands:nil handler:^(__kindof SDLRPCNotification * _Nonnull notification) {
                    numTimesHandlerCalled++;
                }];
                testAddCommand.correlationID = testAddCommandCorrelationId;
            });
            
            it(@"should add the command to the map", ^{
                [testDispatcher storeRequest:testAddCommand handler:nil];
                
                expect(testDispatcher.commandHandlerMap[testAddCommand.cmdID]).toNot(beNil());
                expect(testDispatcher.commandHandlerMap).to(haveCount(@1));
            });
            
            it(@"should throw an exception if there's no command id", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
                testAddCommand.cmdID = nil;
                
#pragma clang diagnostic pop
                expectAction(^{ [testDispatcher storeRequest:testAddCommand handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
            
            describe(@"when button press and button event notifications arrive", ^{
                __block SDLOnCommand *testOnCommand = nil;
                
                beforeEach(^{
                    [testDispatcher storeRequest:testAddCommand handler:nil];
                });
                
                context(@"that correspond to the created button", ^{
                    beforeEach(^{
                        testOnCommand = [[SDLOnCommand alloc] init];
                        testOnCommand.cmdID = @(testCommandId);
                        testOnCommand.triggerSource = SDLTriggerSourceMenu;
                        
                        SDLRPCNotificationNotification *commandNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveCommandNotification object:nil rpcNotification:testOnCommand];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:commandNotification];
                    });
                    
                    it(@"should run the handler for each", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@1));
                    });
                });
                
                context(@"that do not correspond to the created button", ^{
                    beforeEach(^{
                        testOnCommand = [[SDLOnCommand alloc] init];
                        testOnCommand.cmdID = @999;
                        
                        SDLRPCNotificationNotification *commandNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveCommandNotification object:nil rpcNotification:testOnCommand];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:commandNotification];
                    });
                    
                    it(@"should not run the handler", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@0));
                    });
                });
            });
            
            describe(@"then deleting the command", ^{
                __block SDLDeleteCommand *testDeleteCommand = nil;
                __block SDLDeleteCommandResponse *testDeleteResponse = nil;
                __block NSUInteger deleteCommandHandlerMapCount = 0;
                
                beforeEach(^{
                    [testDispatcher storeRequest:testAddCommand handler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {}];
                    
                    // We need both the delete command and the response for this to work
                    testDeleteCommandCorrelationId = @43;
                    
                    testDeleteCommand = [[SDLDeleteCommand alloc] init];
                    testDeleteCommand.correlationID = testDeleteCommandCorrelationId;
                    testDeleteCommand.cmdID = @(testCommandId);
                    
                    [testDispatcher storeRequest:testDeleteCommand handler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
                        deleteCommandHandlerMapCount = testDispatcher.commandHandlerMap.count;
                    }];
                    
                    testDeleteResponse = [[SDLDeleteCommandResponse alloc] init];
                    testDeleteResponse.correlationID = testDeleteCommandCorrelationId;
                    testDeleteResponse.success = @YES;
                    
                    SDLRPCResponseNotification *deleteCommandNotification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveDeleteCommandResponse object:nil rpcResponse:testDeleteResponse];
                    [[NSNotificationCenter defaultCenter] postNotification:deleteCommandNotification];
                });
                
                it(@"should have removed all the handlers", ^{
                    // There should still be the add command request & handler in the dictionaries since we never responded to those RPCs, but the command handler map should have removed the addCommand handler
                    expect(testDispatcher.commandHandlerMap).to(haveCount(0));
                    expect(testDispatcher.rpcRequestDictionary.allKeys).to(haveCount(1));
                    expect(testDispatcher.rpcResponseHandlerMap).to(haveCount(1));
                    expect(deleteCommandHandlerMapCount).to(equal(0));
                });
            });
        });
        
        context(@"without a handler", ^{
            beforeEach(^{
                testAddCommand = [[SDLAddCommand alloc] initWithId:1 vrCommands:nil handler:nil];
            });
                                  
            it(@"should not add the command", ^{
                expect(testDispatcher.commandHandlerMap).to(haveCount(@0));
            });
        });
    });
    
    context(@"storing a subscribe button request", ^{
        __block SDLSubscribeButton *testSubscribeButton = nil;
        __block SDLButtonName testButtonName = nil;
        __block NSUInteger numTimesHandlerCalled = 0;
        
        __block NSNumber *testSubscribeCorrelationId = nil;
        __block NSNumber *testUnsubscribeCorrelationId = nil;
        
        context(@"with a handler", ^{
            beforeEach(^{
                testButtonName = SDLButtonNameOk;
                testSubscribeCorrelationId = @42;
                numTimesHandlerCalled = 0;
                
                testSubscribeButton = [[SDLSubscribeButton alloc] initWithButtonName:testButtonName handler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
                    numTimesHandlerCalled++;
                }];
                testSubscribeButton.correlationID = testSubscribeCorrelationId;
            });
            
            it(@"should add the subscription to the map", ^{
                [testDispatcher storeRequest:testSubscribeButton handler:nil];
                
                expect(testDispatcher.buttonHandlerMap[testSubscribeButton.buttonName]).toNot(beNil());
                expect(testDispatcher.buttonHandlerMap).to(haveCount(@1));
            });
            
            it(@"should throw an exception if there's no button name", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
                testSubscribeButton.buttonName = nil;
#pragma clang diagnostic pop
                
                expectAction(^{ [testDispatcher storeRequest:testSubscribeButton handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
            
            describe(@"when button press and button event notifications arrive", ^{
                __block SDLOnButtonEvent *testButtonEvent = nil;
                __block SDLOnButtonPress *testButtonPress = nil;
                
                beforeEach(^{
                    [testDispatcher storeRequest:testSubscribeButton handler:nil];
                });
                
                context(@"that correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = testButtonName;
                        
                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = testButtonName;
                        
                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });
                    
                    it(@"should run the handler for each", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@2));
                    });
                });
                
                context(@"that do not correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNamePreset0;
                        
                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNamePreset0;
                        
                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });
                    
                    it(@"should not run the handler", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@0));
                    });
                });
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
                    
                    SDLRPCResponseNotification *unsubscribeNotification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveUnsubscribeButtonResponse object:nil rpcResponse:testUnsubscribeResponse];
                    [[NSNotificationCenter defaultCenter] postNotification:unsubscribeNotification];
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
                testSubscribeButton = [[SDLSubscribeButton alloc] initWithButtonName:SDLButtonNameOk handler:nil];
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
            testAlert = [[SDLAlert alloc] initWithAlertText1:@"test 1" alertText2:@"test 2" alertText3:nil softButtons:nil playTone:false ttsChunks:nil duration:1 progressIndicator:false alertIcon:nil cancelID:0];
            testAlert.correlationID = @1;
        });
        
        context(@"with a correct soft button and handler", ^{
            __block NSUInteger numTimesHandlerCalled = 0;
            
            beforeEach(^{
                numTimesHandlerCalled = 0;
                
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
                    numTimesHandlerCalled++;
                }];
                
                testAlert.softButtons = [@[testSoftButton1] mutableCopy];
                [testDispatcher storeRequest:testAlert handler:nil];
            });
            
            it(@"should add the soft button to the map", ^{
                expect(testDispatcher.alertButtonHandlerMap[testSoftButton1.softButtonID]).toNot(beNil());
                expect(testDispatcher.alertButtonHandlerMap).to(haveCount(@1));
            });
            
            describe(@"when button press and button event notifications arrive", ^{
                __block SDLOnButtonEvent *testButtonEvent = nil;
                __block SDLOnButtonPress *testButtonPress = nil;
                
                context(@"that correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameCustomButton;
                        testButtonEvent.customButtonID = testSoftButton1.softButtonID;
                        
                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameCustomButton;
                        testButtonPress.customButtonID = testSoftButton1.softButtonID;
                        
                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });
                    
                    it(@"should run the handler for each", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@2));
                    });
                });
                
                context(@"that do not correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameOk;
                        
                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameOk;
                    
                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });
                    
                    it(@"should not run the handler", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@0));
                    });
                });
            });
        });
        
        context(@"with a correct soft button but no handler", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });
            
            it(@"should not add the soft button", ^{
                expect(testDispatcher.alertButtonHandlerMap).to(haveCount(@0));
            });
        });
        
        context(@"with a malformed soft button", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });
            
            it(@"should throw an exception if there's no button id", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
                testSoftButton1.softButtonID = nil;
#pragma clang diagnostic pop
                testAlert.softButtons = [@[testSoftButton1] mutableCopy];
                
                expectAction(^{ [testDispatcher storeRequest:testAlert handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
        });
        
        context(@"without soft buttons", ^{
            it(@"should not store the request", ^{
                [testDispatcher storeRequest:testAlert handler:nil];
                
                expect(testDispatcher.alertButtonHandlerMap).to(haveCount(@0));
            });
        });
    });

    context(@"storing a subtle alert request", ^{
        __block SDLSubtleAlert *testSubtleAlert = nil;
        __block SDLSoftButton *testSoftButton1 = nil;

        beforeEach(^{
            testSubtleAlert = [[SDLSubtleAlert alloc] initWithAlertText1:@"alertText1" alertText2:nil alertIcon:nil ttsChunks:nil duration:nil softButtons:nil cancelID:nil];
            testSubtleAlert.correlationID = @23;
        });

        context(@"with a correct soft button and handler", ^{
            __block NSUInteger numTimesHandlerCalled = 0;

            beforeEach(^{
                numTimesHandlerCalled = 0;

                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
                    numTimesHandlerCalled++;
                }];

                testSubtleAlert.softButtons = @[testSoftButton1];
                [testDispatcher storeRequest:testSubtleAlert handler:nil];
            });

            it(@"should add the soft button to the map", ^{
                expect(testDispatcher.customButtonHandlerMap[testSoftButton1.softButtonID]).toNot(beNil());
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@1));
            });

            describe(@"when button press and button event notifications arrive", ^{
                __block SDLOnButtonEvent *testButtonEvent = nil;
                __block SDLOnButtonPress *testButtonPress = nil;

                context(@"that correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameCustomButton;
                        testButtonEvent.customButtonID = testSoftButton1.softButtonID;

                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameCustomButton;
                        testButtonPress.customButtonID = testSoftButton1.softButtonID;

                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];

                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });

                    it(@"should run the handler for each", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@2));
                    });
                });

                context(@"that do not correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameOk;

                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameOk;

                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];

                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });

                    it(@"should not run the handler", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@0));
                    });
                });
            });
        });

        context(@"with a correct soft button but no handler", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });

            it(@"should not add the soft button", ^{
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });

        context(@"with a malformed soft button", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });

            it(@"should throw an exception if there's no button id", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
                testSoftButton1.softButtonID = nil;
#pragma clang diagnostic pop
                testSubtleAlert.softButtons = @[testSoftButton1];

                expectAction(^{ [testDispatcher storeRequest:testSubtleAlert handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
        });

        context(@"without soft buttons", ^{
            it(@"should not store the request", ^{
                [testDispatcher storeRequest:testSubtleAlert handler:nil];

                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });
    });

    context(@"storing an alert maneuver request", ^{
        __block SDLAlertManeuver *testAlertManeuver = nil;
        __block SDLSoftButton *testSoftButton1 = nil;

        beforeEach(^{
            testAlertManeuver = [[SDLAlertManeuver alloc] initWithTTS:@"Test Alert Maneuver" softButtons:nil];
            testAlertManeuver.correlationID = @223;
        });

        context(@"with a correct soft button and handler", ^{
            __block NSUInteger numTimesHandlerCalled = 0;

            beforeEach(^{
                numTimesHandlerCalled = 0;

                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
                    numTimesHandlerCalled++;
                }];

                testAlertManeuver.softButtons = @[testSoftButton1];
                [testDispatcher storeRequest:testAlertManeuver handler:nil];
            });

            it(@"should add the soft button to the map", ^{
                expect(testDispatcher.customButtonHandlerMap[testSoftButton1.softButtonID]).toNot(beNil());
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@1));
            });

            describe(@"when button press and button event notifications arrive", ^{
                __block SDLOnButtonEvent *testButtonEvent = nil;
                __block SDLOnButtonPress *testButtonPress = nil;

                context(@"that correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameCustomButton;
                        testButtonEvent.customButtonID = testSoftButton1.softButtonID;

                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameCustomButton;
                        testButtonPress.customButtonID = testSoftButton1.softButtonID;

                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];

                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });

                    it(@"should run the handler for each", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@2));
                    });
                });

                context(@"that do not correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameOk;

                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameOk;

                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];

                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });

                    it(@"should not run the handler", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@0));
                    });
                });
            });
        });

        context(@"with a correct soft button but no handler", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });

            it(@"should not add the soft button", ^{
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });

        context(@"with a malformed soft button", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });

            it(@"should throw an exception if there's no button id", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
                testSoftButton1.softButtonID = nil;
#pragma clang diagnostic pop
                testAlertManeuver.softButtons = @[testSoftButton1];

                expectAction(^{ [testDispatcher storeRequest:testAlertManeuver handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
        });

        context(@"without soft buttons", ^{
            it(@"should not store the request", ^{
                [testDispatcher storeRequest:testAlertManeuver handler:nil];

                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });
    });

    context(@"storing a show constant turn-by-turn request", ^{
        __block SDLShowConstantTBT *testShowConstantTBT = nil;
        __block SDLSoftButton *testSoftButton1 = nil;

        beforeEach(^{
            testShowConstantTBT = [[SDLShowConstantTBT alloc] initWithNavigationText1:@"nav text" navigationText2:nil eta:nil timeToDestination:nil totalDistance:nil turnIcon:nil nextTurnIcon:nil distanceToManeuver:34 distanceToManeuverScale:23 maneuverComplete:true softButtons:nil];
            testShowConstantTBT.correlationID = @1;
        });

        context(@"with a correct soft button and handler", ^{
            __block NSUInteger numTimesHandlerCalled = 0;

            beforeEach(^{
                numTimesHandlerCalled = 0;

                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
                    numTimesHandlerCalled++;
                }];

                testShowConstantTBT.softButtons = @[testSoftButton1];
                [testDispatcher storeRequest:testShowConstantTBT handler:nil];
            });

            it(@"should add the soft button to the map", ^{
                expect(testDispatcher.customButtonHandlerMap[testSoftButton1.softButtonID]).toNot(beNil());
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@1));
            });

            describe(@"when button press and button event notifications arrive", ^{
                __block SDLOnButtonEvent *testButtonEvent = nil;
                __block SDLOnButtonPress *testButtonPress = nil;

                context(@"that correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameCustomButton;
                        testButtonEvent.customButtonID = testSoftButton1.softButtonID;

                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameCustomButton;
                        testButtonPress.customButtonID = testSoftButton1.softButtonID;

                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];

                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });

                    it(@"should run the handler for each", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@2));
                    });
                });

                context(@"that do not correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameOk;

                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameOk;

                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];

                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });

                    it(@"should not run the handler", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@0));
                    });
                });
            });
        });

        context(@"with a correct soft button but no handler", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });

            it(@"should not add the soft button", ^{
                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });

        context(@"with a malformed soft button", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });

            it(@"should throw an exception if there's no button id", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
                testSoftButton1.softButtonID = nil;
#pragma clang diagnostic pop
                testShowConstantTBT.softButtons = @[testSoftButton1];

                expectAction(^{ [testDispatcher storeRequest:testShowConstantTBT handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
        });

        context(@"without soft buttons", ^{
            it(@"should not store the request", ^{
                [testDispatcher storeRequest:testShowConstantTBT handler:nil];

                expect(testDispatcher.customButtonHandlerMap).to(haveCount(@0));
            });
        });
    });

    context(@"storing a scrollable message request", ^{
        __block SDLScrollableMessage *testScrollableMessage = nil;
        __block SDLSoftButton *testSoftButton1 = nil;
        
        beforeEach(^{
            testScrollableMessage = [[SDLScrollableMessage alloc] initWithMessage:@"test" timeout:1 softButtons:nil cancelID:0];
            testScrollableMessage.correlationID = @1;
        });
        
        context(@"with a correct soft button and handler", ^{
            __block NSUInteger numTimesHandlerCalled = 0;
            
            beforeEach(^{
                numTimesHandlerCalled = 0;
                
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:^(SDLOnButtonPress * _Nullable buttonPressNotification, SDLOnButtonEvent * _Nullable buttonEventNotification) {
                    numTimesHandlerCalled++;
                }];
                
                testScrollableMessage.softButtons = [@[testSoftButton1] mutableCopy];
                [testDispatcher storeRequest:testScrollableMessage handler:nil];
            });
            
            it(@"should add the soft button to the map", ^{
                expect(testDispatcher.scrollMsgButtonHandlerMap[testSoftButton1.softButtonID]).toNot(beNil());
                expect(testDispatcher.scrollMsgButtonHandlerMap).to(haveCount(@1));
            });
            
            describe(@"when button press and button event notifications arrive", ^{
                __block SDLOnButtonEvent *testButtonEvent = nil;
                __block SDLOnButtonPress *testButtonPress = nil;
                
                context(@"that correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameCustomButton;
                        testButtonEvent.customButtonID = testSoftButton1.softButtonID;
                        
                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameCustomButton;
                        testButtonPress.customButtonID = testSoftButton1.softButtonID;
                        
                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });
                    
                    it(@"should run the handler for each", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@2));
                    });
                });
                
                context(@"that do not correspond to the created button", ^{
                    beforeEach(^{
                        testButtonEvent = [[SDLOnButtonEvent alloc] init];
                        testButtonEvent.buttonName = SDLButtonNameOk;
                        
                        testButtonPress = [[SDLOnButtonPress alloc] init];
                        testButtonPress.buttonName = SDLButtonNameOk;
                        
                        SDLRPCNotificationNotification *buttonEventNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonEventNotification object:nil rpcNotification:testButtonEvent];
                        SDLRPCNotificationNotification *buttonPressNotification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveButtonPressNotification object:nil rpcNotification:testButtonPress];
                        
                        [[NSNotificationCenter defaultCenter] postNotification:buttonEventNotification];
                        [[NSNotificationCenter defaultCenter] postNotification:buttonPressNotification];
                    });
                    
                    it(@"should not run the handler", ^{
                        expect(@(numTimesHandlerCalled)).to(equal(@0));
                    });
                });
            });
        });
        
        context(@"with a correct soft button but no handler", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });
            
            it(@"should not add the soft button", ^{
                expect(testDispatcher.scrollMsgButtonHandlerMap).to(haveCount(@0));
            });
        });
        
        context(@"with a malformed soft button", ^{
            beforeEach(^{
                testSoftButton1 = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"test" image:nil highlighted:NO buttonId:1 systemAction:SDLSystemActionDefaultAction handler:nil];
            });
            
            it(@"should throw an exception if there's no button id", ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
                testSoftButton1.softButtonID = nil;
#pragma clang diagnostic pop
                testScrollableMessage.softButtons = [@[testSoftButton1] mutableCopy];
                
                expectAction(^{ [testDispatcher storeRequest:testScrollableMessage handler:nil]; }).to(raiseException().named(@"MissingIdException"));
            });
        });
        
        context(@"without soft buttons", ^{
            it(@"should not store the request", ^{
                [testDispatcher storeRequest:testScrollableMessage handler:nil];
                
                expect(testDispatcher.scrollMsgButtonHandlerMap).to(haveCount(@0));
            });
        });
    });
    
    context(@"storing an audio pass thru handler", ^{
        __block SDLPerformAudioPassThru *testPerformAudioPassThru = nil;
        __block NSUInteger numTimesHandlerCalled = 0;
        
        context(@"with a handler", ^{
            beforeEach(^{
                testPerformAudioPassThru = [[SDLPerformAudioPassThru alloc] initWithSamplingRate:SDLSamplingRate8KHZ bitsPerSample:SDLBitsPerSample8Bit audioType:SDLAudioTypePCM maxDuration:1000 audioDataHandler:^(NSData * _Nullable audioData) {
                    numTimesHandlerCalled++;
                }];
                
                testPerformAudioPassThru.correlationID = @1;
                [testDispatcher storeRequest:testPerformAudioPassThru handler:nil];
            });

            it(@"should store the handler" ,^{
                expect((id)testDispatcher.audioPassThruHandler).toNot(beNil());
                expect((id)testDispatcher.audioPassThruHandler).to(equal((id)testPerformAudioPassThru.audioDataHandler));
            });
            
            describe(@"when an on audio data notification arrives", ^{
                beforeEach(^{
                    SDLOnAudioPassThru *testOnAudioPassThru = [[SDLOnAudioPassThru alloc] init];

                    SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveAudioPassThruNotification object:nil rpcNotification:testOnAudioPassThru];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });
                
                it(@"should run the handler", ^{
                    expect(numTimesHandlerCalled).to(equal(1));
                });
            });

            describe(@"when an on audio data response arrives", ^{
                beforeEach(^{
                    SDLPerformAudioPassThruResponse *performAudioPassThruResponse = [[SDLPerformAudioPassThruResponse alloc] init];
                    performAudioPassThruResponse.success = @YES;

                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceivePerformAudioPassThruResponse object:nil rpcResponse:performAudioPassThruResponse];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });

                it(@"should clear the handler", ^{
                    expect((id)testDispatcher.audioPassThruHandler).to(beNil());
                    expect(@(numTimesHandlerCalled)).to(equal(1));
                });
            });
        });
        
        context(@"without a handler", ^{
            beforeEach(^{
                numTimesHandlerCalled = 0;
                
                testPerformAudioPassThru = [[SDLPerformAudioPassThru alloc] initWithSamplingRate:SDLSamplingRate8KHZ bitsPerSample:SDLBitsPerSample8Bit audioType:SDLAudioTypePCM maxDuration:1000];
                
                testPerformAudioPassThru.correlationID = @1;
                [testDispatcher storeRequest:testPerformAudioPassThru handler:nil];
            });
            
            describe(@"when an on audio data notification arrives", ^{
               beforeEach(^{
                   SDLOnAudioPassThru *testOnAudioPassThru = [[SDLOnAudioPassThru alloc] init];
                   
                   SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidReceiveAudioPassThruNotification object:nil rpcNotification:testOnAudioPassThru];
                   [[NSNotificationCenter defaultCenter] postNotification:notification];
               });
               
               it(@"should not run a handler", ^{
                   expect(@(numTimesHandlerCalled)).to(equal(@0));
               });
            });
        
            describe(@"when an on audio data response arrives", ^{
                beforeEach(^{
                    SDLPerformAudioPassThruResponse *performAudioPassThruResponse = [[SDLPerformAudioPassThruResponse alloc] init];
                    performAudioPassThruResponse.success = @YES;
                    
                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceivePerformAudioPassThruResponse object:nil rpcResponse:performAudioPassThruResponse];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                });
                
                it(@"should clear the handler", ^{
//                    expect(testDispatcher.audioPassThruHandler).to(beNil());
                });
            });
            
        });
    });
});

QuickSpecEnd
