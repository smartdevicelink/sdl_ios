//
//  SDLMetadataTags.h
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"
#import "SDLMetadataType.h"

NS_ASSUME_NONNULL_BEGIN

/// Metadata for Show fields
@interface SDLMetadataTags : SDLRPCStruct

/**
 Constructs a newly allocated SDLMetadataType object with NSArrays
 */
- (instancetype)initWithTextFieldTypes:(nullable NSArray<SDLMetadataType> *)mainField1 mainField2:(nullable NSArray<SDLMetadataType> *)mainField2;

/// Constructs a newly allocated SDLMetadataType with all parameters
- (instancetype)initWithTextFieldTypes:(nullable NSArray<SDLMetadataType> *)mainField1 mainField2:(nullable NSArray<SDLMetadataType> *)mainField2 mainField3:(nullable NSArray<SDLMetadataType> *)mainField3 mainField4:(nullable NSArray<SDLMetadataType> *)mainField4;

/**
 The type of data contained in the "mainField1" text field.

 minsize= 0, maxsize= 5

 Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLMetadataType> *mainField1;

/**
 The type of data contained in the "mainField2" text field.

 minsize= 0, maxsize= 5

 Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLMetadataType> *mainField2;

/**
 The type of data contained in the "mainField3" text field.

 minsize= 0, maxsize= 5

 Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLMetadataType> *mainField3;

/**
 The type of data contained in the "mainField4" text field.

 minsize= 0, maxsize= 5

 Optional
 */
@property (nullable, strong, nonatomic) NSArray<SDLMetadataType> *mainField4;

@end

NS_ASSUME_NONNULL_END
