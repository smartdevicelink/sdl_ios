//
//  SDLDialNumber.m
//  SmartDeviceLink-iOS

#import "SDLDialNumber.h"

#import "SDLNames.h"

@implementation SDLDialNumber

- (instancetype)init {
    if (self = [super initWithName:SDLNameDialNumber]) {
    }
    return self;
}

- (void)setNumber:(NSString *)number {
    if (number != nil) {
        parameters[SDLNameNumber] = number;
    } else {
        [parameters removeObjectForKey:SDLNameNumber];
    }
}

- (NSString *)number {
    return parameters[SDLNameNumber];
}

@end
