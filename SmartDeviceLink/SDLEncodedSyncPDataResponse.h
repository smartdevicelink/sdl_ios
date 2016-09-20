//  SDLEncodedSyncPDataResponse.h
//


#import "SDLRPCResponse.h"

@interface SDLEncodedSyncPDataResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@end
