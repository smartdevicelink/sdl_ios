//  SDLReadDIDResponse.m
//


#import "SDLReadDIDResponse.h"

#import "SDLDIDResult.h"
#import "SDLNames.h"

@implementation SDLReadDIDResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameReadDID]) {
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
        [parameters setObject:didResult forKey:SDLNameDIDResult];
    } else {
        [parameters removeObjectForKey:SDLNameDIDResult];
    }
}

- (NSMutableArray *)didResult {
    NSMutableArray *array = [parameters objectForKey:SDLNameDIDResult];
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
