//
//  CGGeometry+SDL.h
//  SmartDeviceLink
//
//  Created by Leonid Lokhmatov on 9/29/19.
//  Copyright © 2018 Luxoft. All rights reserved
//

#import <CoreGraphics/CGGeometry.h>

/**
 @abstract
    creates a new scaled rect
 @param
    rect the source rect
 @param
    scale the scale factor
 @return
    a new rect scaled by the @scale factor
 */
CGRect CGRectScale(CGRect rect, float scale);

/**
 @abstract
    creates a new scaled point
 @param
    point the source point
 @param
    scale the scale factor
 @return
    a new point scaled by the @scale factor
 */
CGPoint CGPointScale(CGPoint point, float scale);
