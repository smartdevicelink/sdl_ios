//
//  SDLMetadataTags.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLMetadataTags.h"
#import "SDLMetadataType.h"
#import "SDLNames.h"

@implementation SDLMetadataTags

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

- (instancetype)initWithTextFieldTypes:(NSArray<SDLMetadataType *> *)mainField1 mainField2:(NSArray<SDLMetadataType *> *)mainField2 {
    self = [self init];
    if (!self) {
        return self;
    }

    self.mainField1 = [mainField1 mutableCopy];
    self.mainField2 = [mainField2 mutableCopy];

    return self;
}

- (instancetype)initWithTextFieldTypes:(NSArray<SDLMetadataType *> *)mainField1 mainField2:(NSArray<SDLMetadataType *> *)mainField2 mainField3:(NSArray<SDLMetadataType *> *)mainField3 mainField4:(NSArray<SDLMetadataType *> *)mainField4 {
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

- (void)setMainField1:(NSMutableArray<SDLMetadataType *> *)mainField1 {
    if (mainField1 != nil) {
        [store setObject:mainField1 forKey:NAMES_mainField1];
    } else {
        [store removeObjectForKey:NAMES_mainField1];
    }
}

- (NSMutableArray<SDLMetadataType *> *)mainField1 {
    NSMutableArray *array = [store objectForKey:NAMES_mainField1];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLMetadataType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (SDLMetadataType *type in array) {
            [newList addObject:type];
        }
        return newList;
    }
}

- (void)setMainField2:(NSMutableArray<SDLMetadataType *> *)mainField2 {
    if (mainField2 != nil) {
        [store setObject:mainField2 forKey:NAMES_mainField2];
    } else {
        [store removeObjectForKey:NAMES_mainField2];
    }
}

- (NSMutableArray<SDLMetadataType *> *)mainField2 {
    NSMutableArray *array = [store objectForKey:NAMES_mainField2];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLMetadataType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (SDLMetadataType *type in array) {
            [newList addObject:type];
        }
        return newList;
    }
}

- (void)setMainField3:(NSMutableArray<SDLMetadataType *> *)mainField3 {
    if (mainField3 != nil) {
        [store setObject:mainField3 forKey:NAMES_mainField3];
    } else {
        [store removeObjectForKey:NAMES_mainField3];
    }
}

- (NSMutableArray<SDLMetadataType *> *)mainField3 {
    NSMutableArray *array = [store objectForKey:NAMES_mainField3];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLMetadataType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (SDLMetadataType *type in array) {
            [newList addObject:type];
        }
        return newList;
    }
}

- (void)setMainField4:(NSMutableArray<SDLMetadataType *> *)mainField4 {
    if (mainField4 != nil) {
        [store setObject:mainField4 forKey:NAMES_mainField4];
    } else {
        [store removeObjectForKey:NAMES_mainField4];
    }
}

- (NSMutableArray<SDLMetadataType *> *)mainField4 {
    NSMutableArray *array = [store objectForKey:NAMES_mainField4];
    if ([array isEqual:[NSNull null]]) {
        return [NSMutableArray array];
    } else if (array.count < 1 || [array.firstObject isKindOfClass:SDLMetadataType.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (SDLMetadataType *type in array) {
            [newList addObject:type];
        }
        return newList;
    }
}

@end
