//
//  SDLEncryptionLifecycleManagerSpec.m
//  SmartDeviceLinkTests
//
//  Created by standa1 on 7/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLDisplayCapabilities.h"
#import "SDLConfiguration.h"
#import "SDLEncryptionConfiguration.h"
#import "SDLEncryptionLifecycleManager.h"
#import "SDLEncryptionManagerConstants.h"
#import "SDLFakeSecurityManager.h"
#import "SDLGlobals.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLOnHMIStatus.h"
#import "SDLProtocol.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"
#import "SDLStateMachine.h"
#import "SDLV2ProtocolHeader.h"
#import "SDLV2ProtocolMessage.h"
#import "SDLVehicleType.h"
#import "TestConnectionManager.h"

@interface SDLEncryptionLifecycleManager()
@property (strong, nonatomic, readwrite) SDLStateMachine *encryptionStateMachine;
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *securityManagers;
@end

QuickSpecBegin(SDLEncryptionLifecycleManagerSpec)

describe(@"the encryption lifecycle manager", ^{
    __block SDLEncryptionLifecycleManager *encryptionLifecycleManager = nil;
    __block SDLConfiguration *testConfiguration = nil;
    __block TestConnectionManager *testConnectionManager = nil;
    __block SDLFakeSecurityManager *testFakeSecurityManager = nil;
    __block NSOperationQueue *testRPCOperationQueue = nil;

    beforeEach(^{
        testConnectionManager = [[TestConnectionManager alloc] init];
        testFakeSecurityManager = [[SDLFakeSecurityManager alloc] init];

        SDLEncryptionConfiguration *encryptionConfig = [[SDLEncryptionConfiguration alloc] initWithSecurityManagers:@[testFakeSecurityManager.class] delegate:nil];
        SDLLifecycleConfiguration *lifecycleConfig = [SDLLifecycleConfiguration defaultConfigurationWithAppName:@"Test" fullAppId:@"1234"];
        testConfiguration = [[SDLConfiguration alloc] initWithLifecycle:lifecycleConfig lockScreen:nil logging:nil fileManager:nil encryption:encryptionConfig];
        testRPCOperationQueue = OCMClassMock([NSOperationQueue class]);
        
        encryptionLifecycleManager = [[SDLEncryptionLifecycleManager alloc] initWithConnectionManager:testConnectionManager configuration:testConfiguration];
    });
    
    it(@"should initialize properties", ^{
        expect(encryptionLifecycleManager.isEncryptionReady).to(beFalse());
        expect(encryptionLifecycleManager.securityManagers).toNot(beEmpty());
    });
    
    describe(@"when started", ^{
        __block BOOL readyHandlerSuccess = NO;
        __block NSError *readyHandlerError = nil;
        
        __block SDLProtocol *protocolMock = OCMClassMock([SDLProtocol class]);
        
        beforeEach(^{
            readyHandlerSuccess = NO;
            readyHandlerError = nil;
            
            [encryptionLifecycleManager startWithProtocol:protocolMock];
        });
        
        it(@"should not be ready to encrypt", ^{
            expect(encryptionLifecycleManager.isEncryptionReady).to(beFalse());
        });
        
        describe(@"after receiving an RPC Start ACK", ^{
            __block SDLProtocolHeader *testRPCHeader = nil;
            __block SDLProtocolMessage *testRPCMessage = nil;
            
            beforeEach(^{
                [encryptionLifecycleManager.encryptionStateMachine setToState:SDLEncryptionLifecycleManagerStateStarting fromOldState:nil callEnterTransition:YES];
                
                testRPCHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testRPCHeader.frameType = SDLFrameTypeSingle;
                testRPCHeader.frameData = SDLFrameInfoStartServiceACK;
                testRPCHeader.encrypted = YES;
                testRPCHeader.serviceType = SDLServiceTypeRPC;
                
                testRPCMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testRPCHeader andPayload:nil];
                [encryptionLifecycleManager protocol:protocolMock didReceiveStartServiceACK:testRPCMessage];
            });
            
            it(@"should have set all the right properties", ^{
                expect(encryptionLifecycleManager.isEncryptionReady).to(equal(YES));
                expect(encryptionLifecycleManager.encryptionStateMachine.currentState).to(equal(SDLEncryptionLifecycleManagerStateReady));
            });
        });
        
        describe(@"after receiving an RPC Start NAK", ^{
            __block SDLProtocolHeader *testRPCHeader = nil;
            __block SDLProtocolMessage *testRPCMessage = nil;
            
            beforeEach(^{
                [encryptionLifecycleManager.encryptionStateMachine setToState:SDLEncryptionLifecycleManagerStateStarting fromOldState:nil callEnterTransition:NO];
                
                testRPCHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testRPCHeader.frameType = SDLFrameTypeSingle;
                testRPCHeader.frameData = SDLFrameInfoStartServiceNACK;
                testRPCHeader.encrypted = NO;
                testRPCHeader.serviceType = SDLServiceTypeRPC;
                
                testRPCMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testRPCHeader andPayload:nil];
                [encryptionLifecycleManager protocol:protocolMock didReceiveEndServiceACK:testRPCMessage];
            });
            
            it(@"should have set all the right properties", ^{
                expect(encryptionLifecycleManager.encryptionStateMachine.currentState).to(equal(SDLEncryptionLifecycleManagerStateStopped));
            });
        });
        
        describe(@"after receiving a RPC end ACK", ^{
            __block SDLProtocolHeader *testRPCHeader = nil;
            __block SDLProtocolMessage *testRPCMessage = nil;
            
            beforeEach(^{
                [encryptionLifecycleManager.encryptionStateMachine setToState:SDLEncryptionLifecycleManagerStateStopped fromOldState:nil callEnterTransition:NO];
                
                testRPCHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testRPCHeader.frameType = SDLFrameTypeSingle;
                testRPCHeader.frameData = SDLFrameInfoEndServiceACK;
                testRPCHeader.encrypted = NO;
                testRPCHeader.serviceType = SDLServiceTypeRPC;
                
                testRPCMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testRPCHeader andPayload:nil];
                [encryptionLifecycleManager protocol:protocolMock didReceiveEndServiceACK:testRPCMessage];
            });
            
            it(@"should have set all the right properties", ^{
                expect(encryptionLifecycleManager.encryptionStateMachine.currentState).to(equal(SDLEncryptionLifecycleManagerStateStopped));
            });
        });
        
        describe(@"after receiving a RPC end NAK", ^{
            __block SDLProtocolHeader *testRPCHeader = nil;
            __block SDLProtocolMessage *testRPCMessage = nil;
            
            beforeEach(^{
                [encryptionLifecycleManager.encryptionStateMachine setToState:SDLEncryptionLifecycleManagerStateStopped fromOldState:nil callEnterTransition:NO];
                
                testRPCHeader = [[SDLV2ProtocolHeader alloc] initWithVersion:5];
                testRPCHeader.frameType = SDLFrameTypeSingle;
                testRPCHeader.frameData = SDLFrameInfoEndServiceNACK;
                testRPCHeader.encrypted = NO;
                testRPCHeader.serviceType = SDLServiceTypeRPC;
                
                testRPCMessage = [[SDLV2ProtocolMessage alloc] initWithHeader:testRPCHeader andPayload:nil];
                [encryptionLifecycleManager protocol:protocolMock didReceiveEndServiceNAK:testRPCMessage];
            });
            
            it(@"should have set all the right properties", ^{
                expect(encryptionLifecycleManager.encryptionStateMachine.currentState).to(equal(SDLEncryptionLifecycleManagerStateStopped));
            });
        });

        describe(@"when a register app interface response is received", ^{
            beforeEach(^{
                OCMExpect([protocolMock setSecurityManager:[OCMArg any]]);

                SDLRegisterAppInterfaceResponse *rair = [[SDLRegisterAppInterfaceResponse alloc] init];
                rair.vehicleType = [[SDLVehicleType alloc] init];
                rair.vehicleType.make = @"SDL";
                SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:nil rpcResponse:rair];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });

            it(@"should set the protocol's security manager", ^{
                OCMVerifyAll((id)protocolMock);
            });
        });
    });

    describe(@"when stopped", ^{
        it(@"if the encryption manager is ready it should transition to the stopped state", ^{
            [encryptionLifecycleManager.encryptionStateMachine setToState:SDLEncryptionLifecycleManagerStateReady  fromOldState:nil callEnterTransition:NO];

            [encryptionLifecycleManager stop];

            expect(encryptionLifecycleManager.encryptionStateMachine.currentState).to(equal(SDLEncryptionLifecycleManagerStateStopped));
        });

        it(@"if the encryption manager is starting it should stay in the stopped state", ^{
            [encryptionLifecycleManager.encryptionStateMachine setToState:SDLEncryptionLifecycleManagerStateStarting fromOldState:nil callEnterTransition:NO];

            [encryptionLifecycleManager stop];

            expect(encryptionLifecycleManager.encryptionStateMachine.currentState).to(equal(SDLEncryptionLifecycleManagerStateStopped));
        });

        it(@"if the encryption manager is stopped it should stay in the stopped state", ^{
            [encryptionLifecycleManager.encryptionStateMachine setToState:SDLEncryptionLifecycleManagerStateStopped  fromOldState:nil callEnterTransition:NO];

            [encryptionLifecycleManager stop];

            expect(encryptionLifecycleManager.encryptionStateMachine.currentState).to(equal(SDLEncryptionLifecycleManagerStateStopped));
        });
    });
});

QuickSpecEnd
