//
//  SDLStreamingMediaLifecycleManagerSpec.m
//  SmartDeviceLink-iOS
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLDisplayCapabilities.h"
#import "SDLImageResolution.h"
#import "SDLNotificationConstants.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLRPCResponseNotification.h"
#import "SDLScreenParams.h"
#import "SDLStateMachine.h"
#import "SDLStreamingMediaLifecycleManager.h"
#import "SDLProtocol.h"
#import "SDLOnHMIStatus.h"
#import "SDLHMILevel.h"

QuickSpecBegin(SDLStreamingMediaLifecycleManagerSpec)

describe(@"the streaming media manager", ^{
    __block SDLStreamingMediaLifecycleManager *streamingLifecycleManager = nil;
    __block SDLStreamingEncryptionFlag streamingEncryptionFlag = SDLStreamingEncryptionFlagAuthenticateOnly;
    __block NSDictionary<NSString *, id> *someVideoEncoderSettings = nil;
    
    beforeEach(^{
        someVideoEncoderSettings = @{
                                     (__bridge NSString *)kVTCompressionPropertyKey_ExpectedFrameRate : @1
                                     };
        streamingLifecycleManager = [[SDLStreamingMediaLifecycleManager alloc] initWithEncryption:streamingEncryptionFlag videoEncoderSettings:someVideoEncoderSettings];
    });
    
    it(@"should initialize properties", ^{
        expect(streamingLifecycleManager.touchManager).toNot(beNil());
        expect(@(streamingLifecycleManager.isVideoStreamingSupported)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isAudioStreamingSupported)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isVideoConnected)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isAudioConnected)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isVideoEncrypted)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isAudioEncrypted)).to(equal(@NO));
        expect(@(streamingLifecycleManager.isVideoStreamingPaused)).to(equal(@YES));
        expect(@(CGSizeEqualToSize(streamingLifecycleManager.screenSize, CGSizeZero))).to(equal(@YES));
        expect(@(streamingLifecycleManager.pixelBufferPool == NULL)).to(equal(@YES));
        expect(@(streamingLifecycleManager.requestedEncryptionType)).to(equal(@(streamingEncryptionFlag)));
        expect(streamingLifecycleManager.currentAppState).to(equal(SDLAppStateActive));
        expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStopped));
        expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStopped));
    });
    
    describe(@"when started", ^{
        __block BOOL readyHandlerSuccess = NO;
        __block NSError *readyHandlerError = nil;
        
        __block id protocolMock = OCMClassMock([SDLAbstractProtocol class]);
        
        beforeEach(^{
            readyHandlerSuccess = NO;
            readyHandlerError = nil;
            
            [streamingLifecycleManager startWithProtocol:protocolMock completionHandler:^(BOOL success, NSError * _Nullable error) {
                readyHandlerSuccess = success;
                readyHandlerError = error;
            }];
        });
        
        
        it(@"should be ready to stream", ^{
            expect(@(streamingLifecycleManager.isVideoStreamingSupported)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isAudioStreamingSupported)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isVideoConnected)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isAudioConnected)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isVideoEncrypted)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isAudioEncrypted)).to(equal(@NO));
            expect(@(streamingLifecycleManager.isVideoStreamingPaused)).to(equal(@YES));
            expect(@(CGSizeEqualToSize(streamingLifecycleManager.screenSize, CGSizeZero))).to(equal(@YES));
            expect(@(streamingLifecycleManager.pixelBufferPool == NULL)).to(equal(@YES));
            expect(streamingLifecycleManager.currentAppState).to(equal(SDLAppStateActive));
            expect(streamingLifecycleManager.currentAudioStreamState).to(match(SDLAudioStreamStateStopped));
            expect(streamingLifecycleManager.currentVideoStreamState).to(match(SDLVideoStreamStateStopped));
            
        });
        
        describe(@"after receiving a register app interface notification", ^{
            __block SDLRegisterAppInterfaceResponse *someRegisterAppInterfaceResponse = nil;
            __block SDLDisplayCapabilities *someDisplayCapabilities = nil;
            __block SDLScreenParams *someScreenParams = nil;
            __block SDLImageResolution *someImageResolution = nil;
            
            beforeEach(^{
                someImageResolution = [[SDLImageResolution alloc] init];
                someImageResolution.resolutionWidth = @(600);
                someImageResolution.resolutionHeight = @(100);
                
                someScreenParams = [[SDLScreenParams alloc] init];
                someScreenParams.resolution = someImageResolution;
            });
            
            describe(@"that does not support graphics", ^{
                beforeEach(^{
                    someDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
                    someDisplayCapabilities.graphicSupported = @NO;
                    
                    someDisplayCapabilities.screenParams = someScreenParams;
                    
                    someRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    someRegisterAppInterfaceResponse.displayCapabilities = someDisplayCapabilities;
                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];
                    
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    [NSThread sleepForTimeInterval:0.1];
                });
                
                it(@"should not support streaming", ^{
                    expect(@(streamingLifecycleManager.isVideoStreamingSupported)).to(equal(@NO));
                    expect(@(streamingLifecycleManager.isAudioStreamingSupported)).to(equal(@NO));
                });
            });
            
            describe(@"that supports graphics", ^{
                beforeEach(^{
                    someDisplayCapabilities = [[SDLDisplayCapabilities alloc] init];
                    someDisplayCapabilities.graphicSupported = @YES;
                    
                    someDisplayCapabilities.screenParams = someScreenParams;
                    
                    someRegisterAppInterfaceResponse = [[SDLRegisterAppInterfaceResponse alloc] init];
                    someRegisterAppInterfaceResponse.displayCapabilities = someDisplayCapabilities;
                    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:SDLDidReceiveRegisterAppInterfaceResponse object:self rpcResponse:someRegisterAppInterfaceResponse];
                    
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    [NSThread sleepForTimeInterval:0.1];
                });
                
                it(@"should support streaming", ^{
                    expect(@(streamingLifecycleManager.isVideoStreamingSupported)).to(equal(@YES));
                    expect(@(streamingLifecycleManager.isAudioStreamingSupported)).to(equal(@YES));
                    expect(@(CGSizeEqualToSize(streamingLifecycleManager.screenSize, CGSizeMake(600, 100)))).to(equal(@YES));
                });
            });
        });
        
        describe(@"after receiving an hmi status", ^{
            __block id streamStub = nil;
            __block SDLOnHMIStatus *someHMIStatus = nil;
            __block SDLHMILevel someHMILevel = nil;
            
            beforeEach(^{
                streamStub = OCMPartialMock(streamingLifecycleManager);
                
                OCMStub([streamStub isAudioStreamingSupported]).andReturn(YES);
                OCMStub([streamStub isVideoStreamingSupported]).andReturn(YES);
                
                someHMIStatus = [[SDLOnHMIStatus alloc] init];
            });
            
            context(@"of none", ^{
                beforeEach(^{
                    someHMILevel = SDLHMILevelNone;
                    
                    someHMIStatus.hmiLevel = someHMILevel;
                    
                    SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:self rpcNotification:someHMIStatus];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                    [NSThread sleepForTimeInterval:0.1];
                });
                
                it(@"should only start the audio stream", ^{
                    expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                    expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStopped));
                });
            });
            
            context(@"of background", ^{
                beforeEach(^{
                    someHMILevel = SDLHMILevelBackground;
                    
                    someHMIStatus.hmiLevel = someHMILevel;
                    
                    SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:self rpcNotification:someHMIStatus];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                    [NSThread sleepForTimeInterval:0.1];
                });
                
                it(@"should only start the audio stream", ^{
                    expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                    expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStopped));
                });
            });
            
            context(@"of limited", ^{
                beforeEach(^{
                    someHMILevel = SDLHMILevelLimited;
                    
                    someHMIStatus.hmiLevel = someHMILevel;
                    
                    SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:self rpcNotification:someHMIStatus];
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
                    
                    [NSThread sleepForTimeInterval:0.1];
                });
                
                it(@"should start both streams", ^{
                    expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                    expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStarting));
                });
            });
            
            context(@"of full", ^{
                describe(@"and the app state", ^{
                    context(@"is resigning active", ^{
                        beforeEach(^{
                            [streamingLifecycleManager.appStateMachine setToState:SDLAppStateIsResigningActive fromOldState:nil callEnterTransition:NO];
                            
                            someHMILevel = SDLHMILevelFull;
                            
                            someHMIStatus.hmiLevel = someHMILevel;
                            
                            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:self rpcNotification:someHMIStatus];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            
                            [NSThread sleepForTimeInterval:0.1];
                        });
                        
                        it(@"should only start the audio stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStopped));
                        });
                    });
                    
                    context(@"is background", ^{
                        beforeEach(^{
                            [streamingLifecycleManager.appStateMachine setToState:SDLAppStateBackground fromOldState:nil callEnterTransition:NO];
                            
                            someHMILevel = SDLHMILevelFull;
                            
                            someHMIStatus.hmiLevel = someHMILevel;
                            
                            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:self rpcNotification:someHMIStatus];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            
                            [NSThread sleepForTimeInterval:0.1];
                        });
                        
                        it(@"should only start the audio stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStopped));
                        });
                    });
                    
                    context(@"is regaining active", ^{
                        beforeEach(^{
                            [streamingLifecycleManager.appStateMachine setToState:SDLAppStateIsRegainingActive fromOldState:nil callEnterTransition:NO];
                            
                            someHMILevel = SDLHMILevelFull;
                            
                            someHMIStatus.hmiLevel = someHMILevel;
                            
                            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:self rpcNotification:someHMIStatus];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            
                            [NSThread sleepForTimeInterval:0.1];
                        });
                        
                        it(@"should only start the audio stream", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStopped));
                        });
                    });
                    
                    context(@"is active", ^{
                        beforeEach(^{
                            [streamingLifecycleManager.appStateMachine setToState:SDLAppStateActive fromOldState:nil callEnterTransition:NO];
                            
                            someHMILevel = SDLHMILevelFull;
                            
                            someHMIStatus.hmiLevel = someHMILevel;
                            
                            SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:SDLDidChangeHMIStatusNotification object:self rpcNotification:someHMIStatus];
                            [[NSNotificationCenter defaultCenter] postNotification:notification];
                            
                            [NSThread sleepForTimeInterval:0.1];
                        });
                        
                        it(@"should start both streams", ^{
                            expect(streamingLifecycleManager.currentAudioStreamState).to(equal(SDLAudioStreamStateStarting));
                            expect(streamingLifecycleManager.currentVideoStreamState).to(equal(SDLVideoStreamStateStarting));
                        });
                    });
                });
            });
        });
    });
});

QuickSpecEnd
