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

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithNumber:(NSString *)number {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.number = number;

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
