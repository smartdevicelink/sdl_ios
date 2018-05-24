//
//  SDLCheckChoiceVROptionalOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/24/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousOperation.h"

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLChoiceSetManagerCheckVRCompletionHandler)(BOOL isVROptional, NSError *__nullable error);

@interface SDLCheckChoiceVROptionalOperation : SDLAsynchronousOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(SDLChoiceSetManagerCheckVRCompletionHandler)completionManager;

@end

NS_ASSUME_NONNULL_END
