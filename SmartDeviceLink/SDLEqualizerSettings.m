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
    return [store sdl_objectForName:SDLRPCParameterNameChannelId];
}

- (void)setChannelName:(nullable NSString *)channelName {
    [store sdl_setObject:channelName forName:SDLRPCParameterNameChannelName];
}

- (nullable NSString *)channelName {
    return [store sdl_objectForName:SDLRPCParameterNameChannelName];
}

- (void)setChannelSetting:(NSNumber<SDLInt> *)channelSetting {
    [store sdl_setObject:channelSetting forName:SDLRPCParameterNameChannelSetting];
}

- (NSNumber<SDLInt> *)channelSetting {
    return [store sdl_objectForName:SDLRPCParameterNameChannelSetting];
}

@end

NS_ASSUME_NONNULL_END
