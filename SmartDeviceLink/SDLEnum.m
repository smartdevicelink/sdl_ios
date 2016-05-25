//  SDLEnum.m
//


#import "SDLEnum.h"

@implementation SDLEnum

@synthesize value;

- (instancetype)initWithValue:(NSString *)aValue {
    if (self = [super init]) {
        value = aValue;
    }
    return self;
}

- (NSString *)description {
    return value;
}

- (id)debugQuickLookObject {
    return value;
}

- (NSUInteger)hash {
    return [self.value hash];
}

- (BOOL)isEqual:(id)object {
    // Test pointer equality
    if (self == object) {
        return YES;
    }

    // Test class equality, if not equal, value equality doesn't matter
    if (![object isMemberOfClass:self.class]) {
        return NO;
    }

    return [self isEqualToEnum:object];
}

- (BOOL)isEqualToEnum:(SDLEnum *)object {
    // Test value equality, if it's equal we're good
    if ([self.value isEqualToString:object.value]) {
        return YES;
    }

    return NO;
}
@end
