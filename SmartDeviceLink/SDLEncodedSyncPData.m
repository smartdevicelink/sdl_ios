//  SDLEncodedSyncPData.m
//


#import "SDLEncodedSyncPData.h"

#import "SDLNames.h"

@implementation SDLEncodedSyncPData

- (instancetype)init {
    if (self = [super initWithName:NAMES_EncodedSyncPData]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (void)setData:(NSMutableArray<NSString *> *)data {
    if (data != nil) {
        [parameters setObject:data forKey:NAMES_data];
    } else {
        [parameters removeObjectForKey:NAMES_data];
    }
}

- (NSMutableArray<NSString *> *)data {
    return [parameters objectForKey:NAMES_data];
}

@end
