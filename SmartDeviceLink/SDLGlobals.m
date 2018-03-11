//
//  SDLGlobals.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/5/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLGlobals.h"

#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

// VERSION DEPENDENT CODE
NSString *const SDLMaxProxyProtocolVersion = @"5.1.0";

NSUInteger const SDLDefaultMTUSize = UINT32_MAX;
NSUInteger const SDLV1MTUSize = 1024;
NSUInteger const SDLV3MTUSize = 131024;


typedef NSNumber* ServiceTypeBox;
typedef NSNumber* MTUBox;


@interface SDLGlobals ()

@property (strong, nonatomic) NSMutableDictionary<ServiceTypeBox, MTUBox> *dynamicMTUDict;
@property (strong, nonatomic, readwrite) NSString *protocolVersion;

@end


@implementation SDLGlobals

+ (instancetype)sharedGlobals {
    static SDLGlobals *sharedGlobals = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobals = [[SDLGlobals alloc] init];
    });

    return sharedGlobals;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _protocolVersion = @"1.0.0";
    _maxHeadUnitVersion = @"0.0.0";
    _dynamicMTUDict = [NSMutableDictionary dictionary];

    return self;
}


#pragma mark - Custom Getters / Setters

- (void)setMaxHeadUnitVersion:(NSString *)maxHeadUnitVersion {
    self.protocolVersion = [self sdl_isVersion:maxHeadUnitVersion greaterThanVersion:SDLMaxProxyProtocolVersion] ? SDLMaxProxyProtocolVersion : maxHeadUnitVersion;

    _maxHeadUnitVersion = maxHeadUnitVersion;
}

- (NSInteger)majorProtocolVersion {
    return [self.protocolVersion substringWithRange:NSMakeRange(0, 1)].integerValue;
}

- (void)setDynamicMTUSize:(NSUInteger)maxMTUSize forServiceType:(SDLServiceType)serviceType {
    SDLLogV(@"Setting dynamic MTU size: %lu for service %u", (unsigned long)maxMTUSize, serviceType);
    self.dynamicMTUDict[@(serviceType)] = @(maxMTUSize);
}

- (NSUInteger)mtuSizeForServiceType:(SDLServiceType)serviceType {
    if (self.dynamicMTUDict[@(serviceType)] != nil) {
        return self.dynamicMTUDict[@(serviceType)].unsignedIntegerValue;
    } else if (self.dynamicMTUDict[@(SDLServiceTypeRPC)]) {
        return self.dynamicMTUDict[@(SDLServiceTypeRPC)].unsignedIntegerValue;
    } else {
        return [self sdl_defaultMaxMTUSize];
    }
}


#pragma mark - Helpers

- (BOOL)sdl_isVersion:(NSString *)version1 greaterThanVersion:(NSString *)version2 {
    return ([version1 compare:version2 options:NSNumericSearch] == NSOrderedDescending);
}

- (NSUInteger)sdl_defaultMaxMTUSize {
    // VERSION DEPENDENT CODE
    switch (self.majorProtocolVersion) {
        case 1: // fallthrough
        case 2: {
            // HAX: This was set to 1024 at some point, for an unknown reason. We can't change it because of backward compatibility & validation concerns. The actual MTU for v1/2 is 1500 bytes.
            return SDLV1MTUSize;
        } break;
        case 3: // fallthrough
        case 4: // fallthrough
        case 5: {
            // If the head unit isn't running v3/4, but that's the connection scheme we're using, then we have to know that they could be running an MTU that's not 128k, so we default back to the v1/2 MTU for safety.
            if ([self sdl_isVersion:self.maxHeadUnitVersion greaterThanVersion:SDLMaxProxyProtocolVersion]) {
                return SDLV1MTUSize;
            } else {
                return SDLV3MTUSize;
            }
        } break;
        default: {
            NSAssert(NO, @"Unknown version number for MTU Size: %@", @(self.majorProtocolVersion));
            return 0;
        }
    }
}

@end

NS_ASSUME_NONNULL_END
