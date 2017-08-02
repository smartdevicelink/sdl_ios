//
//  SDLMetadataStruct.h
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"

@class SDLTextFieldType;

// TODO: CHANGE FILE NAME
@interface SDLMetadataStruct : SDLRPCStruct {
}

/**
 * @abstract Constructs a newly allocated SDLTextField object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLTextField object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use to construct the object
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**ΩΩ
 * @abstract Constructs a newly alΩlocated SDLTextField object with NSArrays
 */
- (instancetype)initWithTextFieldTypes:(NSArray<SDLTextFieldType *> *)mainField1 mainField2:(NSArray<SDLTextFieldType *> *)mainField2 mainField3:(NSArray<SDLTextFieldType *> *)mainField3 mainField4:(NSArray<SDLTextFieldType *> *)mainField4;

/**
 * @abstract The type of data contained in the "mainField1" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (strong, nonatomic) NSMutableArray<SDLTextFieldType *> *mainField1;

/**
 * @abstract The type of data contained in the "mainField2" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (strong, nonatomic) NSMutableArray<SDLTextFieldType *> *mainField2;

/**
 * @abstract The type of data contained in the "mainField3" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (strong, nonatomic) NSMutableArray<SDLTextFieldType *> *mainField3;

/**
 * @abstract The type of data contained in the "mainField4" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (strong, nonatomic) NSMutableArray<SDLTextFieldType *> *mainField4;

@end
