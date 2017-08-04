//
//  SDLMetadataStruct.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLMetadataStruct.h"
#import "SDLNames.h"
#import "SDLTextFieldType.h"

@implementation SDLMetadataStruct

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithTextFieldTypes:(NSArray<SDLTextFieldType *> *)mainField1 mainField2:(NSArray<SDLTextFieldType *> *)mainField2 {
    self = [self init];
    if (!self) {
        return self;
    }

    self.mainField1 = [mainField1 mutableCopy];
    self.mainField2 = [mainField2 mutableCopy];

    return self;
}

- (instancetype)initWithTextFieldTypes:(NSArray<SDLTextFieldType *> *)mainField1 mainField2:(NSArray<SDLTextFieldType *> *)mainField2 mainField3:(NSArray<SDLTextFieldType *> *)mainField3 mainField4:(NSArray<SDLTextFieldType *> *)mainField4 {
    self = [self init];
    if (!self) {
        return self;
    }

    self.mainField1 = [mainField1 mutableCopy];
    self.mainField2 = [mainField2 mutableCopy];
    self.mainField3 = [mainField3 mutableCopy];
    self.mainField4 = [mainField4 mutableCopy];

    return self;
}

- (void)setMainField1:(NSMutableArray<SDLTextFieldType *> *)mainField1 {
    if (mainField1 != nil) {
        [store setObject:mainField1 forKey:NAMES_mainField1Type];
    } else {
        [store removeObjectForKey:NAMES_mainField1Type];
    }
}

- (NSMutableArray<SDLTextFieldType *> *)mainField1 {
    NSMutableArray *array = [store objectForKey:NAMES_mainField1Type];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLTextFieldType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (SDLTextFieldType *type in array) {
            [newList addObject:type];
        }
        return newList;
    }
}


- (void)setMainField2:(NSMutableArray<SDLTextFieldType *> *)mainField2 {
    if (mainField2 != nil) {
        [store setObject:mainField2 forKey:NAMES_mainField2Type];
    } else {
        [store removeObjectForKey:NAMES_mainField2Type];
    }
}

- (NSMutableArray<SDLTextFieldType *> *)mainField2 {
    NSMutableArray *array = [store objectForKey:NAMES_mainField2Type];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLTextFieldType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (SDLTextFieldType *type in array) {
            [newList addObject:type];
        }
        return newList;
    }
}

- (void)setMainField3:(NSMutableArray<SDLTextFieldType *> *)mainField3 {
    if (mainField3 != nil) {
        [store setObject:mainField3 forKey:NAMES_mainField3Type];
    } else {
        [store removeObjectForKey:NAMES_mainField3Type];
    }
}

- (NSMutableArray<SDLTextFieldType *> *)mainField3 {
    NSMutableArray *array = [store objectForKey:NAMES_mainField3Type];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLTextFieldType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (SDLTextFieldType *type in array) {
            [newList addObject:type];
        }
        return newList;
    }
}

- (void)setMainField4:(NSMutableArray<SDLTextFieldType *> *)mainField4 {
    if (mainField4 != nil) {
        [store setObject:mainField4 forKey:NAMES_mainField4Type];
    } else {
        [store removeObjectForKey:NAMES_mainField4Type];
    }
}

- (NSMutableArray<SDLTextFieldType *> *)mainField4 {
    NSMutableArray *array = [store objectForKey:NAMES_mainField4Type];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLTextFieldType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (SDLTextFieldType *type in array) {
            [newList addObject:type];
        }
        return newList;
    }
}

@end
