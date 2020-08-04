//
//  SDLLockedDictionary.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/4/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLockedMutableDictionary.h"

@interface SDLLockedMutableDictionary ()

@property (strong, nonatomic) NSDictionary *internalDict;

@end

@implementation SDLLockedMutableDictionary

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _internalDict = [[NSDictionary alloc] init];

    return self;
}

- (void)setObject:(ObjectType)object forKey:(KeyType <NSCopying>)key {

}

@end
