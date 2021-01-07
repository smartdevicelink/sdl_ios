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


#import "SDLRPCRequest.h"

@class SDLChoice;

/**
 * Creates a Choice Set which can be used in subsequent *SDLPerformInteraction* Operations.
 *
 * HMILevel needs to be FULL, LIMITED or BACKGROUND
 *
 * Before a perform interaction is sent you MUST wait for the success from the CreateInteractionChoiceSet RPC.
 *
 * If you do not wait the system may not recognize the first utterance from the user.
 *
 * @since SDL 1.0
 *
 * @see SDLDeleteInteractionChoiceSet SDLPerformInteraction
 */
NS_ASSUME_NONNULL_BEGIN

@interface SDLCreateInteractionChoiceSet : SDLRPCRequest

/**
 * @param interactionChoiceSetID - @(interactionChoiceSetID)
 * @param choiceSet - choiceSet
 * @return A SDLCreateInteractionChoiceSet object
 */
- (instancetype)initWithInteractionChoiceSetID:(UInt32)interactionChoiceSetID choiceSet:(NSArray<SDLChoice *> *)choiceSet;

/// Convenience init for creating a choice set RPC
///
/// @param choiceId A unique ID that identifies the Choice Set
/// @param choiceSet Array of choices, which the user can select by menu or voice recognition
/// @return An SDLCreateInteractionChoiceSet object
- (instancetype)initWithId:(UInt32)choiceId choiceSet:(NSArray<SDLChoice *> *)choiceSet __deprecated_msg("Use initWithInteractionChoiceSetID:choiceSet: instead");

/**
 * A unique ID that identifies the Choice Set
 *
 * Required, Integer, 0 - 2,000,000,000
 */
@property (strong, nonatomic) NSNumber<SDLInt> *interactionChoiceSetID;

/**
 * Array of choices, which the user can select by menu or voice recognition
 *
 * Required, SDLChoice, Array size 1 - 100
 */
@property (strong, nonatomic) NSArray<SDLChoice *> *choiceSet;

@end

NS_ASSUME_NONNULL_END
