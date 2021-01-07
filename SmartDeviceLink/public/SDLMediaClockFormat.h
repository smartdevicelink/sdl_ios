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
 Indicates the format of the time displayed on the connected SDL unit.

 Format description follows the following nomenclature: <br>
 Sp = Space <br>
 | = or <br>
 c = character <br>

 Used in DisplayCapabilities

 @since SDL 1.0
 */
typedef SDLEnum SDLMediaClockFormat NS_TYPED_ENUM;

/**
 * Media clock format: Clock1
 *
 * maxHours = 19
 * maxMinutes = 59
 * maxSeconds = 59
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClock1;

/**
 * Media clock format: Clock2
 *
 * maxHours = 59
 * maxMinutes = 59
 * maxSeconds = 59
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClock2;

/**
 * Media clock format: Clock3
 *
 * @discussion
 * <ul>
 * maxHours = 9
 * maxMinutes = 59
 * maxSeconds = 59
 * </ul>
 *
 * @since SDL 2.0
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClock3;

/**
 * Media clock format: ClockText1
 *
 * @discussion
 * <ul>
 * 5 characters possible
 * Format: 1|sp c :|sp c c
 * 1|sp : digit "1" or space
 * c : character out of following character set: sp|0-9|[letters, see
 * TypeII column in XLS.
 * :|sp : colon or space
 * used for Type II headunit
 * </ul>
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText1;

/**
 * Media clock format: ClockText2
 *
 * @discussion
 * <ul>
 * 5 characters possible
 * Format: 1|sp c :|sp c c
 * 1|sp : digit "1" or space
 * c : character out of following character set: sp|0-9|[letters, see
 * CID column in XLS.
 * :|sp : colon or space
 * used for CID headunit
 * </ul>
 * difference between CLOCKTEXT1 and CLOCKTEXT2 is the supported character
 * set
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText2;

/**
 * Media clock format: ClockText3
 *
 * @discussion
 * <ul>
 * 6 chars possible
 * Format: 1|sp c c :|sp c c
 * 1|sp : digit "1" or space
 * c : character out of following character set: sp|0-9|[letters, see
 * Type 5 column in XLS].
 * :|sp : colon or space
 * used for Type V headunit
 * </ul>
 * difference between CLOCKTEXT1 and CLOCKTEXT2 is the supported character
 * set
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText3;

/**
 * Media clock format: ClockText4
 *
 * 6 chars possible
 * Format:      c   :|sp   c   c   :   c   c
 * :|sp : colon or space
 * c    : character out of following character set: sp|0-9|[letters] used for MFD3/4/5 headunits
 *
 * @since SDL 2.0
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText4;
