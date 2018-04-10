//
//  SDLVoiceCommand.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDLVoiceCommandSelectionHandler)(void);

@interface SDLVoiceCommand : NSObject

@property (copy, nonatomic, readonly) NSArray<NSString *> *voiceCommands;
@property (copy, nonatomic, readonly, nullable) SDLVoiceCommandSelectionHandler handler;

- (instancetype)initWithVoiceCommands:(NSArray<NSString *> *)voiceCommands handler:(SDLVoiceCommandSelectionHandler)handler;

@end

NS_ASSUME_NONNULL_END
