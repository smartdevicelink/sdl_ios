//
//  SDLMetadataStruct.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLMetadataTags.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"

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
    [self.store sdl_setObject:mainField1 forName:SDLRPCParameterNameMainField1];
}

- (nullable NSArray<SDLMetadataType> *)mainField1 {
    return [self.store sdl_enumsForName:SDLRPCParameterNameMainField1 error:nil];
}

- (void)setMainField2:(nullable NSArray<SDLMetadataType> *)mainField2 {
    [self.store sdl_setObject:mainField2 forName:SDLRPCParameterNameMainField2];
}

- (nullable NSArray<SDLMetadataType> *)mainField2 {
    return [self.store sdl_enumsForName:SDLRPCParameterNameMainField2 error:nil];
}

- (void)setMainField3:(nullable NSArray<SDLMetadataType> *)mainField3 {
    [self.store sdl_setObject:mainField3 forName:SDLRPCParameterNameMainField3];
}

- (nullable NSArray<SDLMetadataType> *)mainField3 {
    return [self.store sdl_enumsForName:SDLRPCParameterNameMainField3 error:nil];
}

- (void)setMainField4:(nullable NSArray<SDLMetadataType> *)mainField4 {
    [self.store sdl_setObject:mainField4 forName:SDLRPCParameterNameMainField4];
}

- (nullable NSArray<SDLMetadataType> *)mainField4 {
    return [self.store sdl_enumsForName:SDLRPCParameterNameMainField4 error:nil];
}

@end

NS_ASSUME_NONNULL_END
