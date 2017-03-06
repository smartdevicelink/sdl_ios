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

- (instancetype)init{
    self = [super init];
    if (self != nil) {
        self.elements = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)enqueue:(NSMutableData *)data{
    @synchronized (self) {
        [self.elements addObject:data];
        self.frontDequeued = NO;
    }
}

- (NSMutableData *)front{
    NSMutableData *dataAtFront = nil;
    
    @synchronized (self) {
        if (self.elements.count > 0) {
            // The front of the queue is always at index 0
            dataAtFront = [self.elements objectAtIndex:0];
            self.frontDequeued = YES;
        }
    }
    
    return dataAtFront;
}

- (void)pop{
    @synchronized (self) {
        [self.elements removeObjectAtIndex:0];
    }
}

- (void)flush{
    @synchronized (self) {
        [self.elements removeAllObjects];
    }
}

- (NSUInteger)count{
    @synchronized (self) {
        return self.elements.count;
    }
}

- (void)dealloc{
    self.elements = nil;
}

@end
