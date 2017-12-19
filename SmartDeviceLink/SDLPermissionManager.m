//
//  SDLPermissionManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLPermissionManager.h"

#import "SDLHMIPermissions.h"
#import "SDLNotificationConstants.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnPermissionsChange.h"
#import "SDLPermissionFilter.h"
#import "SDLPermissionItem.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLStateMachine.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLPermissionManager ()

@property (strong, nonatomic) NSMutableDictionary<SDLPermissionRPCName, SDLPermissionItem *> *permissions;
@property (strong, nonatomic) NSMutableArray<SDLPermissionFilter *> *filters;
@property (copy, nonatomic, nullable) SDLHMILevel currentHMILevel;

@end


@implementation SDLPermissionManager

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _currentHMILevel = nil;
    _permissions = [NSMutableDictionary<SDLPermissionRPCName, SDLPermissionItem *> dictionary];
    _filters = [NSMutableArray<SDLPermissionFilter *> array];

    // Set up SDL status notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_permissionsDidChange:) name:SDLDidChangePermissionsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_hmiLevelDidChange:) name:SDLDidChangeHMIStatusNotification object:nil];

    return self;
}

- (void)startWithCompletionHandler:(void (^)(BOOL, NSError *_Nullable))completionHandler {
    completionHandler(YES, nil);
}

- (void)stop {
    // Nothing to do here right now
}


#pragma mark - Permissions available

- (BOOL)isRPCAllowed:(NSString *)rpcName {
    if (self.permissions[rpcName] == nil || self.currentHMILevel == nil) {
        return NO;
    }

    SDLPermissionItem *item = self.permissions[rpcName];
    return [item.hmiPermissions.allowed containsObject:self.currentHMILevel];
}

- (SDLPermissionGroupStatus)groupStatusOfRPCs:(NSArray<SDLPermissionRPCName> *)rpcNames {
    if (self.currentHMILevel == nil) {
        return SDLPermissionGroupStatusUnknown;
    }

    return [self.class sdl_groupStatusOfRPCs:rpcNames withPermissions:[self.permissions copy] hmiLevel:self.currentHMILevel];
}

+ (SDLPermissionGroupStatus)sdl_groupStatusOfRPCs:(NSArray<SDLPermissionRPCName> *)rpcNames withPermissions:(NSDictionary<SDLPermissionRPCName, SDLPermissionItem *> *)permissions hmiLevel:(SDLHMILevel)hmiLevel {
    // If we don't have an HMI level, then just say everything is disallowed
    if (hmiLevel == nil) {
        return SDLPermissionGroupStatusUnknown;
    }

    BOOL hasAllowed = NO;
    BOOL hasDisallowed = NO;

    // Loop through all the RPCs we need to check
    for (NSString *rpcName in rpcNames) {
        // If at this point in the loop, we have both allowed and disallowed RPCs, return the mixed result
        if (hasAllowed && hasDisallowed) {
            return SDLPermissionGroupStatusMixed;
        }

        // If we don't have a status for this permission, set it as disallowed
        if (permissions[rpcName] == nil) {
            hasDisallowed = YES;
            continue;
        }

        // Check the permission's "allowed" array for the current HMI level
        if ([permissions[rpcName].hmiPermissions.allowed containsObject:hmiLevel]) {
            hasAllowed = YES;
        } else {
            hasDisallowed = YES;
        }
    }

    if (hasAllowed && hasDisallowed) {
        return SDLPermissionGroupStatusMixed;
    } else if (hasAllowed) {
        return SDLPermissionGroupStatusAllowed;
    } else {
        return SDLPermissionGroupStatusDisallowed;
    }
}

- (NSDictionary<SDLPermissionRPCName, NSNumber<SDLBool> *> *)statusOfRPCs:(NSArray<SDLPermissionRPCName> *)rpcNames {
    NSMutableDictionary<SDLPermissionRPCName, NSNumber<SDLBool> *> *permissionAllowedDict = [NSMutableDictionary dictionary];

    for (NSString *rpcName in rpcNames) {
        BOOL allowed = [self isRPCAllowed:rpcName];
        permissionAllowedDict[rpcName] = @(allowed);
    }

    return [permissionAllowedDict copy];
}


#pragma mark - Permissions observers

#pragma mark Add Observers

- (SDLPermissionObserverIdentifier)addObserverForRPCs:(NSArray<SDLPermissionRPCName> *)rpcNames groupType:(SDLPermissionGroupType)groupType withHandler:(nonnull SDLPermissionsChangedHandler)handler {
    SDLPermissionFilter *filter = [SDLPermissionFilter filterWithRPCNames:rpcNames groupType:groupType observer:handler];

    // Store the filter for later use
    [self.filters addObject:filter];

    // If there are permissions that fit the specifications, send immediately. Then return the identifier.
    [self sdl_callFilterObserver:filter];

    return filter.identifier;
}

- (void)sdl_callFilterObserver:(SDLPermissionFilter *)filter {
    SDLPermissionGroupStatus permissionStatus = [self groupStatusOfRPCs:filter.rpcNames];
    NSDictionary<SDLPermissionRPCName, NSNumber<SDLBool> *> *allowedDict = [self statusOfRPCs:filter.rpcNames];

    filter.handler(allowedDict, permissionStatus);
}

#pragma mark Remove Observers

- (void)removeAllObservers {
    [self.filters removeAllObjects];
}

- (void)removeObserverForIdentifier:(SDLPermissionObserverIdentifier)identifier {
    NSArray<SDLPermissionFilter *> *filters = [self.filters copy];
    for (NSUInteger i = 0; i < filters.count; i++) {
        SDLPermissionFilter *filter = filters[i];

        if ([filter.identifier isEqual:identifier]) {
            [self.filters removeObjectAtIndex:i];
            break;
        }
    }
}


#pragma mark - SDL Notification Observers

- (void)sdl_permissionsDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnPermissionsChange class]]) {
        return;
    }

    SDLOnPermissionsChange *onPermissionChange = notification.notification;
    NSArray<SDLPermissionItem *> *newPermissionItems = [onPermissionChange.permissionItem copy];
    NSArray<SDLPermissionFilter *> *currentFilters = [self.filters copy];

    // We can eliminate calling those filters who had no permission changes, so we'll filter down and see which had permissions that changed
    NSArray<SDLPermissionFilter *> *modifiedFilters = [self.class sdl_filterPermissionChangesForFilters:currentFilters updatedPermissions:newPermissionItems];

    // We need the old group status and new group status for all allowed filters so we know if they should be called
    NSDictionary<SDLPermissionObserverIdentifier, NSNumber<SDLInt> *> *allAllowedFiltersWithOldStatus = [self sdl_currentStatusForFilters:modifiedFilters];

    // Set the updated permissions on our stored permissions object
    for (SDLPermissionItem *item in newPermissionItems) {
        self.permissions[item.rpcName] = item;
    }

    // Check if the observer should be called based on the group type
    NSMutableArray<SDLPermissionFilter *> *filtersToCall = [NSMutableArray array];
    for (SDLPermissionFilter *filter in modifiedFilters) {
        if (filter.groupType == SDLPermissionGroupTypeAllAllowed) {
            SDLPermissionGroupStatus oldStatus = [allAllowedFiltersWithOldStatus[filter.identifier] unsignedIntegerValue];
            SDLPermissionGroupStatus newStatus = [self groupStatusOfRPCs:filter.rpcNames];

            // We've already eliminated the case where the permissions could stay the same, so if the permissions changed *to* allowed or *away* from allowed, we need to call the observer.
            if (newStatus == SDLPermissionGroupStatusAllowed || oldStatus == SDLPermissionGroupStatusAllowed) {
                [filtersToCall addObject:filter];
            }
        } else {
            // The filter is an `any` type and we know it changed, so we'll call it
            [filtersToCall addObject:filter];
        }
    }

    // For all the modified filters we care about, call them
    for (SDLPermissionFilter *filter in filtersToCall) {
        [self sdl_callFilterObserver:filter];
    }
}

- (void)sdl_hmiLevelDidChange:(SDLRPCNotificationNotification *)notification {
    if (![notification isNotificationMemberOfClass:[SDLOnHMIStatus class]]) {
        return;
    }

    SDLOnHMIStatus *hmiStatus = notification.notification;

    SDLHMILevel oldHMILevel = [self.currentHMILevel copy];
    self.currentHMILevel = hmiStatus.hmiLevel;
    NSArray<SDLPermissionFilter *> *filters = [self.filters copy];


    NSMutableArray<SDLPermissionFilter *> *mutableFiltersToCall = [NSMutableArray arrayWithCapacity:filters.count];
    for (SDLPermissionFilter *filter in filters) {
        // Check if the filter changed, according to its group type settings.
        BOOL filterChanged = [self sdl_didFilterChange:filter fromHMILevel:oldHMILevel toHMILevel:self.currentHMILevel];

        if (filterChanged) {
            [mutableFiltersToCall addObject:filter];
        }
    }

    NSArray<SDLPermissionFilter *> *filtersToCall = [mutableFiltersToCall copy];

    // For all the modified filters, call if necessary
    for (SDLPermissionFilter *filter in filtersToCall) {
        [self sdl_callFilterObserver:filter];
    }
}


#pragma mark Helper Methods

/**
 *  Determine if a filter changes based on an HMI level change and the filter's group type settings. This will run through the filter's RPCs, check the permission for each and see if any permission within the filter changes based on some permission now being allowed when it wasn't, or not allowed when it was. This also takes into account the group type setting, so an All Allowed filter will return YES if and only if some permission changed *and* that causes a status change *to* or *from* Allowed.
 *
 *  @param filter      The filter to check
 *  @param oldHMILevel The old HMI level
 *  @param newHMILevel The new HMI level
 *
 *  @return Whether or not the filter changed based on the difference in HMI levels.
 */
- (BOOL)sdl_didFilterChange:(SDLPermissionFilter *)filter fromHMILevel:(SDLHMILevel)oldHMILevel toHMILevel:(SDLHMILevel)newHMILevel {
    BOOL changed = NO;
    for (NSString *rpcName in filter.rpcNames) {
        SDLPermissionItem *item = self.permissions[rpcName];
        BOOL newAllowed = [item.hmiPermissions.allowed containsObject:self.currentHMILevel];
        BOOL oldAllowed = [item.hmiPermissions.allowed containsObject:oldHMILevel];

        if ((newAllowed && !oldAllowed) || (!newAllowed && oldAllowed)) {
            // Now permitted when it was not before, or not permitted when it was before
            if (filter.groupType == SDLPermissionGroupTypeAny) {
                return YES;
            } else {
                changed = YES;
                break;
            }
        }
    }

    // This is only for the All Allowed group type. Unlike with the Any group type, we need to know if the group status has changed
    if (changed) {
        SDLPermissionGroupStatus oldStatus = [self.class sdl_groupStatusOfRPCs:filter.rpcNames withPermissions:self.permissions hmiLevel:oldHMILevel];
        SDLPermissionGroupStatus newStatus = [self.class sdl_groupStatusOfRPCs:filter.rpcNames withPermissions:self.permissions hmiLevel:newHMILevel];

        // We've already eliminated the case where the permissions could stay the same, so if the permissions changed *to* allowed or *away* from allowed, we need to call the observer.
        if (newStatus == SDLPermissionGroupStatusAllowed || oldStatus == SDLPermissionGroupStatusAllowed) {
            return YES;
        }
    }

    return NO;
}

/**
 *  Get a dictionary of the current group status for filters passed in.
 *
 *  @param filters The filters to check
 *
 *  @return A dictionary of filters as the keys and an NSNumber wrapper for the SDLPermissionGroupStatus
 */
- (NSDictionary<NSUUID *, NSNumber<SDLInt> *> *)sdl_currentStatusForFilters:(NSArray<SDLPermissionFilter *> *)filters {
    // Create a dictionary that has the all allowed filters and stores their group status for future reference
    NSMutableDictionary<SDLPermissionFilter *, NSNumber<SDLInt> *> *filtersWithStatus = [NSMutableDictionary dictionary];
    for (SDLPermissionFilter *filter in filters) {
        if (filter.groupType == SDLPermissionGroupTypeAllAllowed) {
            filtersWithStatus[filter.identifier] = @([self groupStatusOfRPCs:filter.rpcNames]);
        }
    }

    return [filtersWithStatus copy];
}

/**
 *  Takes a set of filters and a set of updated permission items. Loops through each permission for each filter and determines if the filter contains a permission that was updated. Returns the set of filters  that contain an updated permission.
 *
 *  @param filters         The set of filters to check
 *  @param permissionItems The set of updated permissions to test each filter against
 *
 *  @return An array of filters that contained one of the passed permissions
 */
+ (NSArray<SDLPermissionFilter *> *)sdl_filterPermissionChangesForFilters:(NSArray<SDLPermissionFilter *> *)filters updatedPermissions:(NSArray<SDLPermissionItem *> *)permissionItems {
    NSMutableArray<SDLPermissionFilter *> *modifiedFilters = [NSMutableArray arrayWithCapacity:filters.count];

    // Loop through each updated permission item for each filter, if the filter had something modified, store it and go to the next filter
    for (SDLPermissionFilter *filter in filters) {
        for (SDLPermissionItem *item in permissionItems) {
            if ([filter.rpcNames containsObject:item.rpcName]) {
                [modifiedFilters addObject:filter];
                break;
            }
        }
    }

    return [modifiedFilters copy];
}

@end

NS_ASSUME_NONNULL_END
