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
    return [parameters sdl_objectForName:SDLRPCParameterNameECUHeader];
}

- (void)setDtc:(NSArray<NSString *> *)dtc {
    [parameters sdl_setObject:dtc forName:SDLRPCParameterNameDTC];
}

- (NSArray<NSString *> *)dtc {
    return [parameters sdl_objectForName:SDLRPCParameterNameDTC];
}

@end

NS_ASSUME_NONNULL_END
