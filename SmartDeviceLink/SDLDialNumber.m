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

- (instancetype)initWithNumber:(NSString *)number {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.number = number;

    return self;
}

- (void)setNumber:(NSString *)number {
    [self setObject:number forName:SDLNameNumber];
}

- (NSString *)number {
    return [self objectForName:SDLNameNumber];
}

@end
