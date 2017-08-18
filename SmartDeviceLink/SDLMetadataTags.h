//
//  SDLMetadataTags.h
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"

@class SDLMetadataType;

@interface SDLMetadataTags : SDLRPCStruct {
}

/**
 * @abstract Constructs a newly allocated SDLMetadataTags object
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLMetadataTags object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use to construct the object
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract Constructs a newly allocated SDLMetadataTags object with NSArrays
 */
- (instancetype)initWithTextFieldTypes:(NSArray<SDLMetadataType *> *)mainField1 mainField2:(NSArray<SDLMetadataType *> *)mainField2;

- (instancetype)initWithTextFieldTypes:(NSArray<SDLMetadataType *> *)mainField1 mainField2:(NSArray<SDLMetadataType *> *)mainField2 mainField3:(NSArray<SDLMetadataType *> *)mainField3 mainField4:(NSArray<SDLMetadataType *> *)mainField4;

/**
 * @abstract The type of data contained in the "mainField1" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (strong, nonatomic) NSMutableArray<SDLMetadataType *> *mainField1;

/**
 * @abstract The type of data contained in the "mainField2" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (strong, nonatomic) NSMutableArray<SDLMetadataType *> *mainField2;

/**
 * @abstract The type of data contained in the "mainField3" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (strong, nonatomic) NSMutableArray<SDLMetadataType *> *mainField3;

/**
 * @abstract The type of data contained in the "mainField4" text field, Optional.
 *
 * minsize= 0
 *
 * maxsize= 5
 */
@property (strong, nonatomic) NSMutableArray<SDLMetadataType *> *mainField4;

@end
