//
//  SDLMenuRunScore.h
//  SmartDeviceLink
//
//  Created by Justin Gluck on 5/13/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLMenuRunScore : NSObject

@property (copy, nonatomic, readonly) NSArray<NSNumber *> *oldStatus;
@property (copy, nonatomic, readonly) NSArray<NSNumber *> *updatedStatus;
@property (assign, nonatomic, readonly) NSUInteger score;

- (instancetype)initWithOldStatus:(NSArray<NSNumber *> *)oldStatus updatedStatus:(NSArray<NSNumber *> *)updatedStatus score:(NSUInteger)score;

@end

NS_ASSUME_NONNULL_END

//int i = 0;
//
//NSNumber *testNum = @(i);
//
//int testNumInt = testNum.intValue;
