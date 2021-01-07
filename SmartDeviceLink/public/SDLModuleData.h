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
#import "SDLModuleType.h"

@class SDLRadioControlData;
@class SDLClimateControlData;
@class SDLSeatControlData;
@class SDLAudioControlData;
@class SDLHMISettingsControlData;
@class SDLLightControlData;


NS_ASSUME_NONNULL_BEGIN

/**
 * The moduleType indicates which type of data should be changed and identifies which data object exists in this struct. For example, if the moduleType is CLIMATE then a "climateControlData" should exist
 *
 * @added in SmartDeviceLink 4.5.0
 */
@interface SDLModuleData : SDLRPCStruct

/**
 * @param moduleType - moduleType
 * @return A SDLModuleData object
 */
- (instancetype)initWithModuleType:(SDLModuleType)moduleType;

/**
 * @param moduleType - moduleType
 * @param moduleId - moduleId
 * @param radioControlData - radioControlData
 * @param climateControlData - climateControlData
 * @param seatControlData - seatControlData
 * @param audioControlData - audioControlData
 * @param lightControlData - lightControlData
 * @param hmiSettingsControlData - hmiSettingsControlData
 * @return A SDLModuleData object
 */
- (instancetype)initWithModuleType:(SDLModuleType)moduleType moduleId:(nullable NSString *)moduleId radioControlData:(nullable SDLRadioControlData *)radioControlData climateControlData:(nullable SDLClimateControlData *)climateControlData seatControlData:(nullable SDLSeatControlData *)seatControlData audioControlData:(nullable SDLAudioControlData *)audioControlData lightControlData:(nullable SDLLightControlData *)lightControlData hmiSettingsControlData:(nullable SDLHMISettingsControlData *)hmiSettingsControlData;

/**
 Constructs a newly allocated SDLModuleData object with radio control data

 @param radioControlData The radio control data
 @return An instance of the SDLModuleData class
 */
- (instancetype)initWithRadioControlData:(SDLRadioControlData *)radioControlData;

/**
 Constructs a newly allocated SDLModuleData object with climate control data

 @param climateControlData The climate control data
 @return An instance of the SDLModuleData class
 */
- (instancetype)initWithClimateControlData:(SDLClimateControlData *)climateControlData;

/**
 Constructs a newly allocated SDLModuleData object with audio control data
 
 @param audioControlData The audio control data
 @return An instance of the SDLModuleData class
 */
- (instancetype)initWithAudioControlData:(SDLAudioControlData *)audioControlData;

/**
 Constructs a newly allocated SDLModuleData object with light control data
 
 @param lightControlData The light control data
 @return An instance of the SDLModuleData class
 */
- (instancetype)initWithLightControlData:(SDLLightControlData *)lightControlData;

/**
 Constructs a newly allocated SDLModuleData object with hmi settings data
 
 @param hmiSettingsControlData The hmi settings data
 @return An instance of the SDLModuleData class
 */
- (instancetype)initWithHMISettingsControlData:(SDLHMISettingsControlData *)hmiSettingsControlData;

/**
 Constructs a newly allocated SDLModuleData object with seat control data

 @param seatControlData The seat control data
 @return An instance of the SDLModuleData class
 */
- (instancetype)initWithSeatControlData:(SDLSeatControlData *)seatControlData;

/**
 The moduleType indicates which type of data should be changed and identifies which data object exists in this struct.

 For example, if the moduleType is CLIMATE then a "climateControlData" should exist

 Required
 */
@property (strong, nonatomic) SDLModuleType moduleType;

/**
 Id of a module, published by System Capability.
 
 Optional
 */
@property (nullable, strong, nonatomic) NSString *moduleId;

/**
 The radio control data

 Optional
 */
@property (nullable, strong, nonatomic) SDLRadioControlData *radioControlData;

/**
 The climate control data

 Optional
 */
@property (nullable, strong, nonatomic) SDLClimateControlData *climateControlData;

/**
 The seat control data

 Optional
 */
@property (nullable, strong, nonatomic) SDLSeatControlData *seatControlData;

/**
 The audio control data
 
 Optional
 */
@property (nullable, strong, nonatomic) SDLAudioControlData *audioControlData;

/**
 The light control data
 
 Optional
 */
@property (nullable, strong, nonatomic) SDLLightControlData *lightControlData;

/**
 The hmi control data
 
 Optional
 */
@property (nullable, strong, nonatomic) SDLHMISettingsControlData *hmiSettingsControlData;

@end

NS_ASSUME_NONNULL_END
