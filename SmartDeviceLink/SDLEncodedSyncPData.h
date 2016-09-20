//  SDLEncodedSyncPData.h
//


#import "SDLRPCRequest.h"

@interface SDLEncodedSyncPData : SDLRPCRequest {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) NSMutableArray<NSString *> *data;

@end
