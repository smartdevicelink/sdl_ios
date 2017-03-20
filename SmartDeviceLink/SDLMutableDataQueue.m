//
//  SDLMutableDataQueue.m
//  
//
//  Created by David Switzer on 3/2/17.
//
//

#import "SDLMutableDataQueue.h"

@interface SDLMutableDataQueue()

@property(nonatomic, strong) NSMutableArray *elements;
@property(nonatomic, assign, readwrite) BOOL frontDequeued;

@end

@implementation SDLMutableDataQueue

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.elements = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)enqueueBuffer:(NSMutableData *)data {
    @synchronized (self) {
        [self.elements addObject:data];
        self.frontDequeued = NO;
    }
}

- (NSMutableData *)frontBuffer {
    NSMutableData *dataAtFront = nil;
    
    @synchronized (self) {
        if (self.elements.count) {
            // The front of the queue is always at index 0
            dataAtFront = self.elements[0];
            self.frontDequeued = YES;
        }
    }
    
    return dataAtFront;
}

- (void)popBuffer {
    @synchronized (self) {
        [self.elements removeObjectAtIndex:0];
    }
}

- (void)flush {
    @synchronized (self) {
        [self.elements removeAllObjects];
    }
}

- (NSUInteger)count {
    @synchronized (self) {
        return self.elements.count;
    }
}

- (void)dealloc {
    [self flush];
    self.elements = nil;
}

@end
