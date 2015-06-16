//  SDLSmartDeviceLinkProtocolMessage.h
//

@import Foundation;

#import "SDLProtocolHeader.h"

@interface SDLProtocolMessage : NSObject

@property (strong) SDLProtocolHeader *header;
@property (strong) NSData *payload;
@property (strong, readonly) NSData *data;
@property (nonatomic) Byte sessionID;
@property (nonatomic) Byte version;
@property (nonatomic) Byte rpcType;
@property (nonatomic) SDLServiceType sessionType;
@property (strong, nonatomic) NSNumber* functionID;
@property (strong, nonatomic) NSNumber* correlationID;
@property (strong, nonatomic) NSData* bulkData;

+ (id)messageWithHeader:(SDLProtocolHeader*)header andPayload:(NSData *)payload; // Returns a V1 or V2 object

- (NSUInteger)size;
- (NSString *)description;
- (NSDictionary *)rpcDictionary; // Use for RPC type messages to obtain the data in a dictionary

+ (UInt8)determineVersion:(NSData *)data;


@end
