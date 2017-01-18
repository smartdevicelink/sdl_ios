//  SDLScrollableMessage.m
//


#import "SDLScrollableMessage.h"

#import "SDLNames.h"
#import "SDLSoftButton.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLScrollableMessage

- (instancetype)init {
    if (self = [super initWithName:SDLNameScrollableMessage]) {
    }
    return self;
}

- (instancetype)initWithMessage:(NSString *)message timeout:(UInt16)timeout softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons {
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
    if (scrollableMessageBody != nil) {
        [parameters setObject:scrollableMessageBody forKey:SDLNameScrollableMessageBody];
    } else {
        [parameters removeObjectForKey:SDLNameScrollableMessageBody];
    }
}

- (NSString *)scrollableMessageBody {
    return [parameters objectForKey:SDLNameScrollableMessageBody];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)timeout {
    if (timeout != nil) {
        [parameters setObject:timeout forKey:SDLNameTimeout];
    } else {
        [parameters removeObjectForKey:SDLNameTimeout];
    }
}

- (nullable NSNumber<SDLInt> *)timeout {
    return [parameters objectForKey:SDLNameTimeout];
}

- (void)setSoftButtons:(nullable NSMutableArray<SDLSoftButton *> *)softButtons {
    if (softButtons != nil) {
        [parameters setObject:softButtons forKey:SDLNameSoftButtons];
    } else {
        [parameters removeObjectForKey:SDLNameSoftButtons];
    }
}

- (nullable NSMutableArray<SDLSoftButton *> *)softButtons {
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

NS_ASSUME_NONNULL_END
