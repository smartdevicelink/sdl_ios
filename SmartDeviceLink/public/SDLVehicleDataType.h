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
 * Defines the data types that can be published and subscribed to.
 *
 * @added in SmartDeviceLink 2.0.0
 */
typedef SDLEnum SDLVehicleDataType SDL_SWIFT_ENUM;
/**
 * Notifies GPSData may be subscribed
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataGps;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataSpeed;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataRpm;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataFuellevel;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataFuellevelState;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataFuelconsumption;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataExterntemp;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataVin;

/**
 * @added in SmartDeviceLink 7.0.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataGearstatus;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataPrndl;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataTirepressure;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataOdometer;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataBeltstatus;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataBodyinfo;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataDevicestatus;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataEcallinfo;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataAirbagstatus;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataEmergencyevent;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataClustermodestatus;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataMykey;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataBraking;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataWiperstatus;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataHeadlampstatus;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataBattvoltage;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataEnginetorque;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataAccpedal;

extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataSteeringwheel;

/**
 * @added in SmartDeviceLink 5.0.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataTurnsignal;

/**
 * @added in SmartDeviceLink 5.0.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataFuelrange;

/**
 * @added in SmartDeviceLink 5.0.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataEngineoillife;

/**
 * @added in SmartDeviceLink 5.0.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataElectronicparkbrakestatus;

/**
 * @added in SmartDeviceLink 5.1.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataCloudappvehicleid;

/**
 * @added in SmartDeviceLink 6.0.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataOemCustomData;

/**
 * @added in SmartDeviceLink 7.0.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataStabilitycontrolsstatus;

/**
 * @added in SmartDeviceLink 7.0.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataWindowstatus;

/**
 * @added in SmartDeviceLink 7.0.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataHandsoffsteering;

/**
 * @added in SmartDeviceLink 7.1.0
 */
extern SDLVehicleDataType const SDLVehicleDataTypeVehicledataSeatoccupancy;
