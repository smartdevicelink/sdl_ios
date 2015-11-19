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
#import "SDLPermissionFilter.h"
#import "SDLPermissionItem.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLPermissionManager ()

@property (copy, nonatomic) NSMutableDictionary<SDLPermissionRPCName *, SDLPermissionItem *> *permissions;
@property (copy, nonatomic) NSMutableArray<SDLPermissionFilter *> *filters;
@property (copy, nonatomic) SDLHMILevel *currentHMILevel;

@end


@implementation SDLPermissionManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _currentHMILevel = nil;
    _permissions = [NSMutableDictionary<SDLPermissionRPCName *, SDLPermissionItem *> dictionary];
    _filters = [NSMutableArray<SDLPermissionFilter *> array];
    
    // Set up SDL status notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_permissionsDidChange:) name:SDLDidChangePermissionsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiLevelDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];
    
    return self;
}


#pragma mark - Permissions available

- (BOOL)isRPCAllowed:(NSString *)rpcName {
    // TODO: Use an enum to specify unknown?
    if (self.permissions[rpcName] == nil || self.currentHMILevel == nil) {
        return NO;
    }
    
    SDLPermissionItem *item = self.permissions[rpcName];
    return [item.hmiPermissions.allowed containsObject:self.currentHMILevel];
}

- (SDLPermissionChangeType)permissionStatusForRPCs:(NSArray<SDLPermissionRPCName *> *)rpcNames {
    // If we don't have an HMI level, then just say everything is disallowed
    if (self.currentHMILevel == nil) {
        return SDLPermissionChangeTypeAllDisallowed;
    }
    
    BOOL hasAllowed = NO;
    BOOL hasDisallowed = NO;
    
    // Loop through all the RPCs we need to check
    for (NSString *rpcName in rpcNames) {
        // If at this point in the loop, we have both allowed and disallowed RPCs, return the mixed result
        if (hasAllowed && hasDisallowed) {
            return SDLPermissionChangeTypeAny;
        }
        
        // If we don't have a status for this permission, set it as disallowed
        if (self.permissions[rpcName] == nil) {
            hasDisallowed = YES;
            continue;
        }
        
        // Check the permission's "allowed" array for the current HMI level
        if ([self.permissions[rpcName].hmiPermissions.allowed containsObject:self.currentHMILevel]) {
            hasAllowed = YES;
        } else {
            hasDisallowed = YES;
        }
    }
    
    if (hasAllowed) {
        return SDLPermissionChangeTypeAllAllowed;
    } else {
        return SDLPermissionChangeTypeAllDisallowed;
    }
}

- (NSDictionary<SDLPermissionRPCName *, NSNumber<SDLBool> *> *)permissionAllowedDictForRPCs:(NSArray<SDLPermissionRPCName *> *)rpcNames {
    NSMutableDictionary<SDLPermissionRPCName *, NSNumber<SDLBool> *> *permissionAllowedDict = [NSMutableDictionary dictionary];
    
    for (NSString *rpcName in rpcNames) {
        BOOL allowed = [self isRPCAllowed:rpcName];
        permissionAllowedDict[rpcName] = @(allowed);
    }
    
    return [permissionAllowedDict copy];
}


#pragma mark - Permissions observers

#pragma mark Add Observers

- (SDLPermissionObserverIdentifier *)addObserverForRPC:(SDLPermissionRPCName *)rpcName onChange:(SDLPermissionChangeType)changeType withBlock:(SDLPermissionObserver)observer {
    // If there is a current permission that fits the specifications, send that immediately
    BOOL isAllowed = [self isRPCAllowed:rpcName];
    if (isAllowed && (changeType == SDLPermissionChangeTypeAllAllowed || changeType == SDLPermissionChangeTypeAny)) {
        observer(@{rpcName: @(YES)}, changeType);
    } else if (!isAllowed && (changeType == SDLPermissionChangeTypeAllDisallowed || changeType == SDLPermissionChangeTypeAny)) {
        observer(@{rpcName: @(NO)}, changeType);
    }
    
    // Store the filter for later use
    SDLPermissionFilter *filter = [SDLPermissionFilter filterWithRPCNames:@[rpcName] changeType:changeType observer:observer];
    [self.filters addObject:filter];
    
    return filter.identifier;
}

- (SDLPermissionObserverIdentifier *)addObserverForRPCs:(NSArray<SDLPermissionRPCName *> *)rpcNames onChange:(SDLPermissionChangeType)changeType withBlock:(SDLPermissionObserver)observer {
    SDLPermissionFilter *filter = [SDLPermissionFilter filterWithRPCNames:rpcNames changeType:changeType observer:observer];
    
    // If there are permissions that fit the specifications, send immediately
    [self sdl_checkAndCallFilter:filter];
    
    // Store the filter for later use and return the identifier
    [self.filters addObject:filter];
    
    return filter.identifier;
}

- (void)sdl_checkAndCallFilter:(SDLPermissionFilter *)filter {
    SDLPermissionChangeType allowedStatus = [self permissionStatusForRPCs:filter.rpcNames];
    
    switch (filter.changeType) {
        case SDLPermissionChangeTypeAllAllowed: {
            // The status matches the filter's changeType
            if (allowedStatus == SDLPermissionChangeTypeAllAllowed) {
                NSMutableDictionary *allowedDict = [NSMutableDictionary dictionary];
                for (NSString *rpcName in filter.rpcNames) {
                    allowedDict[rpcName] = @YES;
                }
                
                filter.observer([allowedDict copy], allowedStatus);
            }
        } break;
        case SDLPermissionChangeTypeAllDisallowed: {
            // The status matches the filter's changeType
            if (allowedStatus == SDLPermissionChangeTypeAllDisallowed) {
                NSMutableDictionary *allowedDict = [NSMutableDictionary dictionary];
                for (NSString *rpcName in filter.rpcNames) {
                    allowedDict[rpcName] = @NO;
                }
                
                filter.observer([allowedDict copy], allowedStatus);
            }
        } break;
        case SDLPermissionChangeTypeAny: {
            // If they passed in Any, they want to be notified no matter what
            NSDictionary *allowedDict = [self permissionAllowedDictForRPCs:filter.rpcNames];
            filter.observer(allowedDict, allowedStatus);
        } break;
    }
}

#pragma mark Remove Observers

- (void)removeAllObservers {
    [self.filters removeAllObjects];
}

- (void)removeObserverForIdentifier:(SDLPermissionObserverIdentifier *)identifier {
    NSArray<SDLPermissionFilter *> *filters = [self.filters copy];
    
    for (SDLPermissionFilter *filter in filters) {
        if ([filter.identifier isEqual:identifier]) {
            [self.filters removeObject:filter];
            break;
        }
    }
}


#pragma mark - SDL Notification Observers

- (void)sdl_permissionsDidChange:(NSNotification *)notification {
    NSArray<SDLPermissionItem *> *permissionItems = notification.userInfo[SDLNotificationUserInfoNotificationObject];
    NSArray<SDLPermissionFilter *> *filters = [self.filters copy];
    
    // Set the updated permissions on our stored permissions object
    for (SDLPermissionItem *item in permissionItems) {
        self.permissions[item.rpcName] = item;
    }
    
    // We only want to call on filters whose observed permissions changed, so check all of our filters for ones that have an RPC whose permission changed.
    // Just brute force it. We shouldn't run into many problems.
    NSMutableArray<SDLPermissionFilter *> *mutableFiltersToCall = [NSMutableArray arrayWithCapacity:filters.count];
    for (SDLPermissionFilter *filter in filters) {
        for (SDLPermissionItem *item in permissionItems) {
            // If the filter covers one of the updated permissions, store it to be called
            if ([filter.rpcNames containsObject:item.rpcName]) {
                [mutableFiltersToCall addObject:filter];
                break;
            }
        }
    }
    
    NSArray *filtersToCall = [mutableFiltersToCall copy];
    mutableFiltersToCall = nil;
    
    // For all the modified filters, check and call if necessary
    for (SDLPermissionFilter *filter in filtersToCall) {
        [self sdl_checkAndCallFilter:filter];
    }
}

- (void)sdl_hmiLevelDidChange:(NSNotification *)notification {
    SDLHMILevel *oldLevel = self.currentHMILevel;
    SDLHMILevel *newLevel = notification.userInfo[SDLNotificationUserInfoNotificationObject];
    NSArray *filters = [self.filters copy];
    
    // Only check what we have filters for
    NSMutableArray<SDLPermissionFilter *> *mutableFiltersToCall = [NSMutableArray arrayWithCapacity:filters.count];
    for (SDLPermissionFilter *filter in filters) {
        // Check if an RPC within our filter changed based on the HMI change. If it did, add it to our filters to check and call.
        for (NSString *rpcName in filter.rpcNames) {
            SDLPermissionItem *item = self.permissions[rpcName];
            BOOL newAllowed = [item.hmiPermissions.allowed containsObject:newLevel];
            BOOL oldAllowed = [item.hmiPermissions.allowed containsObject:oldLevel];
            
            if ((newAllowed && !oldAllowed) || (!newAllowed && oldAllowed)) {
                // Now permitted when it was not before, or not permitted when it was before
                [mutableFiltersToCall addObject:filter];
                break;
            }
        }
    }
    
    NSArray *filtersToCall = [mutableFiltersToCall copy];
    mutableFiltersToCall = nil;
    
    // For all the modified filters, check and call if necessary
    for (SDLPermissionFilter *filter in filtersToCall) {
        [self sdl_checkAndCallFilter:filter];
    }
}

@end

NS_ASSUME_NONNULL_END
