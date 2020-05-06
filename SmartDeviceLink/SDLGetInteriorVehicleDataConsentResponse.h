//
//  SDLGetInteriorVehicleDataConsentResponse.h
//  SmartDeviceLink
//
//  Created by standa1 on 7/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

NS_ASSUME_NONNULL_BEGIN

/// Response to GetInteriorVehicleDataConsent
///
/// @since RPC 6.0
@interface SDLGetInteriorVehicleDataConsentResponse : SDLRPCResponse

/**
 This array has the same size as "moduleIds" in the request; each element corresponding to one moduleId
 "true" - if SDL grants the permission for the requested module
 "false" - SDL denies the permission for the requested module.
 
 Optional, contains a boolean
 */
@property (strong, nonatomic, nullable) NSArray<NSNumber *> *allowed;

@end

NS_ASSUME_NONNULL_END
