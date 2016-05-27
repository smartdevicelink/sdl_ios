//  SDLGetDTCsResponse.m
//


#import "SDLGetDTCsResponse.h"

#import "SDLNames.h"

@implementation SDLGetDTCsResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_GetDTCs]) {
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
        [parameters setObject:ecuHeader forKey:NAMES_ecuHeader];
    } else {
        [parameters removeObjectForKey:NAMES_ecuHeader];
    }
}

- (NSNumber *)ecuHeader {
    return [parameters objectForKey:NAMES_ecuHeader];
}

- (void)setDtc:(NSMutableArray *)dtc {
    if (dtc != nil) {
        [parameters setObject:dtc forKey:NAMES_dtc];
    } else {
        [parameters removeObjectForKey:NAMES_dtc];
    }
}

- (NSMutableArray *)dtc {
    return [parameters objectForKey:NAMES_dtc];
}

@end
