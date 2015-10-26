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


typedef NSString SDLPermissionRPCName;


NS_ASSUME_NONNULL_BEGIN

@interface SDLPermissionManager ()

@property (copy, nonatomic) NSMutableDictionary<SDLPermissionRPCName *, SDLPermissionItem *> *permissions;
@property (copy, nonatomic) NSMutableDictionary<SDLPermissionRPCName *, NSMutableArray<SDLPermissionObserver> *> *observers;

@end


@implementation SDLPermissionManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_permissionsDidChange:) name:SDLDidChangePermissionsNotification object:nil];
    
    return self;
}


#pragma mark - Permissions available

- (BOOL)isRPCAllowed:(NSString *)rpcName forHMILevel:(SDLHMILevel *)hmiLevel {
    // TODO: Use an enum to specify unknown?
    if (self.permissions[rpcName] == nil) {
        return NO;
    }
    
    SDLPermissionItem *item = self.permissions[rpcName];
    if ([item.hmiPermissions.allowed containsObject:hmiLevel.value]) {
        return YES;
    } else {
        return NO;
    }
}


#pragma mark - Permissions observers

#pragma mark Add Observers

- (void)addObserverForRPC:(NSString *)rpcName usingBlock:(SDLPermissionObserver)observer {
    // If there is a current permission, send that immediately
    if (self.permissions[rpcName] != nil) {
        observer(rpcName, nil, self.permissions[rpcName]);
    }
    
    [self.observers[rpcName] addObject:observer];
}

- (void)addObserverForRPCs:(NSArray<NSString *> *)rpcNames usingBlock:(SDLPermissionObserver)observer {
    for (NSString *rpcName in rpcNames) {
        if (self.permissions[rpcName] != nil) {
            observer(rpcName, nil, self.permissions[rpcName]);
        }
        
        [self.observers[rpcName] addObject:observer];
    }
}

#pragma mark Remove Observers

- (void)removeAllObservers {
    [self.observers removeAllObjects];
}

- (void)removeObserversForRPC:(NSString *)rpcName {
    [self.observers removeObjectForKey:rpcName];
}

- (void)removeObserversForRPCs:(NSArray<NSString *> *)rpcNames {
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

@end

NS_ASSUME_NONNULL_END
