//
//  SDLDialNumber.m
//  SmartDeviceLink-iOS

#import "SDLDialNumber.h"

#import "NSMutableDictionary+Store.h"
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
    [parameters sdl_setObject:number forName:SDLNameNumber];
}

- (NSString *)number {
    return [parameters sdl_objectForName:SDLNameNumber];
}

@end
