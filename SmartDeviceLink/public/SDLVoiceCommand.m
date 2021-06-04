//
//  SDLVoiceCommand.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 4/9/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLVoiceCommand.h"
#import "NSArray+Extensions.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLVoiceCommand()

@property (assign, nonatomic) UInt32 commandId;
@property (copy, nonatomic, readwrite) NSArray<NSString *> *voiceCommands;
@property (copy, nonatomic, readwrite, nullable) SDLVoiceCommandSelectionHandler handler;

@end

@implementation SDLVoiceCommand

- (instancetype)initWithVoiceCommands:(NSArray<NSString *> *)voiceCommands handler:(SDLVoiceCommandSelectionHandler)handler {
    self = [super init];
    if (!self) { return nil; }

    _voiceCommands = [self.class sdl_removeDuplicateStrings:voiceCommands];
    _handler = handler;

    return self;
}

+ (NSArray<NSString *> *)sdl_removeDuplicateStrings:(NSArray<NSString *> *)voiceCommands {
    return [[[NSSet alloc] initWithArray:voiceCommands] allObjects];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SDLVoiceCommand: %u-\"%@\", voice commands: %lu", (unsigned int)_commandId, _voiceCommands.firstObject, (unsigned long)_voiceCommands.count];
}

#pragma mark - Object Equality

- (NSUInteger)hash {
    return NSUIntRotateCell(self.voiceCommands.dynamicHash, NSUIntBitCell / 2);
}

- (BOOL)isEqual:(id)object {
    if (self == object) { return YES; }
    if (![object isMemberOfClass:[self class]]) { return NO; }

    return [self isEqualToVoiceCommand:(SDLVoiceCommand *)object];
}

- (BOOL)isEqualToVoiceCommand:(SDLVoiceCommand *)voiceCommand {
    if (voiceCommand == nil) { return NO; }

    return (self.hash == voiceCommand.hash);
}

@end

NS_ASSUME_NONNULL_END
