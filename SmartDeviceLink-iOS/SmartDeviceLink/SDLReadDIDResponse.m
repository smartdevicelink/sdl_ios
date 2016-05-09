//  SDLReadDIDResponse.m
//


#import "SDLReadDIDResponse.h"

#import "SDLDIDResult.h"
#import "SDLNames.h"

@implementation SDLReadDIDResponse

- (instancetype)init {
    if (self = [super initWithName:NAMES_ReadDID]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setDidResult:(NSMutableArray *)didResult {
    if (didResult != nil) {
        [parameters setObject:didResult forKey:NAMES_didResult];
    } else {
        [parameters removeObjectForKey:NAMES_didResult];
    }
}

- (NSMutableArray *)didResult {
    NSMutableArray *array = [parameters objectForKey:NAMES_didResult];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLDIDResult.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary *dict in array) {
            [newList addObject:[[SDLDIDResult alloc] initWithDictionary:(NSMutableDictionary *)dict]];
        }
        return newList;
    }
}

@end
