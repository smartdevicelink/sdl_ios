//
//  SDLDialNumber.m
//  SmartDeviceLink-iOS

#import "SDLDialNumber.h"



@implementation SDLDialNumber

- (instancetype)init {
    if (self = [super initWithName:SDLNameDialNumber]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
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
