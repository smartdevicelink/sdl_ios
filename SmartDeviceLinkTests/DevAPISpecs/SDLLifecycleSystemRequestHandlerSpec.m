//
//  SDLLifecycleSystemRequestHandlerSpec.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 6/24/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLifecycleSystemRequestHandler.h"

#import "TestConnectionManager.h"

QuickSpecBegin(SDLLifecycleSystemRequestHandlerSpec)

describe(@"SDLLifecycleSystemRequestHandler tests", ^{
    __block TestConnectionManager *mockConnectionManager = nil;
    __block SDLLifecycleSystemRequestHandler *testManager = nil;

    beforeEach(^{
        mockConnectionManager = [[TestConnectionManager alloc] init];
        testManager = [[SDLLifecycleSystemRequestHandler alloc] initWithConnectionManager:mockConnectionManager];
    });
});

QuickSpecEnd
