//
//  SDLLifecycleRPCAdapterSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 6/23/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGlobals.h"
#import "SDLLifecycleRPCAdapter.h"
#import "SDLOnButtonEvent.h"
#import "SDLOnButtonPress.h"
#import "SDLShow.h"
#import "SDLSubscribeButton.h"
#import "SDLUnsubscribeButton.h"
#import "SDLVersion.h"

QuickSpecBegin(SDLLifecycleRPCAdapterSpec)

describe(@"the lifecycle RPC adapter", ^{
    beforeEach(^{
        [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:1 minor:0 patch:0];
    });

    describe(@"adapt subscribe button request", ^{
        __block SDLSubscribeButton *testRPC = nil;
        beforeEach(^{
            testRPC = [[SDLSubscribeButton alloc] init];

            [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:1 minor:0 patch:0];
        });

        context(@"before RPC v5.0", ^{
            context(@"if the button name is PlayPause", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNamePlayPause;
                });

                it(@"should change it to an OK message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionOutgoing];

                    expect(result).to(haveCount(1));
                    expect(((SDLSubscribeButton *)result[0]).buttonName).to(equal(SDLButtonNameOk));
                });
            });

            context(@"if the button name is not PlayPause", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNameOk;
                });

                it(@"should not do anything to the message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionOutgoing];

                    expect(result).to(haveCount(1));
                });
            });
        });

        context(@"after or equal to RPC v5.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
            });

            context(@"if the button name is OK", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNameOk;
                });

                it(@"should create an additional PlayPause message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionOutgoing];

                    expect(result).to(haveCount(2));
                    expect(((SDLSubscribeButton *)result[1]).buttonName).to(equal(SDLButtonNamePlayPause));
                });
            });

            context(@"if the button name is not OK", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNamePlayPause;
                });

                it(@"should not do anything to the message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionOutgoing];

                    expect(result).to(haveCount(1));
                });
            });
        });
    });

    describe(@"adapt unsubscribe button request", ^{
        __block SDLUnsubscribeButton *testRPC = nil;
        beforeEach(^{
            testRPC = [[SDLUnsubscribeButton alloc] init];
        });

        context(@"before RPC v5.0", ^{
            context(@"if the button name is PlayPause", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNamePlayPause;
                });

                it(@"should change it to an OK message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionOutgoing];

                    expect(result).to(haveCount(1));
                    expect(((SDLUnsubscribeButton *)result[0]).buttonName).to(equal(SDLButtonNameOk));
                });
            });

            context(@"if the button name is not PlayPause", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNameOk;
                });

                it(@"should not do anything to the message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionOutgoing];

                    expect(result).to(haveCount(1));
                });
            });
        });

        context(@"after or equal to RPC v5.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
            });

            context(@"if the button name is OK", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNameOk;
                });

                it(@"should create an additional PlayPause message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionOutgoing];

                    expect(result).to(haveCount(2));
                    expect(((SDLUnsubscribeButton *)result[1]).buttonName).to(equal(SDLButtonNamePlayPause));
                });
            });

            context(@"if the button name is not OK", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNamePlayPause;
                });

                it(@"should not do anything to the message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionOutgoing];

                    expect(result).to(haveCount(1));
                });
            });
        });
    });

    describe(@"adapt onButtonPress notification", ^{
        __block SDLOnButtonPress *testRPC = nil;
        beforeEach(^{
            testRPC = [[SDLOnButtonPress alloc] init];
        });

        context(@"before RPC v5.0", ^{
            context(@"if the button name is PlayPause", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNamePlayPause;
                });

                it(@"should drop the message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionIncoming];

                    expect(result).to(beEmpty());
                });
            });

            context(@"if the button name is OK", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNameOk;
                });

                it(@"should create an additional play-pause message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionIncoming];

                    expect(result).to(haveCount(2));
                    expect(((SDLOnButtonPress *)result[1]).buttonName).to(equal(SDLButtonNamePlayPause));
                });
            });
        });

        context(@"after or equal to RPC v5.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
            });

            context(@"if the button name is OK", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNameOk;
                });

                it(@"should create an additional PlayPause message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionIncoming];

                    expect(result).to(haveCount(2));
                    expect(((SDLOnButtonPress *)result[1]).buttonName).to(equal(SDLButtonNamePlayPause));
                });
            });

            context(@"if the button name is PlayPause", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNamePlayPause;
                });

                it(@"should create an additional OK message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionIncoming];

                    expect(result).to(haveCount(2));
                    expect(((SDLOnButtonPress *)result[1]).buttonName).to(equal(SDLButtonNameOk));
                });
            });
        });
    });

    describe(@"adapt onButtonEvent notification", ^{
        __block SDLOnButtonEvent *testRPC = nil;
        beforeEach(^{
            testRPC = [[SDLOnButtonEvent alloc] init];
        });

        context(@"before RPC v5.0", ^{
            context(@"if the button name is PlayPause", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNamePlayPause;
                });

                it(@"should drop the message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionIncoming];

                    expect(result).to(beEmpty());
                });
            });

            context(@"if the button name is OK", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNameOk;
                });

                it(@"should create an additional play-pause message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionIncoming];

                    expect(result).to(haveCount(2));
                    expect(((SDLOnButtonEvent *)result[1]).buttonName).to(equal(SDLButtonNamePlayPause));
                });
            });
        });

        context(@"after or equal to RPC v5.0", ^{
            beforeEach(^{
                [SDLGlobals sharedGlobals].rpcVersion = [SDLVersion versionWithMajor:5 minor:0 patch:0];
            });

            context(@"if the button name is OK", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNameOk;
                });

                it(@"should create an additional PlayPause message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionIncoming];

                    expect(result).to(haveCount(2));
                    expect(((SDLOnButtonEvent *)result[1]).buttonName).to(equal(SDLButtonNamePlayPause));
                });
            });

            context(@"if the button name is PlayPause", ^{
                beforeEach(^{
                    testRPC.buttonName = SDLButtonNamePlayPause;
                });

                it(@"should create an additional OK message", ^{
                    NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionIncoming];

                    expect(result).to(haveCount(2));
                    expect(((SDLOnButtonEvent *)result[1]).buttonName).to(equal(SDLButtonNameOk));
                });
            });
        });
    });

    describe(@"an RPC that is not handled", ^{
        __block SDLShow *testRPC = nil;
        beforeEach(^{
            testRPC = [[SDLShow alloc] init];
        });

        it(@"should not do anything to the RPC", ^{
            NSArray<SDLRPCMessage *> *result = [SDLLifecycleRPCAdapter adaptRPC:testRPC direction:SDLRPCDirectionIncoming];

            expect(result).to(haveCount(1));
        });
    });
});

QuickSpecEnd
