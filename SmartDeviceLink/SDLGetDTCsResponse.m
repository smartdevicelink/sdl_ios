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
    [self setObject:ecuHeader forName:SDLNameECUHeader];
}

- (NSNumber<SDLInt> *)ecuHeader {
    return [parameters objectForKey:SDLNameECUHeader];
}

- (void)setDtc:(NSMutableArray<NSString *> *)dtc {
    [self setObject:dtc forName:SDLNameDTC];
}

- (NSMutableArray<NSString *> *)dtc {
    return [parameters objectForKey:SDLNameDTC];
}

@end
