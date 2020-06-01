//
//  TouchModel.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Leonid Lokhmatov on 5/27/20.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TouchModel : NSObject
@property (assign, nonatomic) CGRect rect;
@property (assign, nonatomic) CGPoint point;
+ (instancetype)touchPoint:(CGPoint)point inRect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
