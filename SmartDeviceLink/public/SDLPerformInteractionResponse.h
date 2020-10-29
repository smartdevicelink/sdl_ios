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


#import "SDLRPCResponse.h"

#import "SDLTriggerSource.h"

NS_ASSUME_NONNULL_BEGIN

/**
 PerformInteraction Response is sent, when SDLPerformInteraction has been called

 @since SDL 1.0
 */
@interface SDLPerformInteractionResponse : SDLRPCResponse

/**
 * @param choiceID - choiceID
 * @param manualTextEntry - manualTextEntry
 * @param triggerSource - triggerSource
 * @return A SDLPerformInteractionResponse object
 */
- (instancetype)initWithChoiceID:(nullable NSNumber<SDLUInt> *)choiceID manualTextEntry:(nullable NSString *)manualTextEntry triggerSource:(nullable SDLTriggerSource)triggerSource;

/**
 ID of the choice that was selected in response to PerformInteraction. Only is valid if general result is "success:true".

 Optional, Integer, 0 - 2,000,000,000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *choiceID;

/**
 Manually entered text selection, e.g. through keyboard. Can be returned in lieu of choiceID, depending on the trigger source.

 Optional, Max length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *manualTextEntry;

/**
 A *SDLTriggerSource* object which will be shown in the HMI. Only is valid if resultCode is SUCCESS.
 */
@property (nullable, strong, nonatomic) SDLTriggerSource triggerSource;


@end

NS_ASSUME_NONNULL_END
