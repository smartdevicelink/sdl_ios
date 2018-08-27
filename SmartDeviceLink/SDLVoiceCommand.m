//
//  SDLVoiceCommand.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLVoiceCommand.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;

@end

@implementation SDLVoiceCommand

- (instancetype)initWithVoiceCommands:(NSArray<NSString *> *)voiceCommands handler:(SDLVoiceCommandSelectionHandler)handler {
    self = [super init];
    if (!self) { return nil; }

    _voiceCommands = voiceCommands;
    _handler = handler;

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SDLVoiceCommand: %u-\"%@\", voice commands: %lu", (unsigned int)_commandId, _voiceCommands.firstObject, (unsigned long)_voiceCommands.count];
}

@end

NS_ASSUME_NONNULL_END
