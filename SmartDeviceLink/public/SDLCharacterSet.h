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
 * The list of potential character sets
 *
 * @since SDL 1.0.0
 */
typedef SDLEnum SDLCharacterSet NS_TYPED_ENUM;

/**
 * @deprecated
 * @since SDL 7.0.0
 */
extern SDLCharacterSet const SDLCharacterSetType2 __deprecated_msg("Use Ascii, Iso88591, or Utf8 instead");

/**
 * @deprecated
 * @since SDL 7.0.0
 */
extern SDLCharacterSet const SDLCharacterSetType5 __deprecated_msg("Use Ascii, Iso88591, or Utf8 instead");

/**
 * @deprecated
 * @since SDL 7.0.0
 */
extern SDLCharacterSet const SDLCharacterSetCID1 __deprecated_msg("Use Ascii, Iso88591, or Utf8 instead");

/**
 * @deprecated
 * @since SDL 7.0.0
 */
extern SDLCharacterSet const SDLCharacterSetCID2 __deprecated_msg("Use Ascii, Iso88591, or Utf8 instead");

/**
 * ASCII as defined in https://en.wikipedia.org/wiki/ASCII as defined in codes 0-127. Non-printable characters such as tabs and back spaces are ignored.
 *
 * @since SDL 7.0.0
 */
extern SDLCharacterSet const SDLCharacterSetAscii;

/**
 * Latin-1, as defined in https://en.wikipedia.org/wiki/ISO/IEC_8859-1
 *
 * @since SDL 7.0.0
 */
extern SDLCharacterSet const SDLCharacterSetIso88591;

/**
 * The UTF-8 character set that uses variable bytes per code point. See https://en.wikipedia.org/wiki/UTF-8 for more details. This is the preferred character set.
 *
 * @since SDL 7.0.0
 */
extern SDLCharacterSet const SDLCharacterSetUtf8;
