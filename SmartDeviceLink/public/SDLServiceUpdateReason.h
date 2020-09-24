//
//  SDLServiceUpdateReason.h
//  SmartDeviceLink
//
//  Created by Nicole on 1/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 *  Enumeration listing possible service update reasons.
 */
typedef SDLEnum SDLServiceUpdateReason NS_TYPED_ENUM;

/**
 *  The service has just been published with the module and once activated to the primary service of its type, it will be ready for possible consumption.
 */
extern SDLServiceUpdateReason const SDLServiceUpdateReasonPublished;

/**
 *  The service has just been published with the module and once activated to the primary service of its type, it will be ready for possible consumption.
 */
extern SDLServiceUpdateReason const SDLServiceUpdatePublished __deprecated_msg("Use SDLServiceUpdateReasonPublished instead");

/**
 *  The service has just been unpublished with the module and is no longer accessible.
 */
extern SDLServiceUpdateReason const SDLServiceUpdateReasonRemoved;

/**
 *  The service has just been unpublished with the module and is no longer accessible.
 */
extern SDLServiceUpdateReason const SDLServiceUpdateRemoved __deprecated_msg("Use SDLServiceUpdateReasonRemoved instead");

/**
 *  The service is activated as the primary service of this type. All requests dealing with this service type will be handled by this service.
 */
extern SDLServiceUpdateReason const SDLServiceUpdateReasonActivated;

/**
 *  The service is activated as the primary service of this type. All requests dealing with this service type will be handled by this service.
 */
extern SDLServiceUpdateReason const SDLServiceUpdateActivated __deprecated_msg("Use SDLServiceUpdateReasonActivated instead");

/**
 *  The service has been deactivated as the primary service of its type.
 */
extern SDLServiceUpdateReason const SDLServiceUpdateReasonDeactivated;

/**
 *  The service has been deactivated as the primary service of its type.
 */
extern SDLServiceUpdateReason const SDLServiceUpdateDeactivated __deprecated_msg("Use SDLServiceUpdateReasonDeactivated instead");

/**
 *  The service has updated its manifest. This could imply updated capabilities.
 */
extern SDLServiceUpdateReason const SDLServiceUpdateReasonManifestUpdate;

/**
 *  The service has updated its manifest. This could imply updated capabilities.
 */
extern SDLServiceUpdateReason const SDLServiceUpdateManifestUpdate __deprecated_msg("Use SDLServiceUpdateReasonManifestUpdate instead");
