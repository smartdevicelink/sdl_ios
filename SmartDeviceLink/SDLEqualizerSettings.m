//  SDLEqualizerSettings.m
//

#import "SDLEqualizerSettings.h"
#import "SDLNames.h"
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
    [store sdl_setObject:channelId forName:SDLNameChannelId];
}

- (NSNumber<SDLInt> *)channelId {
    return [store sdl_objectForName:SDLNameChannelId];
}

- (void)setChannelName:(nullable NSString *)channelName {
    [store sdl_setObject:channelName forName:SDLNameChannelName];
}

- (nullable NSString *)channelName {
    return [store sdl_objectForName:SDLNameChannelName];
}

- (void)setChannelSetting:(NSNumber<SDLInt> *)channelSetting {
    [store sdl_setObject:channelSetting forName:SDLNameChannelSetting];
}

- (NSNumber<SDLInt> *)channelSetting {
    return [store sdl_objectForName:SDLNameChannelSetting];
}

@end

NS_ASSUME_NONNULL_END
