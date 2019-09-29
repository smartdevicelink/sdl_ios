//
//  CGGeometry+SDL.c
//  SmartDeviceLink
//
//  Created by Leonid Lokhmatov on 9/29/19.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import "CGGeometry+SDL.h"

CGRect CGRectScale(CGRect rect, float scale) {
    if (1.f > scale) {
        return rect;
    }
    const CGFloat s = scale;
    return CGRectMake(CGRectGetMinX(rect) * s,
                      CGRectGetMinY(rect) * s,
                      CGRectGetWidth(rect) * s,
                      CGRectGetHeight(rect) * s);
}

CGPoint CGPointScale(CGPoint point, float scale) {
    if (1.f > scale) {
        return point;
    }
    const CGFloat s = scale;
    return CGPointMake(point.x * s, point.y * s);
}

CGPoint CGRectGetCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}
