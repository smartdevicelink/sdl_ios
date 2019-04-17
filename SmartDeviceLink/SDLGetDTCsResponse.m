//  SDLGetDTCsResponse.m
//


#import "SDLGetDTCsResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetDTCsResponse

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetDTCs]) {
    }
    return self;
}

- (void)setEcuHeader:(NSNumber<SDLInt> *)ecuHeader {
    [parameters sdl_setObject:ecuHeader forName:SDLRPCParameterNameECUHeader];
}

- (NSNumber<SDLInt> *)ecuHeader {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameECUHeader ofClass:NSNumber.class error:&error];
}

- (void)setDtc:(NSArray<NSString *> *)dtc {
    [parameters sdl_setObject:dtc forName:SDLRPCParameterNameDTC];
}

- (NSArray<NSString *> *)dtc {
    NSError *error = nil;
    return [parameters sdl_objectsForName:SDLRPCParameterNameDTC ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
