//  SDLOnEncodedSyncPData.m
//

#import "SDLOnEncodedSyncPData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
@implementation SDLOnEncodedSyncPData
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnEncodedSyncPData]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (void)setData:(NSArray<NSString *> *)data {
    [self.parameters sdl_setObject:data forName:SDLRPCParameterNameData];
}

- (NSArray<NSString *> *)data {
    NSError *error = nil;
    return [self.parameters sdl_objectsForName:SDLRPCParameterNameData ofClass:NSString.class error:&error];
}

- (void)setURL:(nullable NSString *)URL {
    [self.parameters sdl_setObject:URL forName:SDLRPCParameterNameURLUppercase];
}

- (nullable NSString *)URL {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameURLUppercase ofClass:NSString.class error:nil];
}

- (void)setTimeout:(nullable NSNumber<SDLInt> *)Timeout {
    [self.parameters sdl_setObject:Timeout forName:SDLRPCParameterNameTimeoutCapitalized];
}

- (nullable NSNumber<SDLInt> *)Timeout {
    return [self.parameters sdl_objectForName:SDLRPCParameterNameTimeoutCapitalized ofClass:NSNumber.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
