//  SDLEqualizerSettings.m
//

#import "SDLEqualizerSettings.h"
#import "SDLNames.h"
#import "NSMutableDictionary+Store.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLEqualizerSettings

- (instancetype)initWithChannelId:(UInt32)id channelSettings:(UInt32)settings {
    self = [self init];
    if(!self) {
        return nil;
    }

    self.channelId = @(id);
    self.channelSetting = @(settings);

    return self;
}

- (instancetype)initWithChannelId:(UInt32)id channelName:(nullable NSString *)name channelSettings:(UInt32)settings {
    self = [self init];
    if(!self) {
        return nil;
    }

    self.channelId = @(id);
    self.channelSetting = @(settings);
    self.channelName = name;

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
