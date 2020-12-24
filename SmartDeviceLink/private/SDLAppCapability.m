//
//  SDLAppCapability.m
//  SmartDeviceLink-iOS
//

#import "NSMutableDictionary+Store.h"
#import "SDLAppCapability.h"
#import "SDLRPCParameterNames.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLSystemCapabilityType.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLAppCapability

- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability {
    self = [self init];
    if (self) {
        self.appCapabilityType = SDLSystemCapabilityTypeVideoStreaming;
        self.videoStreamingCapability = capability;
    }

    return self;
}

- (void)setAppCapabilityType:(SDLSystemCapabilityType)type {
    [self.store sdl_setObject:type forName:SDLRPCParameterNameAppCapabilityType];
}

- (SDLSystemCapabilityType)appCapabilityType {
    return [self.store sdl_enumForName:SDLRPCParameterNameAppCapabilityType error:NULL];
}

- (void)setVideoStreamingCapability:(nullable SDLVideoStreamingCapability *)videoStreamingCapability {
    [self.store sdl_setObject:videoStreamingCapability forName:SDLRPCParameterNameVideoStreamingCapability];
}

- (nullable SDLVideoStreamingCapability *)videoStreamingCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNameVideoStreamingCapability ofClass:SDLVideoStreamingCapability.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
