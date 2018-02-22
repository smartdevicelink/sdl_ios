//
//  SDLTextAndGraphicConfiguration.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 2/22/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLMetadataType.h"
#import "SDLTextAlignment.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTextAndGraphicConfiguration : NSObject

@property (copy, nonatomic) SDLTextAlignment alignment;
@property (copy, nonatomic, nullable) SDLMetadataType textField1Type;
@property (copy, nonatomic, nullable) SDLMetadataType textField2Type;
@property (copy, nonatomic, nullable) SDLMetadataType textField3Type;
@property (copy, nonatomic, nullable) SDLMetadataType textField4Type;

/**
 Create a default configuration. The alignment defaults to SDLTextAlignmentCenter. The Metadata types default to nil.

 @return A new configuration
 */
- (instancetype)init;

/**
 Create metadata tags describing the four text fields sent via `updateTextField1:textField2:textField3:textField4:`. These tags may be used by the system to present data elsewhere, for example, presenting the artist and song, or weather data, in another context than strictly your apps's.

 If the system does not support a full 4 fields, this will automatically be concatenated and properly describe the fields sent.

 If some fields describe your context and not others, pass an empty array for any you do not wish to describe. If no fields describe your context, do not call this method, as `SDLMetadataTypeNone` is the default. If you feel your context should be described, but none of the current metadata tags apply, contact us at http://slack.smartdevicelink.com/

 @param field1Type The metadata description of field 1
 @param field2Type The metadata description of field 2
 @param field3Type The metadata description of field 3
 @param field4Type The metadata description of field 4
 @param alignment The alignment of the text fields, if supported
 @return The configuration to feed to the SDLTextAndImageManager
 */
- (instancetype)initWithTextField1:(nullable SDLMetadataType)field1Type textField2:(nullable SDLMetadataType)field2Type textField3:(nullable SDLMetadataType)field3Type textField4:(nullable SDLMetadataType)field4Type alignment:(nullable SDLTextAlignment)alignment;

+ (instancetype)defaultConfiguration NS_SWIFT_UNAVAILABLE("Use the ordinary initializer");

@end

NS_ASSUME_NONNULL_END
