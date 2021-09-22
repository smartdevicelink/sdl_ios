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


@interface SDLCheckChoiceVROptionalOperation : SDLAsynchronousOperation

typedef void(^SDLCheckChoiceVROptionalCompletionHandler)(BOOL isVROptional, NSError *_Nullable error);

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(SDLCheckChoiceVROptionalCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
