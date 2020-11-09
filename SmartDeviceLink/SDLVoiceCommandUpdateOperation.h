//
//  SDLVoiceCommandUpdateOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 11/6/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLAsynchronousOperation.h"

@class SDLVoiceCommand;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLVoiceCommandUpdateCompletionHandler)(NSArray<SDLVoiceCommand *> *newCurrentVoiceCommands, NSError *__nullable error);

@interface SDLVoiceCommandUpdateOperation : SDLAsynchronousOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager newVoiceCommands:(nullable NSArray<SDLVoiceCommand *> *)newVoiceCommands oldVoiceCommands:(nullable NSArray<SDLVoiceCommand *> *)oldVoiceCommands updateCompletionHandler:(SDLVoiceCommandUpdateCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
