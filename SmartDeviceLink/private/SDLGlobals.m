//
//  SDLGlobals.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/5/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLGlobals.h"

#import "SDLLogMacros.h"
#import "SDLProtocolHeader.h"
#import "SDLVersion.h"

NS_ASSUME_NONNULL_BEGIN

// VERSION DEPENDENT CODE
NSString *const SDLMaxProxyProtocolVersion = @"5.3.0";
NSString *const SDLMaxProxyRPCVersion =  @"7.0.0";

NSUInteger const SDLDefaultMTUSize = UINT32_MAX;
NSUInteger const SDLV1MTUSize = 1024;
NSUInteger const SDLV3MTUSize = 131024;

void *const SDLProcessingQueueName = "com.sdl.serialProcessing";
void *const SDLConcurrentQueueName = "com.sdl.concurrentProcessing";

typedef NSNumber *ServiceTypeBox;
typedef NSNumber *MTUBox;


@interface SDLGlobals ()

@property (strong, nonatomic) NSMutableDictionary<ServiceTypeBox, MTUBox> *dynamicMTUDict;
@property (copy, nonatomic, readwrite) SDLVersion *protocolVersion;

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

    _protocolVersion = [[SDLVersion alloc] initWithString:@"1.0.0"];
    _maxHeadUnitProtocolVersion = [[SDLVersion alloc] initWithString:@"0.0.0"];
    _rpcVersion = [[SDLVersion alloc] initWithString:@"1.0.0"];
    _dynamicMTUDict = [NSMutableDictionary dictionary];

    dispatch_queue_attr_t qosSerial = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 0);
    dispatch_queue_attr_t qosConcurrent = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_USER_INITIATED, 0);

    _sdlProcessingQueue = dispatch_queue_create(SDLProcessingQueueName, qosSerial);
    dispatch_queue_set_specific(_sdlProcessingQueue, SDLProcessingQueueName, SDLProcessingQueueName, NULL);
    _sdlConcurrentQueue = dispatch_queue_create(SDLConcurrentQueueName, qosConcurrent);
    dispatch_queue_set_specific(_sdlConcurrentQueue, SDLConcurrentQueueName, SDLConcurrentQueueName, NULL);

    return self;
}

+ (void)runSyncOnSerialSubQueue:(dispatch_queue_t)queue block:(void (^)(void))block {
    if (dispatch_get_specific(SDLProcessingQueueName) != nil) {
        block();
    } else {
        dispatch_sync(queue, block);
    }
}

#pragma mark - Custom Getters / Setters

- (void)setMaxHeadUnitProtocolVersion:(SDLVersion *)maxHeadUnitVersion {
    SDLVersion *maxProxyProtocolVersion = [SDLVersion versionWithString:SDLMaxProxyProtocolVersion];
    self.protocolVersion = [maxHeadUnitVersion isGreaterThanVersion:maxProxyProtocolVersion] ? maxProxyProtocolVersion : maxHeadUnitVersion;

    _maxHeadUnitProtocolVersion = maxHeadUnitVersion;
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

- (NSUInteger)sdl_defaultMaxMTUSize {
    // VERSION DEPENDENT CODE
    switch (self.protocolVersion.major) {
        case 1: // fallthrough
        case 2: {
            // HAX: This was set to 1024 at some point, for an unknown reason. We can't change it because of backward compatibility & validation concerns. The actual MTU for v1/2 is 1500 bytes.
            return SDLV1MTUSize;
        } break;
        case 3: // fallthrough
        case 4: // fallthrough
        case 5: {
            // If the head unit isn't running v3/4, but that's the connection scheme we're using, then we have to know that they could be running an MTU that's not 128k, so we default back to the v1/2 MTU for safety.
            if ([self.maxHeadUnitProtocolVersion isGreaterThanVersion:[SDLVersion versionWithString:SDLMaxProxyProtocolVersion]]) {
                return SDLV1MTUSize;
            } else {
                return SDLV3MTUSize;
            }
        } break;
        default: {
            NSAssert(NO, @"Unknown MTU size for protocol version: %@", self.protocolVersion);
            return 0;
        }
    }
}

@end

NS_ASSUME_NONNULL_END
