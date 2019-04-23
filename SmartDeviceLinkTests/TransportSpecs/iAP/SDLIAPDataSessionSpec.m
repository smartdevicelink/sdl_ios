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

QuickSpecBegin(SDLIAPDataSessionSpec)

describe(@"SDLIAPDataSession", ^{
    __block SDLIAPDataSession *dataSession = nil;
    __block BOOL retryHandlerCalled = nil;
    __block BOOL createDataSessionHandlerCalled = nil;
    
    beforeEach(^{

    });
});

QuickSpecEnd


