//
//  SDLAppServiceManifest.m
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLAppServiceManifest.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

@implementation SDLAppServiceManifest

- (void)setServiceName:(NSString *)serviceName {
    [store sdl_setObject:serviceName forName:SDLNameServiceName];
}

- (NSString *)serviceName {
    return [store sdl_objectForName:SDLNameServiceName];
}

- (void)setServiceIcon:(NSString *)serviceIcon {
    [store sdl_setObject:serviceIcon forName:SDLNameServiceIcon];
}

- (NSString *)serviceIcon {
    return [store sdl_objectForName:SDLNameServiceIcon];
}

- (void)setAllowAppConsumers:(NSNumber<SDLBool> *)allowAppConsumers {
    [store sdl_setObject:allowAppConsumers forName:SDLNameAllowAppConsumers];
}

- (NSNumber<SDLBool> *)allowAppConsumers {
    return [store sdl_objectForName:SDLNameAllowAppConsumers];
}

- (void)setUriPrefix:(NSString *)uriPrefix {
    [store sdl_setObject:uriPrefix forName:SDLNameURIPrefix];
}

- (NSString *)uriPrefix {
    return [store sdl_objectForName:SDLNameURIPrefix];
}

- (void)setRpcSpecVersion:(SDLSyncMsgVersion *)rpcSpecVersion {
    [store sdl_setObject:rpcSpecVersion forName:SDLNameRPCSpecVersion];
}

- (SDLSyncMsgVersion *)rpcSpecVersion {
    return [store sdl_objectForName:SDLNameRPCSpecVersion ofClass:SDLSyncMsgVersion.class];
}

- (void)setHandledRPCs:(NSArray<SDLFunctionID *> *)handledRPCs {
    [store sdl_setObject:handledRPCs forName:SDLNameHandledRPCs];
}

- (NSArray<SDLFunctionID *> *)handledRPCs {
    return [store sdl_objectsForName:SDLNameHandledRPCs ofClass:SDLFunctionID.class];
}

@end
