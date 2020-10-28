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

#import "SDLRPCMessage.h"

@class SDLDateTime;
@class SDLLocationDetails;
@class SDLNavigationInstruction;

NS_ASSUME_NONNULL_BEGIN

/**
 *  This data is related to what a navigation service would provide.
 */
@interface SDLNavigationServiceData : SDLRPCStruct

/**
 * @param timeStamp - timeStamp
 * @return A SDLNavigationServiceData object
 */
- (instancetype)initWithTimeStamp:(SDLDateTime *)timeStamp;

/**
 * @param timeStamp - timeStamp
 * @param origin - origin
 * @param destination - destination
 * @param destinationETA - destinationETA
 * @param instructions - instructions
 * @param nextInstructionETA - nextInstructionETA
 * @param nextInstructionDistance - nextInstructionDistance
 * @param nextInstructionDistanceScale - nextInstructionDistanceScale
 * @param prompt - prompt
 * @return A SDLNavigationServiceData object
 */
- (instancetype)initWithTimeStamp:(SDLDateTime *)timeStamp origin:(nullable SDLLocationDetails *)origin destination:(nullable SDLLocationDetails *)destination destinationETA:(nullable SDLDateTime *)destinationETA instructions:(nullable NSArray<SDLNavigationInstruction *> *)instructions nextInstructionETA:(nullable SDLDateTime *)nextInstructionETA nextInstructionDistance:(nullable NSNumber<SDLFloat> *)nextInstructionDistance nextInstructionDistanceScale:(nullable NSNumber<SDLFloat> *)nextInstructionDistanceScale prompt:(nullable NSString *)prompt;

/**
 *  Convenience init for required parameters.
 *
 *  @param timestamp    Timestamp of when the data was generated
 *  @return             A SDLNavigationServiceData object
 */
- (instancetype)initWithTimestamp:(SDLDateTime *)timestamp __deprecated_msg("Use initWithTimeStamp: instead");

/**
 *  Convenience init for all parameters.
 *
 *  @param timestamp 	                Timestamp of when the data was generated
 *  @param origin                       The start location
 *  @param destination                  The final destination location
 *  @param destinationETA               The estimated time of arrival at the final destination location
 *  @param instructions                 Array ordered with all remaining instructions
 *  @param nextInstructionETA           The estimated time of arrival at the next destination
 *  @param nextInstructionDistance      The distance to this instruction from current location
 *  @param nextInstructionDistanceScale Distance till next maneuver (starting from) from previous maneuver
 *  @param prompt                       This is a prompt message that should be conveyed to the user through either display or voice (TTS)
 *  @return                             A SDLNavigationServiceData object
 */
- (instancetype)initWithTimestamp:(SDLDateTime *)timestamp origin:(nullable SDLLocationDetails *)origin destination:(nullable SDLLocationDetails *)destination destinationETA:(nullable SDLDateTime *)destinationETA instructions:(nullable NSArray<SDLNavigationInstruction *> *)instructions nextInstructionETA:(nullable SDLDateTime *)nextInstructionETA nextInstructionDistance:(float)nextInstructionDistance nextInstructionDistanceScale:(float)nextInstructionDistanceScale prompt:(nullable NSString *)prompt __deprecated_msg("Use initWithTimeStamp:origin:destination:destinationETA:instructions:nextInstructionETA:nextInstructionDistance:nextInstructionDistanceScale:prompt: instead");

/**
 * This is the timestamp of when the data was generated. This is to ensure any time or distance given in the data can accurately be adjusted if necessary.
 */
@property (strong, nonatomic) SDLDateTime *timeStamp;

/**
 *  This is the timestamp of when the data was generated. This is to ensure any time or distance given in the data can accurately be adjusted if necessary.
 *
 *  SDLDateTime, Required
 */
@property (strong, nonatomic) SDLDateTime *timestamp __deprecated_msg("Use timeStamp instead");

/**
 *  The start location.
 *
 *  SDLLocationDetails, Optional
 */
@property (nullable, strong, nonatomic) SDLLocationDetails *origin;

/**
 *  The final destination location.
 *
 *  SDLLocationDetails, Optional
 */
@property (nullable, strong, nonatomic) SDLLocationDetails *destination;

/**
 *  The estimated time of arrival at the final destination location.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *destinationETA;

/**
 *  This array should be ordered with all remaining instructions. The start of this array should always contain the next instruction.
 *
 *  Array of SDLNavigationInstruction, Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLNavigationInstruction *> *instructions;

/**
 *  The estimated time of arrival at the next destination.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *nextInstructionETA;

/**
 *  The distance to this instruction from current location. This should only be updated ever .1 unit of distance. For more accuracy the consumer can use the GPS location of itself and the next instruction.
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *nextInstructionDistance;

/**
 *  Distance till next maneuver (starting from) from previous maneuver.
 *
 *  Float, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLFloat> *nextInstructionDistanceScale;

/**
 *  This is a prompt message that should be conveyed to the user through either display or voice (TTS). This param will change often as it should represent the following: approaching instruction, post instruction, alerts that affect the current navigation session, etc.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *prompt;

@end

NS_ASSUME_NONNULL_END
