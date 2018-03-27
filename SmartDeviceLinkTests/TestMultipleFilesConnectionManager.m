//
//  TestMultipleFilesConnectionManager.m
//  SmartDeviceLink-iOS
//
//  Created by Nicole on 8/16/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "TestMultipleFilesConnectionManager.h"
#import "SDLDeleteFile.h"
#import "SDLRPCRequest.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLNames.h"
#import "TestResponse.h"

NS_ASSUME_NONNULL_BEGIN

@implementation TestMultipleFilesConnectionManager

- (void)sendConnectionRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    [super sendConnectionRequest:request withResponseHandler:handler];

    if ([[request name] isEqualToString:SDLNamePutFile]) {
        SDLPutFile *putfileRequest = (SDLPutFile *)request;
        TestResponse *response = self.responses[putfileRequest.syncFileName];

        if (response == nil || handler == nil) { return; }
        handler(request, response.testResponse, response.testError);
    } else if ([[request name] isEqualToString:SDLNameDeleteFile]) {
        SDLDeleteFile *deleteFileRequest = (SDLDeleteFile *)request;
        TestResponse *response = self.responses[deleteFileRequest.syncFileName];

        if (response == nil || handler == nil) { return; }
        handler(request, response.testResponse, response.testError);
    }
}

@end

NS_ASSUME_NONNULL_END
