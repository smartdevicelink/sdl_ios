//
//  SDLGlobals.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/5/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLProtocolConstants.h"

@class SDLProtocolHeader;
@class SDLSyncMsgVersion;
@class SDLVersion;

NS_ASSUME_NONNULL_BEGIN

#define SDL_SYSTEM_VERSION_LESS_THAN(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)
#define SDL_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version) ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending)
#define BLOCK_RETURN return

extern NSString *const SDLMaxProxyProtocolVersion;
extern NSString *const SDLMaxProxyRPCVersion;

extern NSUInteger const SDLDefaultMTUSize;
extern NSUInteger const SDLV1MTUSize;
extern NSUInteger const SDLV3MTUSize;

@interface SDLGlobals : NSObject

@property (copy, nonatomic, readonly) SDLVersion *protocolVersion;
@property (strong, nonatomic) SDLVersion *rpcVersion;
@property (copy, nonatomic) SDLVersion *maxHeadUnitProtocolVersion;

@property (copy, nonatomic) dispatch_queue_t sdlProcessingQueue;
@property (copy, nonatomic) dispatch_queue_t sdlConcurrentQueue;

+ (instancetype)sharedGlobals;

- (void)setDynamicMTUSize:(NSUInteger)maxMTUSize forServiceType:(SDLServiceType)serviceType;
- (NSUInteger)mtuSizeForServiceType:(SDLServiceType)serviceType;

@end

NS_ASSUME_NONNULL_END
