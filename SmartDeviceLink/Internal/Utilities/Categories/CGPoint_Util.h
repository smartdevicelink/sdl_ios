//
//  CGPoint_Util.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#ifndef CGPoint_Util_h
#define CGPoint_Util_h

#include <CoreGraphics/CGGeometry.h>
#include <stdio.h>

/**
 *  @abstract
 *      Calculate the center of two points.
 *  @param point1
 *      First point.
 *  @param point2
 *      Second point.
 *  @return CGPoint
 *      Center of the points.
 */
CGPoint CGPointCenterOfPoints(CGPoint point1, CGPoint point2);

/**
 *  @abstract
 *      Calculate the distance between two points.
 *  @param point1
 *      First point.
 *  @param point2
 *      Second point.
 *  @return CGFloat
 *      Distance between the points.
 */
CGFloat CGPointDistanceBetweenPoints(CGPoint point1, CGPoint point2);

#endif /* CGPoint_Util_h */
