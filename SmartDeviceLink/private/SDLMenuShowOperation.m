//
//  SDLMenuShowOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/21/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLMenuShowOperation.h"

#import "SDLError.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLMenuCell.h"
#import "SDLRPCResponse.h"
#import "SDLResult.h"
#import "SDLShowAppMenu.h"
#import "SDLVersion.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuCell()

@property (assign, nonatomic) UInt32 parentCellId;
@property (assign, nonatomic) UInt32 cellId;

@end

@interface SDLMenuShowOperation ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic, nullable) SDLMenuCell *submenuCell;
@property (copy, nonatomic) SDLMenuShowCompletionBlock showCompletionHandler;

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLMenuShowOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager toMenuCell:(nullable SDLMenuCell *)menuCell completionHandler:(SDLMenuShowCompletionBlock)completionHandler {
    self = [super init];
    if (!self) {
        completionHandler([NSError sdl_failedToCreateObjectOfClass:[SDLMenuShowOperation class]]);
        return nil;
    }

    _connectionManager = connectionManager;
    _submenuCell = menuCell;
    _showCompletionHandler = completionHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    SDLShowAppMenu *openMenu = nil;
    if (self.submenuCell != nil) {
        openMenu = [[SDLShowAppMenu alloc] initWithMenuID:self.submenuCell.cellId];
    } else {
        openMenu = [[SDLShowAppMenu alloc] init];
    }

    __weak typeof(self) weakself = self;
    [self.connectionManager sendConnectionRequest:openMenu withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        if ([response.resultCode isEqualToEnum:SDLResultWarnings]) {
            SDLLogW(@"Warning opening application menu with error: %@", error);
        } else if (![response.resultCode isEqualToEnum:SDLResultSuccess]) {
            SDLLogE(@"Error opening application menu with error: %@", error);
            self.internalError = [NSError sdl_menuManager_openMenuOperationFailed:weakself.submenuCell];
        } else {
            SDLLogD(@"Successfully opened application menu");
        }

        [self finishOperation];
    }];
}

#pragma mark - Operation Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing menu manager configuration update operation");
    if (self.isCancelled) {
        self.internalError = [NSError sdl_menuManager_openMenuOperationCancelled];
    }

    self.showCompletionHandler(self.internalError);

    [super finishOperation];
}

- (nullable NSString *)name {
    return @"com.sdl.menuManager.openMenu";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
