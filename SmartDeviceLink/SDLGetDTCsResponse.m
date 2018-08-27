//  SDLGetDTCsResponse.m
//


#import "SDLGetDTCsResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetDTCsResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetDTCs]) {
    }
    return self;
}

- (void)setEcuHeader:(NSNumber<SDLInt> *)ecuHeader {
    [parameters sdl_setObject:ecuHeader forName:SDLNameECUHeader];
}

- (NSNumber<SDLInt> *)ecuHeader {
    return [parameters sdl_objectForName:SDLNameECUHeader];
}

- (void)setDtc:(NSArray<NSString *> *)dtc {
    [parameters sdl_setObject:dtc forName:SDLNameDTC];
}

- (NSArray<NSString *> *)dtc {
    return [parameters sdl_objectForName:SDLNameDTC];
}

@end

NS_ASSUME_NONNULL_END
