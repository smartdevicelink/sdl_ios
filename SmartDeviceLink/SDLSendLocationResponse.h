//
//  SDLSendLocationResponse.h
//  SmartDeviceLink-iOS

#import "SDLRPCResponse.h"

@interface SDLSendLocationResponse : SDLRPCResponse

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@end
