//
//  SDLPreloadChoicesOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"

@class SDLChoiceCell;
@class SDLDisplayCapabilities;
@class SDLFileManager;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLChoiceSetManagerPreloadCompletionHandler)(NSError *__nullable error);

@interface SDLPreloadChoicesOperation : SDLAsynchronousOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager displayCapabilities:(SDLDisplayCapabilities *)displayCapabilities isVROptional:(BOOL)isVROptional cellsToPreload:(NSSet<SDLChoiceCell *> *)cells completionHandler:(nullable SDLChoiceSetManagerPreloadCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
