//
//  SDLMenuShowOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/21/21.
//  Copyright © 2021 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"
#import "SDLConnectionManagerType.h"

@class SDLMenuCell;

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuShowOperation : SDLAsynchronousOperation
typedef void(^SDLMenuShowCompletionBlock)(NSError *_Nullable error);

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager toMenuCell:(nullable SDLMenuCell *)menuCell completionHandler:(SDLMenuShowCompletionBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END
