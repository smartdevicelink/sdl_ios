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

- (instancetype)initWithMessage:(NSString *)message timeout:(UInt16)timeout softButtons:(NSArray<SDLSoftButton *> *)softButtons {
    self = [self initWithMessage:message];
    if (!self) {
        return nil;
    }

    self.timeout = @(timeout);
    self.softButtons = [softButtons mutableCopy];

    return self;
}

- (instancetype)initWithMessage:(NSString *)message {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.scrollableMessageBody = message;

    return self;
}

- (void)setScrollableMessageBody:(NSString *)scrollableMessageBody {
    [self setObject:scrollableMessageBody forName:SDLNameScrollableMessageBody];
}

- (NSString *)scrollableMessageBody {
    return [parameters objectForKey:SDLNameScrollableMessageBody];
}

- (void)setTimeout:(NSNumber<SDLInt> *)timeout {
    [self setObject:timeout forName:SDLNameTimeout];
}

- (NSNumber<SDLInt> *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

- (void)setSoftButtons:(NSMutableArray<SDLSoftButton *> *)softButtons {
    [self setObject:softButtons forName:SDLNameSoftButtons];
}

- (NSMutableArray<SDLSoftButton *> *)softButtons {
    NSMutableArray<SDLSoftButton *> *array = [parameters objectForKey:SDLNameSoftButtons];
    if ([array count] < 1 || [[array objectAtIndex:0] isKindOfClass:SDLSoftButton.class]) {
        return array;
    } else {
        NSMutableArray<SDLSoftButton *> *newList = [NSMutableArray arrayWithCapacity:[array count]];
        for (NSDictionary<NSString *, id> *dict in array) {
            [newList addObject:[[SDLSoftButton alloc] initWithDictionary:(NSDictionary *)dict]];
        }
        return newList;
    }
}

@end
