#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLAlert.h"
#import "SDLButtonName.h"
#import "SDLReadDID.h"
#import "SDLResponseDispatcher.h"
#import "SDLRPCRequestFactory.h"
#import "SDLScrollableMessage.h"
#import "SDLShow.h"
#import "SDLSoftButton.h"
#import "SDLSoftButtonType.h"
#import "SDLSubscribeButton.h"
#import "SDLSystemAction.h"
#import "SDLTextAlignment.h"


QuickSpecBegin(SDLResponseDispatcherSpec)

fdescribe(@"a response dispatcher", ^{
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
    
    context(@"adding a request without a handler", ^{
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
    
    context(@"adding a request with a handler", ^{
        
    });
    
    context(@"adding a show request", ^{
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
    
    context(@"adding a command request", ^{
        __block SDLAddCommand *testAddCommand = nil;
        
        context(@"with a handler", ^{
            beforeEach(^{
                testAddCommand = [SDLRPCRequestFactory buildAddCommandWithID:@1 vrCommands:nil handler:^(__kindof SDLRPCNotification * _Nonnull notification) {}];
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
    
    context(@"adding a subscribe button request", ^{
        __block SDLSubscribeButton *testSubscribeButton = nil;
        
        context(@"with a handler", ^{
            beforeEach(^{
                testSubscribeButton = [SDLRPCRequestFactory buildSubscribeButtonWithName:[SDLButtonName OK] handler:^(__kindof SDLRPCNotification * _Nonnull notification) {}];
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
    
    context(@"adding an alert request", ^{
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
    
    context(@"adding a scrollable message request", ^{
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
