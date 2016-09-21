//  SDLGetDTCsResponse.m
//


#import "SDLGetDTCsResponse.h"



@implementation SDLGetDTCsResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameGetDtcs]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setEcuHeader:(NSNumber *)ecuHeader {
    if (ecuHeader != nil) {
        [parameters setObject:ecuHeader forKey:SDLNameEcuHeader];
    } else {
        [parameters removeObjectForKey:SDLNameEcuHeader];
    }
}

- (NSNumber *)ecuHeader {
    return [parameters objectForKey:SDLNameEcuHeader];
}

- (void)setDtc:(NSMutableArray *)dtc {
    if (dtc != nil) {
        [parameters setObject:dtc forKey:SDLNameDtc];
    } else {
        [parameters removeObjectForKey:SDLNameDtc];
    }
}

- (NSMutableArray *)dtc {
    return [parameters objectForKey:SDLNameDtc];
}

@end
