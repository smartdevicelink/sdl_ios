//
//  SDLMetadataStruct.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLMetadataStruct.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMetadataStruct

- (instancetype)initWithTextFieldTypes:(nullable NSArray<SDLTextFieldType> *)mainField1 mainField2:(nullable NSArray<SDLTextFieldType> *)mainField2 {
    self = [self init];
    if (!self) {
        return self;
    }

    self.mainField1 = mainField1;
    self.mainField2 = mainField2;

    return self;
}

- (instancetype)initWithTextFieldTypes:(nullable NSArray<SDLTextFieldType> *)mainField1 mainField2:(nullable NSArray<SDLTextFieldType> *)mainField2 mainField3:(nullable NSArray<SDLTextFieldType> *)mainField3 mainField4:(nullable NSArray<SDLTextFieldType> *)mainField4 {
    self = [self init];
    if (!self) {
        return self;
    }

    self.mainField1 = mainField1;
    self.mainField2 = mainField2;
    self.mainField3 = mainField3;
    self.mainField4 = mainField4;

    return self;
}

- (void)setMainField1:(nullable NSArray<SDLTextFieldType> *)mainField1 {
    [store sdl_setObject:mainField1 forName:SDLNameMainField1Type];
}

- (nullable NSArray<SDLTextFieldType> *)mainField1 {
    return [store sdl_objectForName:SDLNameMainField1Type];
}

- (void)setMainField2:(nullable NSArray<SDLTextFieldType> *)mainField2 {
    [store sdl_setObject:mainField2 forName:SDLNameMainField2Type];
}

- (nullable NSArray<SDLTextFieldType> *)mainField {
    return [store sdl_objectForName:SDLNameMainField2Type];
}

- (void)setMainField3:(nullable NSArray<SDLTextFieldType> *)mainField3 {
    [store sdl_setObject:mainField3 forName:SDLNameMainField3Type];
}

- (nullable NSArray<SDLTextFieldType> *)mainField3 {
    return [store sdl_objectForName:SDLNameMainField3Type];
}

- (void)setMainField4:(nullable NSArray<SDLTextFieldType> *)mainField4 {
    [store sdl_setObject:mainField4 forName:SDLNameMainField4Type];
}

- (nullable NSArray<SDLTextFieldType> *)mainField4 {
    return [store sdl_objectForName:SDLNameMainField4Type];
}

@end

NS_ASSUME_NONNULL_END
