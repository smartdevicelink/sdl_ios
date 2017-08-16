//
//  TestMultipleFilesConnectionManager.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TestMultipleFilesConnectionManager.h"
#import "SDLRPCRequest.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TestMultipleFilesConnectionManager

static int theCount = 0;

- (void)sendManagerRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    [super sendManagerRequest:request withResponseHandler:handler];

    // Send a response if the request is a putfile
    if ([[request name] isEqualToString:SDLNamePutFile]) {
        if (self.response == nil || handler == nil) { return; }
        theCount += 1;
        // NSLog(@"sent response #%d: %@", theCount, request);
        handler(request, self.response, nil);
    }
}

@end

NS_ASSUME_NONNULL_END
