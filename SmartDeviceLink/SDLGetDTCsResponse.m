//  SDLGetDTCsResponse.m
//


#import "SDLGetDTCsResponse.h"

#import "SDLNames.h"

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
    return [parameters objectForKey:SDLNameECUHeader];
}

- (void)setDtc:(NSMutableArray<NSString *> *)dtc {
    [parameters sdl_setObject:dtc forName:SDLNameDTC];
}

- (NSMutableArray<NSString *> *)dtc {
    return [parameters objectForKey:SDLNameDTC];
}

@end
