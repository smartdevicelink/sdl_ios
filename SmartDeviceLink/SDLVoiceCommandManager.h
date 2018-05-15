//
//  SDLVoiceCommandManager.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/23/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLFileManager;
@class SDLVoiceCommand;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/**
 The handler run when the update has completed

 @param error An error if the update failed and an error occurred
 */
typedef void(^SDLMenuUpdateCompletionHandler)(NSError *__nullable error);

@interface SDLVoiceCommandManager : NSObject

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager;

/**
 *  Stops the manager. This method is used internally.
 */
- (void)stop;

@property (copy, nonatomic) NSArray<SDLVoiceCommand *> *voiceCommands;

@end

NS_ASSUME_NONNULL_END
