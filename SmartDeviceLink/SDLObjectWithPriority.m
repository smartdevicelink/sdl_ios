//
//  SDLObjectWithPriority.m
//  SmartDeviceLink
//

#import "SDLObjectWithPriority.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLObjectWithPriority

- (instancetype)initWithObject:(nullable id)object priority:(NSInteger)priority {
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

+ (instancetype)objectWithObject:(nullable id)object priority:(NSInteger)priority {
    return [[self alloc] initWithObject:object priority:priority];
}

@end

NS_ASSUME_NONNULL_END
