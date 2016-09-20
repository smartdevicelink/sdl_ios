//  SDLSyncPData.h
//


#import "SDLRPCRequest.h"

@interface SDLSyncPData : SDLRPCRequest {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@end
