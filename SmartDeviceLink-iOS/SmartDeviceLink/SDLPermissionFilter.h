//
//  SDLPermissionFilter.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/18/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLPermissionConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLPermissionFilter : NSObject <NSCopying>

@property (copy, nonatomic, readonly) SDLPermissionObserverIdentifier *identifier;
@property (copy, nonatomic, readonly) NSArray<SDLPermissionRPCName *> *rpcNames;
@property (assign, nonatomic, readonly) SDLPermissionGroupType groupType;
@property (copy, nonatomic, readonly) SDLPermissionObserver observer;

- (instancetype)initWithRPCNames:(NSArray<SDLPermissionRPCName *> *)rpcNames groupType:(SDLPermissionGroupType)groupType observer:(SDLPermissionObserver)observer NS_DESIGNATED_INITIALIZER;

+ (instancetype)filterWithRPCNames:(NSArray<SDLPermissionRPCName *> *)rpcNames groupType:(SDLPermissionGroupType)groupType observer:(SDLPermissionObserver)observer;

- (BOOL)isEqualToFilter:(SDLPermissionFilter *)otherFilter;

@end

NS_ASSUME_NONNULL_END
