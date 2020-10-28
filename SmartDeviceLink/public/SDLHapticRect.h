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

#import <UIKit/UIKit.h>

#import "SDLRPCStruct.h"

@class SDLRectangle;

NS_ASSUME_NONNULL_BEGIN

/**
 Defines spatial for each user control object for video streaming application
 */
@interface SDLHapticRect : SDLRPCStruct

/**
 * @param idParam - @(idParam)
 * @param rect - rect
 * @return A SDLHapticRect object
 */
- (instancetype)initWithIdParam:(UInt32)idParam rect:(SDLRectangle *)rect;

/// Convenience init with all parameters
///
/// @param id A user control spatial identifier
/// @param rect The position of the haptic rectangle to be highlighted. The center of this rectangle will be "touched" when a press occurs
/// @return An SDLHapticRect object
- (instancetype)initWithId:(UInt32)id rect:(SDLRectangle *)rect __deprecated_msg("Use initWithIdParam:rect:");

/**
 * A user control spatial identifier
 * {"num_min_value": 0, "num_max_value": 2000000000}
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *idParam;

/**
 A user control spatial identifier

 Required, Integer, 0 - 2,000,000,000
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *id __deprecated_msg("Use idParam instead");

/**
 The position of the haptic rectangle to be highlighted. The center of this rectangle will be "touched" when a press occurs.

 Required
 */
@property (strong, nonatomic) SDLRectangle *rect;

@end

NS_ASSUME_NONNULL_END
