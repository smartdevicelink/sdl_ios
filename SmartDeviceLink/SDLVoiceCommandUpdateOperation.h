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

/// A handler run when the operation completes, containing the new voice commands that are available on the head unit
///
/// @param newCurrentVoiceCommands The voice commands currently present on the head unit
/// @param error The error if one occurred
typedef void(^SDLVoiceCommandUpdateCompletionHandler)(NSArray<SDLVoiceCommand *> *newCurrentVoiceCommands, NSError *__nullable error);

/// An operation that handles changing voice commands on the head unit
@interface SDLVoiceCommandUpdateOperation : SDLAsynchronousOperation

/// The voice commands currently on the head unit
@property (strong, nonatomic, nullable) NSArray<SDLVoiceCommand *> *oldVoiceCommands;

/// Initialize a voice command update operation
/// @param connectionManager The connection manager for sending RPCs
/// @param pendingVoiceCommands The voice commands that should be on the head unit when this operation completes
/// @param oldVoiceCommands The voice commands currently on the head unit
/// @param completionHandler A handler called right before the update operation finishes
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager pendingVoiceCommands:(NSArray<SDLVoiceCommand *> *)pendingVoiceCommands oldVoiceCommands:(NSArray<SDLVoiceCommand *> *)oldVoiceCommands updateCompletionHandler:(SDLVoiceCommandUpdateCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
