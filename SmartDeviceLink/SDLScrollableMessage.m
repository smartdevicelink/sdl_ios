//  SDLScrollableMessage.m
//


#import "SDLScrollableMessage.h"

#import "SDLNames.h"
#import "SDLSoftButton.h"

@implementation SDLScrollableMessage

- (instancetype)init {
    if (self = [super initWithName:SDLNameScrollableMessage]) {
    }
    return self;
}

- (void)setScrollableMessageBody:(NSString *)scrollableMessageBody {
    if (scrollableMessageBody != nil) {
        [parameters setObject:scrollableMessageBody forKey:SDLNameScrollableMessageBody];
    } else {
        [parameters removeObjectForKey:SDLNameScrollableMessageBody];
    }
}

- (NSString *)scrollableMessageBody {
    return [parameters objectForKey:SDLNameScrollableMessageBody];
}

- (void)setTimeout:(NSNumber *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:SDLNameTimeout];
    } else {
        [parameters removeObjectForKey:SDLNameTimeout];
    }
}

- (NSNumber *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

- (void)setSoftButtons:(NSMutableArray *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (NSMutableArray *)softButtons {
    NSMutableArray *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
