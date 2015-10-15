//
//  SDLPermissionManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLHMILevel, SDLPermissionItem;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SDLPermissionObserver)(NSString *rpcName, SDLPermissionItem * __nullable oldPermission, SDLPermissionItem *newPermission);

@interface SDLPermissionManager : NSObject

- (BOOL)isRPCAllowed:(NSString *)rpcName forHMILevel:(SDLHMILevel *)hmiLevel;
- (void)addObserverForRPC:(NSString *)rpcName usingBlock:(SDLPermissionObserver)observer;
- (void)addObserverForRPCs:(NSArray<NSString *> *)rpcNames usingBlock:(SDLPermissionObserver)observer;
- (void)removeAllObservers;

@end

NS_ASSUME_NONNULL_END
