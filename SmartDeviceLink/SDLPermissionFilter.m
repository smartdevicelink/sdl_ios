//
//  SDLPermissionFilter.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/18/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLPermissionFilter.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLPermissionFilter

#pragma mark - Lifecycle

- (instancetype)initWithPermissions:(NSArray<SDLPermissionElement *> *)rpcNames groupType:(SDLPermissionGroupType)groupType permissionsHandler:(SDLPermissionsChangedHandler)observer {
    self = [super init];
    if (!self) {
        return nil;
    }

    _identifier = [NSUUID UUID];
    _permissionElements = rpcNames;
    _groupType = groupType;
    _handler = observer;

    return self;
}

- (instancetype)initWithPermissions:(NSArray<SDLPermissionElement *> *)rpcNames groupType:(SDLPermissionGroupType)groupType permissionStatusHandler:(SDLRPCPermissionStatusChangedHandler)permissionStatusHandler {
    self = [super init];
    if (!self) { return nil; }

    _identifier = [NSUUID UUID];
    _permissionElements = rpcNames;
    _groupType = groupType;
    _rpcPermissionStatusHandler = permissionStatusHandler;

    return self;
}

#pragma mark - Helpers

- (NSArray<SDLPermissionRPCName> *)rpcNamesFromPermissionElements:(NSArray<SDLPermissionElement *> *)permissionElements {
    NSMutableArray *rpcNames = [[NSMutableArray alloc] init];
    for (SDLPermissionElement *element in permissionElements) {
        [rpcNames addObject:element.rpcName];
    }

    return [rpcNames copy];
}


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLPermissionFilter *newFilter = [[self.class allocWithZone:zone] initWithPermissions:[_permissionElements copyWithZone:zone] groupType:_groupType permissionsHandler:[_handler copyWithZone:zone]];
    newFilter->_identifier = _identifier;
    newFilter->_rpcPermissionStatusHandler = _rpcPermissionStatusHandler;

    return newFilter;
}


#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if (object == self) {
        return YES;
    }

    if (![object isMemberOfClass:[self class]]) {
        return NO;
    }

    return [self isEqualToFilter:object];
}

- (BOOL)isEqualToFilter:(SDLPermissionFilter *)otherFilter {
    return [self.identifier isEqual:otherFilter.identifier];
}


#pragma mark - Description

- (NSString *)description {
    return [NSString stringWithFormat:@"Permission Filter Identifier: %@, group type: %@, RPCs: %@", self.identifier, @(self.groupType), self.permissionElements];
}

@end

NS_ASSUME_NONNULL_END
