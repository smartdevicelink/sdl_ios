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

- (void)setData:(NSMutableArray<NSString *> *)data {
    [parameters sdl_setObject:data forName:SDLNameData];
}

- (NSMutableArray<NSString *> *)data {
    return [parameters sdl_objectForName:SDLNameData];
}

@end

NS_ASSUME_NONNULL_END
