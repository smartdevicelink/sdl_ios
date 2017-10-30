//
//  SDLMetadataStruct.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLMetadataTags.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLMetadataTags

- (instancetype)initWithTextFieldTypes:(nullable NSArray<SDLMetadataType> *)mainField1 mainField2:(nullable NSArray<SDLMetadataType> *)mainField2 {
    self = [self init];
    if (!self) {
        return self;
    }

    self.mainField1 = mainField1;
    self.mainField2 = mainField2;

    return self;
}

- (instancetype)initWithTextFieldTypes:(nullable NSArray<SDLMetadataType> *)mainField1 mainField2:(nullable NSArray<SDLMetadataType> *)mainField2 mainField3:(nullable NSArray<SDLMetadataType> *)mainField3 mainField4:(nullable NSArray<SDLMetadataType> *)mainField4 {
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

- (void)setMainField1:(nullable NSArray<SDLMetadataType> *)mainField1 {
    [store sdl_setObject:mainField1 forName:SDLNameMainField1];
}

- (nullable NSArray<SDLMetadataType> *)mainField1 {
    return [store sdl_objectForName:SDLNameMainField1];
}

- (void)setMainField2:(nullable NSArray<SDLMetadataType> *)mainField2 {
    [store sdl_setObject:mainField2 forName:SDLNameMainField2];
}

- (nullable NSArray<SDLMetadataType> *)mainField2 {
    return [store sdl_objectForName:SDLNameMainField2];
}

- (void)setMainField3:(nullable NSArray<SDLMetadataType> *)mainField3 {
    [store sdl_setObject:mainField3 forName:SDLNameMainField3];
}

- (nullable NSArray<SDLMetadataType> *)mainField3 {
    return [store sdl_objectForName:SDLNameMainField3];
}

- (void)setMainField4:(nullable NSArray<SDLMetadataType> *)mainField4 {
    [store sdl_setObject:mainField4 forName:SDLNameMainField4];
}

- (nullable NSArray<SDLMetadataType> *)mainField4 {
    return [store sdl_objectForName:SDLNameMainField4];
}

@end

NS_ASSUME_NONNULL_END
