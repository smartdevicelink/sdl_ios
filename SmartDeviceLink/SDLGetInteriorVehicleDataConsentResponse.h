//
//  SDLGetInteriorVehicleDataConsentResponse.h
//  SmartDeviceLink
//
//  Created by standa1 on 7/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLGetInteriorVehicleDataConsentResponse : SDLRPCResponse

/**
 This array has the same size as "moduleIds" in the request; each element corresponding to one moduleId
 "true" - if SDL grants the permission for the requested module
 "false" - SDL denies the permission for the requested module.
 
 Optional
 */
@property (strong, nonatomic, nullable) NSArray<NSNumber<SDLBool> *> *allowed;

@end

NS_ASSUME_NONNULL_END
