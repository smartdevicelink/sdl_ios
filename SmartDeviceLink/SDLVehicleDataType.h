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
 * Defines the vehicle data types that can be published and/or subscribed to using SDLSubscribeVehicleData. Used in VehicleDataResult
 */
typedef SDLEnum SDLVehicleDataType SDL_SWIFT_ENUM;

/**
 GPS vehicle data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeGPS;

/**
 Vehicle speed data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeSpeed;

/**
 Vehicle RPM data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeRPM;

/**
 Vehicle fuel level data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelLevel;

/**
 Vehicle fuel level state data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelLevelState;

/**
 Vehicle fuel consumption data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelConsumption;

/**
 Vehicle external temperature data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeExternalTemperature;

/**
 Vehicle VIN data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVIN;

/**
 Vehicle PRNDL data
 */
extern SDLVehicleDataType const SDLVehicleDataTypePRNDL;

/**
 Vehicle tire pressure data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeTirePressure;

/**
 Vehicle odometer data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeOdometer;

/**
 Vehicle belt status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBeltStatus;

/**
 Vehicle body info data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBodyInfo;

/**
 Vehicle device status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeDeviceStatus;

/**
 Vehicle emergency call info data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeECallInfo;

/**
 Vehicle fuel range data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeFuelRange;

/**
 Vehicle airbag status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeAirbagStatus;

/**
 Vehicle emergency event info
 */
extern SDLVehicleDataType const SDLVehicleDataTypeEmergencyEvent;

/**
 Vehicle cluster mode status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeClusterModeStatus;

/**
 Vehicle MyKey data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeMyKey;

/**
 Vehicle braking data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBraking;

/**
 Vehicle wiper status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeWiperStatus;

/**
 Vehicle headlamp status
 */
extern SDLVehicleDataType const SDLVehicleDataTypeHeadlampStatus;

/**
 Vehicle battery voltage data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeBatteryVoltage;

/**
 Vehicle engine oil life data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeEngineOilLife;

/**
 Vehicle engine torque data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeEngineTorque;

/**
 Vehicle accleration pedal data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeAccelerationPedal;

/**
 Vehicle steering wheel data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeSteeringWheel;

/**
 Vehicle electronic parking brake status data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeElectronicParkBrakeStatus;

/**
 Vehicle turn signal data
 */
extern SDLVehicleDataType const SDLVehicleDataTypeTurnSignal;

/**
 The cloud application vehicle id. Used by cloud apps to identify a head unit
 */
extern SDLVehicleDataType const SDLVehicleDataTypeCloudAppVehicleID;

/**
 Custom OEM Vehicle data
 
 Added in SDL 6.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeOEMVehicleDataType;

/**
 * To indicate whether driver hands are off the steering wheel
 * @since SDL 6.2.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataHandsoffsteering;
