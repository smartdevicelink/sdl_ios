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
 * The status of the windshield wipers. Used in retrieving vehicle data.
 *
 * @added in SmartDeviceLink 2.0.0
 */
typedef SDLEnum SDLWiperStatus NS_TYPED_ENUM;

/**
 * Wiper is off
 */
extern SDLWiperStatus const SDLWiperStatusOff;

/**
 * Wiper is off automatically
 */
extern SDLWiperStatus const SDLWiperStatusAutomaticOff;

/**
 * Wiper is moving but off
 */
extern SDLWiperStatus const SDLWiperStatusOffMoving;

/**
 * Wiper is off due to a manual interval
 */
extern SDLWiperStatus const SDLWiperStatusManualIntervalOff;

/**
 * Wiper is on due to a manual interval
 */
extern SDLWiperStatus const SDLWiperStatusManualIntervalOn;

/**
 * Wiper is on low manually
 */
extern SDLWiperStatus const SDLWiperStatusManualLow;

/**
 * Wiper is on high manually
 */
extern SDLWiperStatus const SDLWiperStatusManualHigh;

/**
 * Wiper is on for a single wipe manually
 */
extern SDLWiperStatus const SDLWiperStatusManualFlick;

/**
 * Wiper is in wash mode
 */
extern SDLWiperStatus const SDLWiperStatusWash;

/**
 * Wiper is on low automatically
 */
extern SDLWiperStatus const SDLWiperStatusAutomaticLow;

/**
 * Wiper is on high automatically
 */
extern SDLWiperStatus const SDLWiperStatusAutomaticHigh;

/**
 * Wiper is performing a courtesy wipe
 */
extern SDLWiperStatus const SDLWiperStatusCourtesyWipe;

/**
 * Wiper is on automatic adjust
 */
extern SDLWiperStatus const SDLWiperStatusAutomaticAdjust;

/**
 * Wiper is stalled
 */
extern SDLWiperStatus const SDLWiperStatusStalled;

/**
 * Wiper data is not available
 */
extern SDLWiperStatus const SDLWiperStatusNoDataExists;
