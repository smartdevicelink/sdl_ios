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

#import "SDLRPCStruct.h"
#import "SDLSeatMemoryActionType.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * Specify the action to be performed.
 *
 * @added in SmartDeviceLink 5.0.0
 */
@interface SDLSeatMemoryAction : SDLRPCStruct

/**
 * @param idParam - @(idParam)
 * @param action - action
 * @return A SDLSeatMemoryAction object
 */
- (instancetype)initWithIdParam:(UInt8)idParam action:(SDLSeatMemoryActionType)action;

/**
 * @param idParam - @(idParam)
 * @param action - action
 * @param label - label
 * @return A SDLSeatMemoryAction object
 */
- (instancetype)initWithIdParam:(UInt8)idParam action:(SDLSeatMemoryActionType)action label:(nullable NSString *)label;

/**
 @abstract Constructs a newly allocated SDLSeatMemoryAction object with id, label (max length 100 chars) and action type

 @param id of the action to be performed
 @param action type of action to be performed
 @return A SDLSeatMemoryAction object
 */
- (instancetype)initWithId:(UInt8)id action:(SDLSeatMemoryActionType)action __deprecated_msg("Use initWithIdParam:action:");

/**
 @abstract Constructs a newly allocated SDLSeatMemoryAction object with id, label (max length 100 chars) and action type

 @param id of the action to be performed
 @param label of the action to be performed.
 @param action type of action to be performed
 @return A SDLSeatMemoryAction object
 */
- (instancetype)initWithId:(UInt8)id label:(nullable NSString*) label action:(SDLSeatMemoryActionType)action __deprecated_msg("Use initWithIdParam:action:label: instead");

/**
 * {"num_min_value": 1, "num_max_value": 10}
 */
@property (strong, nonatomic) NSNumber<SDLUInt> *idParam;

/**
 * @abstract id of the action to be performed.
 *
 * Required, MinValue- 0 MaxValue= 10
 */
@property (strong, nonatomic) NSNumber<SDLInt> *id __deprecated_msg("Use idParam instead");

/**
 * @abstract label of the action to be performed.
 *
 * Optional, Max length 100 chars
 */
@property (nullable, strong, nonatomic) NSString *label;

/**
 * @abstract type of action to be performed
 *
 * Required, @see SDLSeatMemoryActionType
 *
 */
@property (strong, nonatomic) SDLSeatMemoryActionType action;


@end

NS_ASSUME_NONNULL_END
