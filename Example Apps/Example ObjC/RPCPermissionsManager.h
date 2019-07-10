//
//  RPCPermissionsManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 5/11/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@interface RPCPermissionsManager : NSObject

+ (void)setupPermissionsCallbacksWithManager:(SDLManager *)manager;
+ (BOOL)isDialNumberRPCAllowedWithManager:(SDLManager *)manager;

@end

NS_ASSUME_NONNULL_END
