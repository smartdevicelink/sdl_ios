//
//  PolicyDataParser.h
//

#import <Foundation/Foundation.h>

@interface SDLPolicyDataParser : NSObject

@property (assign) Byte protocolVersion;
@property (assign) BOOL isResponseRequired;
@property (assign) BOOL isHighBandwidth;
@property (assign) BOOL isSigned;
@property (assign) BOOL isEncrypted;
@property (assign) BOOL hasESN;
@property (assign) Byte serviceType;
@property (assign) Byte commandType;
@property (assign) BOOL CPUDestination;
@property (assign) Byte encryptionKeyIndex;
@property (assign) UInt32 payloadSize;
@property (strong) NSData *ESN;
@property (assign) UInt32 moduleMessageId;
@property (assign) UInt32 serverMessageId;
@property (assign) Byte messageStatus;
@property (strong) NSData *initializationVector;
@property (strong) NSData *payload;
@property (strong) NSData *signatureTag;

- (NSData *)unwrap:(NSData *)wrappedData;
- (void)parsePolicyData:(NSData *)data;

@end
