//
//  SDLModuleInfo.h
//  SmartDeviceLink
//
//  Created by standa1 on 7/8/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"
#import "SDLGrid.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains information about a RC module.
 */
@interface SDLModuleInfo : SDLRPCStruct

/**
 * UUID of a module. "moduleId + moduleType" uniquely identify a module.
 *
 * Max string length 100 chars
 
 Required
 */
@property (nullable, strong, nonatomic) NSString *moduleId;

/**
 * Location of a module.
 * Optional
 */
@property (nullable, strong, nonatomic) SDLGrid *location;

/**
 * Service area of a module.
 * Optional
 */
@property (nullable, strong, nonatomic) SDLGrid *serviceArea;

/**
 * Allow multiple users/apps to access the module or not
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *allowMultipleAccess;


@end

NS_ASSUME_NONNULL_END
