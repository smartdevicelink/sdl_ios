//
//  CGPoint_Util.c
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#include "CGPoint_Util.h"
#include "math.h"

CGPoint CGPointCenterOfPoints(CGPoint point1, CGPoint point2) {
    CGFloat xCenter = (point1.x + point2.x) / 2.0f;
    CGFloat yCenter = (point1.y + point2.y) / 2.0f;
    return CGPointMake(xCenter, yCenter);
}

CGFloat CGPointDistanceBetweenPoints(CGPoint point1, CGPoint point2) {
    return hypot(point1.x - point2.x, point1.y - point2.y);
}
