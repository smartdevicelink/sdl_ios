//
//  SDLObjectWithPriority.m
//  SmartDeviceLink
//

#import "SDLObjectWithPriority.h"


@implementation SDLObjectWithPriority

- (instancetype)initWithObject:(id)object priority:(NSInteger)priority {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    self.object = object;
    self.priority = priority;

    return self;
}

- (instancetype)init {
    return [self initWithObject:nil priority:NSIntegerMax];
}

+ (instancetype)objectWithObject:(id)object priority:(NSInteger)priority {
    return [[self alloc] initWithObject:object priority:priority];
}

@end
