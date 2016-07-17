//
//  CGPoint_Util.h
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#ifndef CGPoint_Util_h
#define CGPoint_Util_h

#include <stdio.h>
#include <CoreGraphics/CGGeometry.h>

CGPoint CGPointCenterOfPoints(CGPoint point1, CGPoint point2);
CGFloat CGPointDistanceBetweenPoints(CGPoint point1, CGPoint point2);

#endif /* CGPoint_Util_h */
