//
//  TouchModel.m
//  SmartDeviceLink-Example-ObjC
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import "TouchModel.h"

@implementation TouchModel

+ (instancetype)touchPoint:(CGPoint)point inRect:(CGRect)rect {
    TouchModel *model = [self new];
    model.point = point;
    model.rect = rect;
    return model;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@-->%@", NSStringFromCGPoint(self.point), NSStringFromCGRect(self.rect)];
}

@end

