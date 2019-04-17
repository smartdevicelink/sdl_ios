//  SDLEqualizerSettings.m
//

#import "SDLEqualizerSettings.h"
#import "SDLRPCParameterNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLEqualizerSettings

- (instancetype)initWithChannelId:(UInt8)channelId channelSetting:(UInt8)channelSetting {
    self = [self init];
    if(!self) {
        return nil;
    }

    self.channelId = @(channelId);
    self.channelSetting = @(channelSetting);

    return self;
}

- (void)setChannelId:(NSNumber<SDLInt> *)channelId {
    [store sdl_setObject:channelId forName:SDLRPCParameterNameChannelId];
}

- (NSNumber<SDLInt> *)channelId {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameChannelId ofClass:NSNumber.class error:&error];
}

- (void)setChannelName:(nullable NSString *)channelName {
    [store sdl_setObject:channelName forName:SDLRPCParameterNameChannelName];
}

- (nullable NSString *)channelName {
    return [store sdl_objectForName:SDLRPCParameterNameChannelName ofClass:NSString.class error:nil];
}

- (void)setChannelSetting:(NSNumber<SDLInt> *)channelSetting {
    [store sdl_setObject:channelSetting forName:SDLRPCParameterNameChannelSetting];
}

- (NSNumber<SDLInt> *)channelSetting {
    NSError *error = nil;
    return [store sdl_objectForName:SDLRPCParameterNameChannelSetting ofClass:NSNumber.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
