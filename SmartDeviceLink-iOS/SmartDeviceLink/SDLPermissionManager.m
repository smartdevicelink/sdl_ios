//
//  SDLPermissionManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLPermissionManager.h"

#import "SDLHMILevel.h"
#import "SDLHMIPermissions.h"
#import "SDLNotificationConstants.h"
#import "SDLPermissionItem.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLPermissionManager ()

@property (strong, nonatomic) NSMutableDictionary<SDLPermissionRPCName *, SDLPermissionItem *> *permissions;
@property (strong, nonatomic) NSMutableDictionary<SDLPermissionRPCName *, NSMutableArray<SDLPermissionObserver> *> *observers;
@property (copy, nonatomic) SDLHMILevel *currentLevel;

@end


@implementation SDLPermissionManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _currentLevel = nil;
    _permissions = [NSMutableDictionary<SDLPermissionRPCName *, SDLPermissionItem *> dictionary];
    _observers = [NSMutableDictionary<SDLPermissionRPCName *, NSMutableArray<SDLPermissionObserver> *> dictionary];
    
    // Set up SDL status notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_permissionsDidChange:) name:SDLDidChangePermissionsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiLevelDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];
    
    return self;
}


#pragma mark - Permissions available

- (BOOL)isRPCAllowed:(NSString *)rpcName {
    // TODO: Use an enum to specify unknown?
    if (self.permissions[rpcName] == nil || self.currentLevel == nil) {
        return NO;
    }
    
    SDLPermissionItem *item = self.permissions[rpcName];
    return [item.hmiPermissions.allowed containsObject:self.currentLevel];
}


#pragma mark - Permissions observers

#pragma mark Add Observers

- (void)addObserverForRPC:(NSString *)rpcName usingBlock:(SDLPermissionObserver)observer {
    // If there is a current permission, send that immediately
    if (self.permissions[rpcName] != nil) {
        observer(rpcName, nil, self.permissions[rpcName]);
    }
    
    // If we don't currently have anything for this RPC name, then create an array to house observers
    if (self.observers[rpcName] == nil) {
        self.observers[rpcName] = [NSMutableArray<SDLPermissionObserver> array];
    }
    
    [self.observers[rpcName] addObject:[observer copy]];
}

- (void)addObserverForRPCs:(NSArray<SDLPermissionRPCName *> *)rpcNames usingBlock:(SDLPermissionObserver)observer {
    for (NSString *rpcName in rpcNames) {
        [self addObserverForRPC:rpcName usingBlock:observer];
    }
}

#pragma mark Remove Observers

- (void)removeAllObservers {
    [self.observers removeAllObjects];
}

- (void)removeObserversForRPC:(NSString *)rpcName {
    [self.observers removeObjectForKey:rpcName];
}

- (void)removeObserversForRPCs:(NSArray<SDLPermissionRPCName *> *)rpcNames {
    [self.observers removeObjectsForKeys:rpcNames];
}


#pragma mark - SDL Notification Observers

- (void)sdl_permissionsDidChange:(NSNotification *)notification {
    NSArray<SDLPermissionItem *> *permissionItems = notification.userInfo[SDLNotificationUserInfoNotificationObject];
    
    for (SDLPermissionItem *newItem in permissionItems) {
        // Hold onto the old item, then replace it in the dictionary
        SDLPermissionItem *oldItem = self.permissions[newItem.rpcName];
        self.permissions[newItem.rpcName] = newItem;
        
        // Pull all the observers for the rpc's permissions, then call them
        NSArray<SDLPermissionObserver> *observers = [self.observers[newItem.rpcName] copy];
        for (SDLPermissionObserver observer in observers) {
            observer(newItem.rpcName, oldItem, newItem);
        }
    }
}

- (void)sdl_hmiLevelDidChange:(NSNotification *)notification {
    SDLHMILevel *oldLevel = self.currentLevel;
    SDLHMILevel *newLevel = notification.userInfo[SDLNotificationUserInfoNotificationObject];
    
    for (NSString *rpcName in self.observers.allKeys) {
        SDLPermissionItem *item = [self.permissions[rpcName] copy];
        BOOL newAllowed = [item.hmiPermissions.allowed containsObject:newLevel];
        BOOL oldAllowed = [item.hmiPermissions.allowed containsObject:oldLevel];
        
        if ((!newAllowed && !oldAllowed) || (newAllowed && oldAllowed)) {
            // No change
            return;
        } else {
            // Now permitted when it was not before, or not permitted when it was before
            for (SDLPermissionObserver observer in [self.observers[rpcName] copy]) {
                observer(rpcName, nil, item); // TODO
            }
        }
    }
}

@end

NS_ASSUME_NONNULL_END
