//
//  SDLRCButtonPress.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLButtonPress.h"

#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"
#import "SDLInteriorZone.h"
#import "SDLModuleType.h"
#import "SDLNames.h"


@implementation SDLButtonPress

- (instancetype)init {
    if (self = [super initWithName:NAMES_ButtonPress]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super initWithDictionary:[dict mutableCopy]]) {
    }
    return self;
}

- (void)setZone:(SDLInteriorZone *)zone {
    [parameters setObject:zone forKey:NAMES_zone];
}

- (SDLInteriorZone *)zone {
    NSObject *obj = [parameters objectForKey:NAMES_zone];
    if ([obj isKindOfClass:[SDLInteriorZone class]]) {
        return (SDLInteriorZone *)obj;
    } else {
        return [[SDLInteriorZone alloc] initWithDictionary:[obj mutableCopy]];
    }
}

- (void)setModuleType:(SDLModuleType *)moduleType {
    [parameters setObject:moduleType forKey:NAMES_moduleType];
}

- (SDLModuleType *)moduleType {
    NSObject *obj = [parameters objectForKey:NAMES_moduleType];
    if ([obj isKindOfClass:[SDLModuleType class]]) {
        return (SDLModuleType *)obj;
    } else {
        return [SDLModuleType valueOf:(NSString *)obj];
    }
}

- (void)setButtonName:(SDLButtonName *)buttonName {
    [parameters setObject:buttonName forKey:NAMES_buttonName];
}

- (SDLButtonName *)buttonName {
    NSObject *obj = [parameters objectForKey:NAMES_buttonName];
    if ([obj isKindOfClass:[SDLButtonName class]]) {
        return (SDLButtonName *)obj;
    } else {
        return [SDLButtonName valueOf:(NSString *)obj];
    }
}

- (void)setButtonPressMode:(SDLButtonPressMode *)buttonPressMode {
    [parameters setObject:buttonPressMode forKey:NAMES_buttonPressMode];
}

- (SDLButtonPressMode *)buttonPressMode {
    NSObject *obj = [parameters objectForKey:NAMES_buttonPressMode];
    if ([obj isKindOfClass:[SDLButtonPressMode class]]) {
        return (SDLButtonPressMode *)obj;
    } else {
        return [SDLButtonPressMode valueOf:(NSString *)obj];
    }
}

@end
