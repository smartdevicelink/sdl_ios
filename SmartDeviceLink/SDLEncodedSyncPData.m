//  SDLEncodedSyncPData.m
//


#import "SDLEncodedSyncPData.h"

#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLEncodedSyncPData

- (instancetype)init {
    if (self = [super initWithName:SDLNameEncodedSyncPData]) {
    }
    return self;
}

- (void)setData:(NSMutableArray<NSString *> *)data {
    if (data != nil) {
        [parameters setObject:data forKey:SDLNameData];
    } else {
        [parameters removeObjectForKey:SDLNameData];
    }
}

- (NSMutableArray<NSString *> *)data {
    return [parameters objectForKey:SDLNameData];
}

@end

NS_ASSUME_NONNULL_END
