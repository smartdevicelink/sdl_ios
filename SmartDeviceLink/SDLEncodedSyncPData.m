//  SDLEncodedSyncPData.m
//


#import "SDLEncodedSyncPData.h"

#import "SDLNames.h"

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
