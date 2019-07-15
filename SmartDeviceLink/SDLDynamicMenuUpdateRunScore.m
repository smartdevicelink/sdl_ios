//
//  SDLMenuRunScore.m
//  SmartDeviceLink
//
//  Created by Justin Gluck on 5/13/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLDynamicMenuUpdateRunScore.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLDynamicMenuUpdateRunScore

- (instancetype)initWithOldStatus:(NSArray<NSNumber *> *)oldStatus updatedStatus:(NSArray<NSNumber *> *)updatedStatus score:(NSUInteger)score {
    self = [super init];
    if (!self) { return nil; }

    _oldStatus = oldStatus;
    _updatedStatus = updatedStatus;
    _score = score;

    return self;
}

@end

NS_ASSUME_NONNULL_END
