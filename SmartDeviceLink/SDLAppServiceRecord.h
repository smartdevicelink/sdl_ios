//
//  SDLAppServiceRecord.h
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

@class SDLAppServiceManifest;


NS_ASSUME_NONNULL_BEGIN

/**
 *  This is the record of an app service publisher that the module has. It should contain the most up to date information including the service's active state.
 *
 *  @since RPC 5.1
 */
@interface SDLAppServiceRecord : SDLRPCStruct

/**
 *  Convenience init for all parameters.
 *
 *  @param serviceID            A unique ID tied to this specific service record
 *  @param serviceManifest      Manifest for the service that this record is for
 *  @param servicePublished     If true, the service is published and available. If false, the service has likely just been unpublished, and should be considered unavailable
 *  @param serviceActive        If true, the service is the active primary service of the supplied service type.
 *  @return                     A SDLAppServiceRecord object
 */
- (instancetype)initWithServiceID:(NSString *)serviceID serviceManifest:(SDLAppServiceManifest *)serviceManifest servicePublished:(BOOL)servicePublished serviceActive:(BOOL)serviceActive;

/**
 *  A unique ID tied to this specific service record. The ID is supplied by the module that services publish themselves.
 *
 *  String, Required
 */
@property (strong, nonatomic) NSString *serviceID;

/**
 *  Manifest for the service that this record is for.
 *
 *  SDLAppServiceManifest, Required
 */
@property (strong, nonatomic) SDLAppServiceManifest *serviceManifest;

/**
 *  If true, the service is published and available. If false, the service has likely just been unpublished, and should be considered unavailable.
 *
 *  Boolean, Required
 */
@property (strong, nonatomic) NSNumber<SDLBool> *servicePublished;

/**
 *  If true, the service is the active primary service of the supplied service type. It will receive all potential RPCs that are passed through to that service type. If false, it is not the primary service of the supplied type. See servicePublished for its availability.
 *
 *  Boolean, Required
 */
@property (strong, nonatomic) NSNumber<SDLBool> *serviceActive;

@end

NS_ASSUME_NONNULL_END
