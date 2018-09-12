//
//  NSMutableArray+NSMutableArray_Safe.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 9/12/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "NSMutableArray+Safe.h"

@implementation NSMutableArray (Safe)

- (void)sdl_safeAddObject:(id)object {
    if (object == nil) { return; }

    [self addObject:object];
}

@end
