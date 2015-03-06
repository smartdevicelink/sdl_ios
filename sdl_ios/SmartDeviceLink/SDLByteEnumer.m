//
//  SDLByteEnumer.m
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import "SDLByteEnumer.h"

@implementation SDLByteEnumer

-(instancetype)initWithValue:(Byte)value name:(NSString*)name{
    self = [super init];
    if (self) {
        _value = value;
        _name = name;
    }
    return self;
}

@end
