//  SDLReadDIDResponse.m
//


#import "SDLReadDIDResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLDIDResult.h"
#import "SDLNames.h"

@implementation SDLReadDIDResponse

- (instancetype)init {
    if (self = [super initWithName:SDLNameReadDID]) {
    }
    return self;
}

- (void)setDidResult:(NSMutableArray<SDLDIDResult *> *)didResult {
    [parameters sdl_setObject:didResult forName:SDLNameDIDResult];
}

- (NSMutableArray<SDLDIDResult *> *)didResult {
    NSMutableArray<SDLDIDResult *> *array = [parameters objectForKey:SDLNameDIDResult];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLDIDResult.class]) {
        return array;
    } else {
        NSMutableArray<SDLDIDResult *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLDIDResult alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
