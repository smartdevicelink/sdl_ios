//
//  SDLPrioritizedOutputCollection.m
//  SmartDeviceLink
//

#import "SDLPrioritizedObjectCollection.h"
#import "SDLObjectWithPriority.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLPrioritizedObjectCollection () {
    NSMutableArray<id> *privateArray;
}
@end


@implementation SDLPrioritizedObjectCollection

- (instancetype)init {
    self = [super init];
    if (self) {
        privateArray = [NSMutableArray<id> new];
    }
    return self;
}

- (void)addObject:(nullable id)object withPriority:(NSInteger)priority {
    if (object == nil || [[NSNull null] isEqual:object]) {
        return;
    }

    SDLObjectWithPriority *newWrapper = [SDLObjectWithPriority objectWithObject:object priority:priority];

    @synchronized(privateArray) {
        // Find correct place to insert.
        // Sorted in descending order.
        BOOL lowerPriorityFound = NO;
        NSUInteger currentCount = privateArray.count;
        for (NSUInteger x = 0; x < currentCount; x++) {
            SDLObjectWithPriority *o = privateArray[x];
            if (o.priority <= priority) {
                lowerPriorityFound = YES;
                [privateArray insertObject:newWrapper atIndex:x];
                break;
            }
        }
        if (!lowerPriorityFound) {
            [privateArray addObject:newWrapper];
        }
    }
}

- (nullable instancetype)nextObject {
    if (privateArray.count == 0) {
        return nil;
    }

    SDLObjectWithPriority *obj = nil;
    @synchronized(privateArray) {
        obj = (SDLObjectWithPriority *)[privateArray lastObject];
        [privateArray removeLastObject];
    }

    return obj.object;
}

@end

NS_ASSUME_NONNULL_END
