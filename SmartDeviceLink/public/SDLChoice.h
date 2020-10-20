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

@class SDLImage;


/**
 * A choice is an option which a user can select either via the menu or via voice recognition (VR) during an application initiated interaction.
 *
 * Since RPC 1.0
 */
NS_ASSUME_NONNULL_BEGIN

@interface SDLChoice : SDLRPCStruct

/**
 * @param choiceID - @(choiceID)
 * @param menuName - menuName
 * @return A SDLChoice object
 */
- (instancetype)initWithChoiceID:(UInt16)choiceID menuName:(NSString *)menuName;

/**
 * @param choiceID - @(choiceID)
 * @param menuName - menuName
 * @param vrCommands - vrCommands
 * @param image - image
 * @param secondaryText - secondaryText
 * @param tertiaryText - tertiaryText
 * @param secondaryImage - secondaryImage
 * @return A SDLChoice object
 */
- (instancetype)initWithChoiceID:(UInt16)choiceID menuName:(NSString *)menuName vrCommands:(nullable NSArray<NSString *> *)vrCommands image:(nullable SDLImage *)image secondaryText:(nullable NSString *)secondaryText tertiaryText:(nullable NSString *)tertiaryText secondaryImage:(nullable SDLImage *)secondaryImage;

/**
Constructs a newly allocated SDLChangeRegistration object with the required parameters

@param choiceId the application-scoped identifier that uniquely identifies this choice
@param menuName text which appears in menu, representing this choice
@param vrCommands vr synonyms for this choice

@return An instance of the SDLChangeRegistration class.
*/
- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(nullable NSArray<NSString *> *)vrCommands __deprecated_msg("Use initWithChoiceID:menuName: instead");

/**
Constructs a newly allocated SDLChangeRegistration object with all parameters

@param choiceId the application-scoped identifier that uniquely identifies this choice
@param menuName text which appears in menu, representing this choice
@param vrCommands vr synonyms for this choice
@param image the image of the choice
@param secondaryText secondary text to display; e.g. address of POI in a search result entry
@param secondaryImage secondary image for choice
@param tertiaryText tertiary text to display; e.g. distance to POI for a search result entry

@return An instance of the SDLChangeRegistration class.
*/
- (instancetype)initWithId:(UInt16)choiceId menuName:(NSString *)menuName vrCommands:(nullable NSArray<NSString *> *)vrCommands image:(nullable SDLImage *)image secondaryText:(nullable NSString *)secondaryText secondaryImage:(nullable SDLImage *)secondaryImage tertiaryText:(nullable NSString *)tertiaryText __deprecated_msg("Use initWithChoiceID:menuName: instead");

/**
 * The application-scoped identifier that uniquely identifies this choice
 * 
 * Required, Integer 0 - 65535
 */
@property (strong, nonatomic) NSNumber<SDLInt> *choiceID;

/**
 * Text which appears in menu, representing this choice
 *
 * Required, Max string length 500 chars
 */
@property (strong, nonatomic) NSString *menuName;

/**
 * VR synonyms for this choice
 *
 * Optional, Array of Strings, Array length 1 - 100, Max String length 99 chars
 *
 * @discussion, VR commands are optional beginning with SDL Core v.5.0. They are required for previous versions.
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *vrCommands;

/**
 * The image of the choice
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLImage *image;

/**
 * Secondary text to display; e.g. address of POI in a search result entry
 *
 * Optional, Max String length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *secondaryText;

/**
 * Tertiary text to display; e.g. distance to POI for a search result entry
 *
 * Optional, Max String length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *tertiaryText;

/**
 * Secondary image for choice
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLImage *secondaryImage;

@end

NS_ASSUME_NONNULL_END
