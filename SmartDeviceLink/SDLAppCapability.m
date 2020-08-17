//
//  SDLAppCapability.m
//  SmartDeviceLink-iOS
//

#import "NSMutableDictionary+Store.h"
#import "SDLAppCapability.h"
#import "SDLRPCParameterNames.h"
#import "SDLVideoStreamingCapability.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppCapability

- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.appCapabilityType = SDLAppCapabilityTypeVideoStreaming;
    self.videoStreamingCapability = capability;

    return self;
}

- (void)setSystemCapabilityType:(SDLAppCapabilityType)type {
    [self.store sdl_setObject:type forName:SDLRPCParameterNameAppCapabilityType];
}

- (SDLAppCapabilityType)systemCapabilityType {
    return [self.store sdl_enumForName:SDLRPCParameterNameAppCapabilityType error:NULL];
}

- (void)setVideoStreamingCapability:(nullable SDLVideoStreamingCapability *)videoStreamingCapability {
    [self.store sdl_setObject:videoStreamingCapability forName:SDLAppCapabilityTypeVideoStreaming];
}

- (nullable SDLVideoStreamingCapability *)videoStreamingCapability {
    return [self.store sdl_objectForName:SDLAppCapabilityTypeVideoStreaming ofClass:SDLVideoStreamingCapability.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
