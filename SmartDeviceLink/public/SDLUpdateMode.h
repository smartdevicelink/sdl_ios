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
 * Specifies what function should be performed on the media clock/counter. Used in SetMediaClockTimer.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLUpdateMode NS_TYPED_ENUM;

/**
 * Starts the media clock timer counting upward, in increments of 1 second.
 */
extern SDLUpdateMode const SDLUpdateModeCountUp;

/**
 * Starts the media clock timer counting downward, in increments of 1 second.
 */
extern SDLUpdateMode const SDLUpdateModeCountDown;

/**
 * Pauses the media clock timer.
 */
extern SDLUpdateMode const SDLUpdateModePause;

/**
 * Resumes the media clock timer. The timer resumes counting in whatever mode was in effect before pausing (i.e. COUNTUP or COUNTDOWN).
 */
extern SDLUpdateMode const SDLUpdateModeResume;

/**
 * Clear the media clock timer.
 */
extern SDLUpdateMode const SDLUpdateModeClear;
