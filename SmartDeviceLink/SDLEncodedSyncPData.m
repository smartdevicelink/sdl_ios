//  SDLEncodedSyncPData.m
//


#import "SDLEncodedSyncPData.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLEncodedSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLNameEncodedSyncPData]) {
    }
    return self;
}

- (void)setData:(NSArray<NSString *> *)data {
    [parameters sdl_setObject:data forName:SDLNameData];
}

- (NSArray<NSString *> *)data {
    NSError *error;
    return [parameters sdl_objectsForName:SDLNameData ofClass:NSString.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
