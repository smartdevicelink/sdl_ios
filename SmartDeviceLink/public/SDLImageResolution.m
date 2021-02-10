//  SDLImageResolution.m
//


#import "NSMutableDictionary+Store.h"
#import "SDLImageResolution.h"
#import "SDLRPCParameterNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLImageResolution

- (instancetype)initWithWidth:(uint16_t)width height:(uint16_t)height {
    self = [self init];
    if (!self) { return nil; }

    self.resolutionWidth = @(width);
    self.resolutionHeight = @(height);

    return self;
}

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    typeof(self) aCopy = [[self.class allocWithZone:zone] init];
    // copy boxed values to keep nil cases if any and avoid outside updates
    aCopy.resolutionWidth = [self.resolutionWidth copyWithZone:zone];
    aCopy.resolutionHeight = [self.resolutionHeight copyWithZone:zone];
    return aCopy;
}

- (void)setResolutionWidth:(NSNumber<SDLInt> *)resolutionWidth {
    [self.store sdl_setObject:resolutionWidth forName:SDLRPCParameterNameResolutionWidth];
}

- (NSNumber<SDLInt> *)resolutionWidth {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameResolutionWidth ofClass:NSNumber.class error:&error];
}

- (void)setResolutionHeight:(NSNumber<SDLInt> *)resolutionHeight {
    [self.store sdl_setObject:resolutionHeight forName:SDLRPCParameterNameResolutionHeight];
}

- (NSNumber<SDLInt> *)resolutionHeight {
    NSError *error = nil;
    return [self.store sdl_objectForName:SDLRPCParameterNameResolutionHeight ofClass:NSNumber.class error:&error];
}

#define EQUAL_NUM(property) ((self.property == nil && res2.property == nil) ? YES : [self.property isEqualToNumber:res2.property])

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:self.class]) {
        return NO;
    }
    typeof(self) res2 = object;
    return EQUAL_NUM(resolutionWidth) && EQUAL_NUM(resolutionHeight);
}

#undef EQUAL_NUM

@end

NS_ASSUME_NONNULL_END
