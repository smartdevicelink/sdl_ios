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
 An enum representing values of the tire pressure monitoring system

 @added in SmartDeviceLink 5.0.0
 */
typedef SDLEnum SDLTPMS NS_TYPED_ENUM;

/**
 If set the status of the tire is not known.
 */
extern SDLTPMS const SDLTPMSUnknown;

/**
 TPMS does not function.
 */
extern SDLTPMS const SDLTPMSSystemFault;

/**
 The sensor of the tire does not function.
 */
extern SDLTPMS const SDLTPMSSensorFault;

/**
 TPMS is reporting a low tire pressure for the tire.
 */
extern SDLTPMS const SDLTPMSLow;

/**
 TPMS is active and the tire pressure is monitored.
 */
extern SDLTPMS const SDLTPMSSystemActive;

/**
 TPMS is reporting that the tire must be trained.
 */
extern SDLTPMS const SDLTPMSTrain;

/**
 TPMS reports the training for the tire is completed.
 */
extern SDLTPMS const SDLTPMSTrainingComplete;

/**
 TPMS reports the tire is not trained.
 */
extern SDLTPMS const SDLTPMSNotTrained;
