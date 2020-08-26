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

#import "SDLRPCStruct.h"
#import "SDLImageFieldName.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * @since SDL 7.0
 */
@interface SDLDynamicUpdateCapabilities : SDLRPCStruct

/**
 * @param supportedDynamicImageFieldNames - supportedDynamicImageFieldNames
 * @param supportsDynamicSubMenus - supportsDynamicSubMenus
 * @return A SDLDynamicUpdateCapabilities object
 */
- (instancetype)initWithSupportedDynamicImageFieldNames:(nullable NSArray<SDLImageFieldName> *)supportedDynamicImageFieldNames supportsDynamicSubMenus:(nullable NSNumber<SDLBool> *)supportsDynamicSubMenus;

/**
 * An array of ImageFieldName values for which the system supports sending OnFileUpdate notifications. If you send an Image struct for that image field with a name without having uploaded the image data using PutFile that matches that name, the system will request that you upload the data with PutFile at a later point when the HMI needs it. The HMI will then display the image in the appropriate field. If not sent, assume false.
 * {"array_min_size": 1, "array_max_size": null}
 */
@property (nullable, strong, nonatomic) NSArray<SDLImageFieldName> *supportedDynamicImageFieldNames;

/**
 * If true, the head unit supports dynamic sub-menus by sending OnUpdateSubMenu notifications. If true, you should not send AddCommands that attach to a parentID for an AddSubMenu until OnUpdateSubMenu is received with the menuID. At that point, you should send all AddCommands with a parentID that match the menuID. If not set, assume false.
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *supportsDynamicSubMenus;

@end

NS_ASSUME_NONNULL_END
