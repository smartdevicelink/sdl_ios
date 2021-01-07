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
 * Contains information about TTS capabilities on the SDL platform. Used in RegisterAppInterfaceResponse, and TTSChunk.
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLSpeechCapabilities NS_TYPED_ENUM;

/**
 The SDL platform can speak text phrases.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesText;

/**
 The SDL platform can speak SAPI Phonemes.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesSAPIPhonemes;

/**
 The SDL platform can speak LHPlus Phonemes.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesLHPlusPhonemes;

/**
 The SDL platform can speak Prerecorded indicators and prompts.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesPrerecorded;

/**
 The SDL platform can speak Silence.
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesSilence;

/**
 The SDL platform can play a file
 */
extern SDLSpeechCapabilities const SDLSpeechCapabilitiesFile;
