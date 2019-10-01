//  SDLGetDTCsResponse.m
//


#import "SDLGetDTCsResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetDTCsResponse

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameGetDTCs]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setEcuHeader:(nullable NSNumber<SDLInt> *)ecuHeader {
    [self.parameters sdl_setObject:ecuHeader forName:SDLRPCParameterNameECUHeader];
}

- (nullable NSNumber<SDLInt> *)ecuHeader {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameECUHeader ofClass:NSNumber.class error:&error];
}

- (void)setDtc:(NSArray<NSString *> *)dtc {
    [self.parameters sdl_setObject:dtc forName:SDLRPCParameterNameDTC];
}

- (NSArray<NSString *> *)dtc {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameDTC ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
