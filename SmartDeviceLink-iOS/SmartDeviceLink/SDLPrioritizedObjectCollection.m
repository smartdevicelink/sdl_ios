//
//  SDLPrioritizedOutputCollection.m
//  SmartDeviceLink
//

#import "SDLPrioritizedObjectCollection.h"
#import "SDLObjectWithPriority.h"


@interface SDLPrioritizedObjectCollection () {
    NSMutableArray *privateArray;
}
@end


@implementation SDLPrioritizedObjectCollection

- (instancetype)init {
    self = [super init];
    if (self) {
        privateArray = [NSMutableArray new];
    }
    return self;
}

- (void)addObject:(id)object withPriority:(NSInteger)priority {
    if (object == nil || [[NSNull null] isEqual:object]) {
        return;
    }

    SDLObjectWithPriority *newWrapper = [SDLObjectWithPriority objectWithObject:object priority:priority];

    @synchronized(privateArray) {
        // Find correct place to insert.
        // Sorted in descending order.
        BOOL lowerPriorityFound = NO;
        NSInteger currentCount = privateArray.count;
        for (int x = 0; x < currentCount; x++) {
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

- (instancetype)nextObject {
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
