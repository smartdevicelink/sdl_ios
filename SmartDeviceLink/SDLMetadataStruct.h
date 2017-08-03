//
//  SDLMetadataStruct.h
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"
#import "SDLTextFieldType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMetadataStruct : SDLRPCStruct

/**
 * @abstract Constructs a newly allocated SDLTextField object with NSArrays
 */
- (instancetype)initWithTextFieldTypes:(nullable NSArray<SDLTextFieldType> *)mainField1 mainField2:(nullable NSArray<SDLTextFieldType> *)mainField2;

- (instancetype)initWithTextFieldTypes:(nullable NSArray<SDLTextFieldType> *)mainField1 mainField2:(nullable NSArray<SDLTextFieldType> *)mainField2 mainField3:(nullable NSArray<SDLTextFieldType> *)mainField3 mainField4:(nullable NSArray<SDLTextFieldType> *)mainField4;

/**
 * @abstract The type of data contained in the "mainField1" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (nullable, strong, nonatomic) NSArray<SDLTextFieldType> *mainField1;

/**
 * @abstract The type of data contained in the "mainField2" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (nullable, strong, nonatomic) NSArray<SDLTextFieldType> *mainField2;

/**
 * @abstract The type of data contained in the "mainField3" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (nullable, strong, nonatomic) NSArray<SDLTextFieldType> *mainField3;

/**
 * @abstract The type of data contained in the "mainField4" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (nullable, strong, nonatomic) NSArray<SDLTextFieldType> *mainField4;

@end

NS_ASSUME_NONNULL_END
