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
#import "SDLWindowCapability.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuConfigurationUpdateOperation : SDLAsynchronousOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager windowCapability:(SDLWindowCapability *)windowCapability newMenuConfiguration:(SDLMenuConfiguration *)newConfiguration;

@end

NS_ASSUME_NONNULL_END
