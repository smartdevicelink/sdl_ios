/*
 * Copyright (c) 2020, SmartDeviceLink Consortium, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided with the
 * distribution.
 *
 * Neither the name of the SmartDeviceLink Consortium Inc. nor the names of
 * its contributors may be used to endorse or promote products derived
 * from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

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
