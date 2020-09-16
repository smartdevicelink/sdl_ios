//
//  SDLMutableDataQueue.m
//
//
//  Created by David Switzer on 3/2/17.
//
//

#import "SDLMutableDataQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLMutableDataQueue ()

@property (nonatomic, strong) NSMutableArray *elements;
@property (nonatomic, assign, readwrite) BOOL frontDequeued;

@end

@implementation SDLMutableDataQueue

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _elements = [NSMutableArray array];

    return self;
}

- (void)enqueueBuffer:(NSMutableData *)data {
    // Since this method is being called from the main thread and the dequeue methods are being called from the data session stream thread, we need to put critical sections around the queue members. Use the @synchronized object level lock to do this.
    @synchronized(self) {
        [self.elements addObject:data];
        self.frontDequeued = NO;
    }
}

- (NSMutableData *_Nullable)frontBuffer {
    NSMutableData *dataAtFront = nil;

    @synchronized(self) {
        if (self.elements.count > 0) {
            // The front of the queue is always at index 0
            dataAtFront = self.elements.firstObject;
            self.frontDequeued = YES;
        }
    }

    return dataAtFront;
}

- (void)popBuffer {
    @synchronized(self) {
        if (self.elements.count <= 0) { return; }
        [self.elements removeObjectAtIndex:0];
    }
}

- (void)removeAllObjects {
    @synchronized(self) {
        [self.elements removeAllObjects];
    }
}

- (NSUInteger)count {
    @synchronized(self) {
        return self.elements.count;
    }
}

NS_ASSUME_NONNULL_END

@end
