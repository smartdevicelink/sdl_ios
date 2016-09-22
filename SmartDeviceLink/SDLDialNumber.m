//
//  SDLDialNumber.m
//  SmartDeviceLink-iOS

#import "SDLDialNumber.h"

#import "SDLNames.h"

@implementation SDLDialNumber

- (instancetype)init {
    if (self = [super initWithName:NAMES_DialNumber]) {
    }
    return self;
}

- (void)setNumber:(NSString *)number {
    if (number != nil) {
        parameters[NAMES_number] = number;
    } else {
        [parameters removeObjectForKey:NAMES_number];
    }
}

- (NSString *)number {
    return parameters[NAMES_number];
}

@end
