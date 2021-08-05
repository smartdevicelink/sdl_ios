//
//  SDLMenuConfigurationUpdateOperation.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/21/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLMenuConfigurationUpdateOperation.h"

#import "SDLError.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLSetGlobalProperties.h"
#import "SDLVersion.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuConfigurationUpdateOperation ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic) NSArray<SDLMenuLayout> *availableMenuLayouts;
@property (strong, nonatomic) SDLMenuConfiguration *updatedMenuConfiguration;
@property (assign, nonatomic) SDLMenuConfigurationUpdatedBlock menuConfigurationUpdatedBlock;

@property (copy, nonatomic, nullable) NSError *internalError;

@end

@implementation SDLMenuConfigurationUpdateOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager windowCapability:(SDLWindowCapability *)windowCapability newMenuConfiguration:(SDLMenuConfiguration *)newConfiguration configurationUpdatedHandler:(SDLMenuConfigurationUpdatedBlock)configurationUpdatedBlock {
    self = [super init];
    if (!self) { return nil; }

    _connectionManager = connectionManager;
    _availableMenuLayouts = windowCapability.menuLayoutsAvailable;
    _updatedMenuConfiguration = newConfiguration;
    _menuConfigurationUpdatedBlock = configurationUpdatedBlock;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    if (self.availableMenuLayouts.count == 0) {
        SDLLogW(@"Could not set the main menu configuration. Which menu layouts can be used is not available");
        self.internalError = [NSError sdl_menuManager_configurationOperationLayoutsNotSupported];
        return [self finishOperation];
    } else if (![self.availableMenuLayouts containsObject:self.updatedMenuConfiguration.mainMenuLayout]
               || ![self.availableMenuLayouts containsObject:self.updatedMenuConfiguration.defaultSubmenuLayout]) {
        SDLLogE(@"One or more of the set menu layouts are not available on this system. The menu configuration will not be set. Available menu layouts: %@, set menu layouts: %@", self.availableMenuLayouts, self.updatedMenuConfiguration);
        self.internalError = [NSError sdl_menuManager_configurationOperationLayoutsNotSupported];
        return [self finishOperation];
    }

    __weak typeof(self) weakself = self;
    SDLSetGlobalProperties *setGlobalsRPC = [[SDLSetGlobalProperties alloc] init];
    setGlobalsRPC.menuLayout = self.updatedMenuConfiguration.mainMenuLayout;
    [self.connectionManager sendConnectionRequest:setGlobalsRPC withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(weakself) strongself = weakself;
        if (error != nil) {
            strongself.internalError = [NSError sdl_menuManager_configurationOperationFailed:strongself.updatedMenuConfiguration];
        }

        [strongself finishOperation];
    }];
}

#pragma mark - Operation Overrides

- (void)finishOperation {
    SDLLogV(@"Finishing menu manager configuration update operation");
    if (self.internalError != nil) {
        self.menuConfigurationUpdatedBlock(nil, self.internalError);
    } else {
        self.menuConfigurationUpdatedBlock(self.updatedMenuConfiguration, nil);
    }

    [super finishOperation];
}

- (nullable NSString *)name {
    return @"com.sdl.menuManager.configurationUpdate";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

- (nullable NSError *)error {
    return self.internalError;
}

@end

NS_ASSUME_NONNULL_END
