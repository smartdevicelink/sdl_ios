//
//  SDLMenuRunScore.h
//  SmartDeviceLink
//
//  Created by Justin Gluck on 5/13/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLDynamicMenuUpdateRunScore : NSObject

/**
 Will contain all the Deletes and Keeps
 */
@property (copy, nonatomic, readonly) NSArray<NSNumber *> *oldStatus;

/**
 Will contain all the Adds and Keeps
 */
@property (copy, nonatomic, readonly) NSArray<NSNumber *> *updatedStatus;

/**
 Will contain the score, number of total Adds that will need to be created
 */
@property (assign, nonatomic, readonly) NSUInteger score;

- (instancetype)initWithOldStatus:(NSArray<NSNumber *> *)oldStatus updatedStatus:(NSArray<NSNumber *> *)updatedStatus score:(NSUInteger)score;

@end

NS_ASSUME_NONNULL_END
