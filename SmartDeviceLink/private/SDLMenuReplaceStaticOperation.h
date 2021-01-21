//
//  SDLMenuReplaceStaticOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/20/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"
#import "SDLConnectionManagerType.h"
#import "SDLFileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuReplaceStaticOperation : SDLAsynchronousOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager;

@end

NS_ASSUME_NONNULL_END
