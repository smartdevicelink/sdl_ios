//
//  SDLIAPDataSessionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 4/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLIAPDataSession.h"

#import "EAAccessory+OCMock.m"
#import "SDLIAPConstants.h"
#import "SDLIAPSession.h"
#import "SDLIAPDataSessionDelegate.h"
#import "SDLMutableDataQueue.h"


@interface SDLIAPDataSession()

@property (weak, nonatomic) id<SDLIAPDataSessionDelegate> delegate;
@property (nonatomic, strong) SDLMutableDataQueue *sendDataQueue;

@end

QuickSpecBegin(SDLIAPDataSessionSpec)

describe(@"SDLIAPDataSession", ^{
    __block SDLIAPDataSession *dataSession = nil;
    __block EAAccessory *mockAccessory = nil;
    __block id<SDLIAPDataSessionDelegate> mockDelegate = nil;

    beforeEach(^{
        mockDelegate = OCMProtocolMock(@protocol(SDLIAPDataSessionDelegate));
        mockAccessory = [EAAccessory.class sdlCoreMock];
    });

    describe(@"init", ^{
        beforeEach(^{
            dataSession = [[SDLIAPDataSession alloc] initWithAccessory:mockAccessory delegate:mockDelegate forProtocol:MultiSessionProtocolString];
        });
    });

});

QuickSpecEnd



