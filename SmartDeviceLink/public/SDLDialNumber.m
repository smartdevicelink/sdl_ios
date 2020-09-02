//
//  SDLDialNumber.m
//  SmartDeviceLink-iOS

#import "SDLDialNumber.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

@implementation SDLDialNumber

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameDialNumber]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithNumber:(NSString *)number {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.number = number;

    return self;
}

- (void)setNumber:(NSString *)number {
    [self.parameters sdl_setObject:number forName:SDLRPCParameterNameNumber];
}

- (NSString *)number {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameNumber ofClass:NSString.class error:&error];
}

@end
