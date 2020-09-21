//  SDLEncodedSyncPData.m
//


#import "SDLEncodedSyncPData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
@implementation SDLEncodedSyncPData
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameEncodedSyncPData]) {
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

@end

NS_ASSUME_NONNULL_END
