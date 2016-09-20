//  SDLSyncPDataResponse.h
//


#import "SDLRPCResponse.h"

@interface SDLSyncPDataResponse : SDLRPCResponse {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@end
