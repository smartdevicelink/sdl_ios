//
//  SDLSendLocationResponse.h
//  SmartDeviceLink-iOS

#import "SDLRPCResponse.h"

@interface SDLSendLocationResponse : SDLRPCResponse

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
