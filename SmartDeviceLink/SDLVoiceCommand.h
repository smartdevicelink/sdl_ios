//
//  SDLVoiceCommand.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
The handler that will be called when the command is activated
*/
typedef void(^SDLVoiceCommandSelectionHandler)(void);

/// Voice commands available for the user to speak and be recognized by the IVI's voice recognition engine.
@interface SDLVoiceCommand : NSObject

/**
 The strings the user can say to activate this voice command
 */
@property (copy, nonatomic, readonly) NSArray<NSString *> *voiceCommands;

/**
 The handler that will be called when the command is activated
 */
@property (copy, nonatomic, readonly, nullable) SDLVoiceCommandSelectionHandler handler;

/// Convenience init
///
/// @param voiceCommands The strings the user can say to activate this voice command
/// @param handler The handler that will be called when the command is activated
/// @return An SDLVoiceCommand object
- (instancetype)initWithVoiceCommands:(NSArray<NSString *> *)voiceCommands handler:(SDLVoiceCommandSelectionHandler)handler;

@end

NS_ASSUME_NONNULL_END
