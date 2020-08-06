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

extern void *const SDLProcessingQueueName;
extern void *const SDLConcurrentQueueName;

@interface SDLGlobals : NSObject

@property (copy, nonatomic, readonly) SDLVersion *protocolVersion;
@property (strong, nonatomic) SDLVersion *rpcVersion;
@property (copy, nonatomic) SDLVersion *maxHeadUnitProtocolVersion;

@property (copy, nonatomic) dispatch_queue_t sdlProcessingQueue;
@property (copy, nonatomic) dispatch_queue_t sdlConcurrentQueue;

+ (instancetype)sharedGlobals;

- (void)setDynamicMTUSize:(NSUInteger)maxMTUSize forServiceType:(SDLServiceType)serviceType;
- (NSUInteger)mtuSizeForServiceType:(SDLServiceType)serviceType;

/// Calls a block on an SDL sub-queue of the internal serial SDLProcessingQueue. If the call to this method is already on that queue, the block will be run, if it is not, a `dispatch_sync` will occur to that queue first.
/// @param queue The queue to run on. The passed queue should be a sub-queue of the SDLProcessingQueue. If it is not and the call to this method occurs on the passed queue, a deadlock will occur because the check will not pass correctly.
/// @param block The block to run on the serial sub-queue.
+ (void)runSyncOnSerialSubQueue:(dispatch_queue_t)queue block:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
