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
 The status of the car's power. Used in ClusterModeStatus.
 */
typedef SDLEnum SDLPowerModeStatus NS_TYPED_ENUM;

/**
 The key is not in the ignition, and the power is off
 */
extern SDLPowerModeStatus const SDLPowerModeStatusKeyOut;

/**
 The key is not in the ignition and it was just recently removed
 */
extern SDLPowerModeStatus const SDLPowerModeStatusKeyRecentlyOut;

/**
 The key is not in the ignition, but an approved key is available
 */
extern SDLPowerModeStatus const SDLPowerModeStatusKeyApproved;

/**
 We are in a post-accessory power situation
 */
extern SDLPowerModeStatus const SDLPowerModeStatusPostAccessory;

/**
 The car is in accessory power mode
 */
extern SDLPowerModeStatus const SDLPowerModeStatusAccessory;

/**
 We are in a post-ignition power situation
 */
extern SDLPowerModeStatus const SDLPowerModeStatusPostIgnition;

/**
 The ignition is on but the car is not yet running
 */
extern SDLPowerModeStatus const SDLPowerModeStatusIgnitionOn;

/**
 The ignition is on and the car is running
 */
extern SDLPowerModeStatus const SDLPowerModeStatusRunning;

/**
 We are in a crank power situation
 */
extern SDLPowerModeStatus const SDLPowerModeStatusCrank;
