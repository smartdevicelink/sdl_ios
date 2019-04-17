//  SDLEncodedSyncPData.m
//


#import "SDLEncodedSyncPData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLEncodedSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameEncodedSyncPData]) {
    }
    return self;
}

- (void)setData:(NSArray<NSString *> *)data {
    [parameters sdl_setObject:data forName:SDLRPCParameterNameData];
}

- (NSArray<NSString *> *)data {
    NSError *error = nil;
    return [parameters sdl_objectsForName:SDLRPCParameterNameData ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
