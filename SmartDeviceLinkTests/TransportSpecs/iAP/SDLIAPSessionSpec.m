//
//  SDLIAPSessionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import <ExternalAccessory/ExternalAccessory.h>
#import "EAAccessory+OCMock.m"
#import "SDLIAPSession.h"
#import "SDLMutableDataQueue.h"
#import "SDLStreamDelegate.h"

@interface SDLIAPSession ()
@property (nonatomic, assign) BOOL isInputStreamOpen;
@property (nonatomic, assign) BOOL isOutputStreamOpen;
@property (nonatomic, assign) BOOL isDataSession;
@property (nullable, nonatomic, strong) NSThread *ioStreamThread;
@property (nonatomic, strong) SDLMutableDataQueue *sendDataQueue;
@property (nonatomic, strong) dispatch_semaphore_t canceledSemaphore;

- (BOOL)sdl_startWithSession:(EASession *)session;
@end

QuickSpecBegin(SDLIAPSessionSpec)

describe(@"SDLIAPSession", ^{
    __block SDLIAPSession *iapSession = nil;
    __block EAAccessory *mockAccessory = nil;
    __block NSString *protocol = nil;

    describe(@"Initialization", ^{
        beforeEach(^{
            mockAccessory = [OCMockObject mockForClass:[EAAccessory class]];
        });

        it(@"Should init correctly with a control protocol string", ^{
            protocol = @"com.smartdevicelink.prot0";
            iapSession = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:protocol];

            expect(iapSession.isDataSession).to(beFalse());
        });

        it(@"Should init correctly with a multisession protocol string", ^{
            protocol = @"com.smartdevicelink.multisession";
            iapSession = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:protocol];

            expect(iapSession.isDataSession).to(beTrue());
        });

        it(@"Should init correctly with a legacy protocol string", ^{
            protocol = @"com.ford.sync.prot0";
            iapSession = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:protocol];

            expect(iapSession.isDataSession).to(beTrue());
        });

        it(@"Should init correctly with a indexed protocol string", ^{
            protocol = @"com.smartdevicelink.prot1";
            iapSession = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:protocol];

            expect(iapSession.isDataSession).to(beTrue());
        });

        afterEach(^{
            expect(iapSession).toNot(beNil());
            expect(iapSession.protocol).to(match(protocol));
            expect(iapSession.accessory).to(equal(mockAccessory));
            expect(iapSession.canceledSemaphore).toNot(beNil());
            expect(iapSession.sendDataQueue).toNot(beNil());
            expect(iapSession.isInputStreamOpen).to(beFalse());
            expect(iapSession.isOutputStreamOpen).to(beFalse());
        });
    });

    describe(@"Starting a session", ^{
        __block SDLStreamDelegate *streamDelegate = nil;
        __block NSInputStream *inputStream = nil;
        __block NSOutputStream *outputStream = nil;

        describe(@"unsuccessfully", ^{
            beforeEach(^{
                protocol = @"com.smartdevicelink.multisession";
                mockAccessory = [EAAccessory.class sdlCoreMock];
                iapSession = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:protocol];
                streamDelegate = [[SDLStreamDelegate alloc] init];
                iapSession.streamDelegate = streamDelegate;
            });

            it(@"the start method should return false if a session cannot be created", ^{
                BOOL success = [iapSession sdl_startWithSession:nil];
                expect(success).to(beFalse());
                expect(iapSession.isInputStreamOpen).to(beFalse());
                expect(iapSession.isOutputStreamOpen).to(beFalse());
            });
        });

        describe(@"starting a session successfully", ^{
            xcontext(@"control session", ^{
                beforeEach(^{
                    protocol = @"com.smartdevicelink.prot0";
                    mockAccessory = [EAAccessory.class sdlCoreMock];
                    iapSession = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:protocol];
                    streamDelegate = [[SDLStreamDelegate alloc] init];
                    iapSession.streamDelegate = streamDelegate;

                    expect(iapSession.isDataSession).to(beFalse());
                });

                it(@"the start method should return true if a session can be created", ^{
                    inputStream = OCMClassMock([NSInputStream class]);
                    outputStream = OCMClassMock([NSOutputStream class]);
                    EASession *mockSession = [EASession.class mockSessionWithAccessory:mockAccessory protocolString:protocol inputStream:inputStream outputStream:outputStream];
                    iapSession.easession = mockSession;

                    BOOL success = [iapSession sdl_startWithSession:mockSession];
                    expect(success).to(beTrue());
                    expect(iapSession.ioStreamThread).to(beNil());
                    expect(iapSession.easession.inputStream).toNot(beNil());
                    expect(iapSession.easession.outputStream).toNot(beNil());
                });
            });

            xcontext(@"data session", ^{
                beforeEach(^{
                    protocol = @"com.smartdevicelink.multisession";
                    mockAccessory = [EAAccessory.class sdlCoreMock];
                    iapSession = [[SDLIAPSession alloc] initWithAccessory:mockAccessory forProtocol:protocol];
                    streamDelegate = [[SDLStreamDelegate alloc] init];
                    iapSession.streamDelegate = streamDelegate;

                    expect(iapSession.isDataSession).to(beTrue());
                });

                it(@"the start method should return true if a session can be created", ^{
                    EASession *mockSession = [EASession.class mockSessionWithAccessory:mockAccessory protocolString:protocol inputStream:nil outputStream:nil];
                    iapSession.easession = mockSession;
                    BOOL success = [iapSession sdl_startWithSession:mockSession];
                    expect(success).to(beTrue());
                    expect(iapSession.ioStreamThread).toNot(beNil());
                });
            });

            afterEach(^{
                [iapSession stop];
                expect(iapSession.easession).to(beNil());
                expect(iapSession.ioStreamThread).to(beNil());
            });
        });
    });
});

QuickSpecEnd
