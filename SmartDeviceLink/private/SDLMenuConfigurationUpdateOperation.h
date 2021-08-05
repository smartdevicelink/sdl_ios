//
//  SDLMenuConfigurationUpdateOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/21/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLMenuConfiguration.h"
#import "SDLMenuReplaceUtilities.h"
#import "SDLWindowCapability.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLMenuConfigurationUpdatedBlock)(SDLMenuConfiguration *_Nullable newMenuConfiguration, NSError *_Nullable error);

@interface SDLMenuConfigurationUpdateOperation : SDLAsynchronousOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager windowCapability:(SDLWindowCapability *)windowCapability newMenuConfiguration:(SDLMenuConfiguration *)newConfiguration configurationUpdatedHandler:(SDLMenuConfigurationUpdatedBlock)configurationUpdatedBlock;

@end

NS_ASSUME_NONNULL_END
