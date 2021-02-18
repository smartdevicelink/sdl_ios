//
//  SDLMenuRunScore.m
//  SmartDeviceLink
//
//  Created by Justin Gluck on 5/13/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLDynamicMenuUpdateRunScore.h"

#import "SDLDynamicMenuUpdateAlgorithm.h"

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

- (NSString *)description {
    return [NSString stringWithFormat:@"Run Score: %ld, old status: %@, updated status: %@", (long)self.score, [self sdl_stringArrayForCellUpdateStatuses:self.oldStatus], [self sdl_stringArrayForCellUpdateStatuses:self.updatedStatus]];
}

- (NSArray<NSString *> *)sdl_stringArrayForCellUpdateStatuses:(NSArray<NSNumber *> *)statuses {
    NSMutableArray<NSString *> *mutableStringArray = [NSMutableArray arrayWithCapacity:statuses.count];
    for (NSNumber *status in statuses) {
        if (status.unsignedIntegerValue == SDLMenuCellUpdateStateDelete) {
            [mutableStringArray addObject:@"DELETE"];
        } else if (status.unsignedIntegerValue == SDLMenuCellUpdateStateAdd) {
            [mutableStringArray addObject:@"ADD"];
        } else if (status.unsignedIntegerValue == SDLMenuCellUpdateStateKeep) {
            [mutableStringArray addObject:@"KEEP"];
        }
    }

    return [mutableStringArray copy];
}

@end

NS_ASSUME_NONNULL_END
