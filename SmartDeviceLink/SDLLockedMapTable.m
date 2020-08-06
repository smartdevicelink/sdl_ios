//
//  SDLLockedMapTable.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/6/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLockedMapTable.h"

@interface SDLLockedMapTable ()

@property (strong, nonatomic) NSMapTable *internalMapTable;

@end

@implementation SDLLockedMapTable

- (instancetype)initWithQueue:(dispatch_queue_t)queue {
    
}

@end
