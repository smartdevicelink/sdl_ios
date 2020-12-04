//
//  NSMutableArray+NSMutableArray_Safe.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 9/12/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray<ObjectType> (Safe)

- (void)sdl_safeAddObject:(ObjectType)object;

@end
