//
//  PolicyDataParser.h
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLPolicyDataParser : NSObject

@property (assign, nonatomic) Byte protocolVersion;
@property (assign, nonatomic) BOOL isResponseRequired;
@property (assign, nonatomic) BOOL isHighBandwidth;
@property (assign, nonatomic) BOOL isSigned;
@property (assign, nonatomic) BOOL isEncrypted;
@property (assign, nonatomic) BOOL hasESN;
@property (assign, nonatomic) Byte serviceType;
@property (assign, nonatomic) Byte commandType;
@property (assign, nonatomic) BOOL CPUDestination;
@property (assign, nonatomic) Byte encryptionKeyIndex;
@property (assign, nonatomic) UInt32 payloadSize;
@property (strong, nonatomic) NSData *ESN;
@property (assign, nonatomic) UInt32 moduleMessageId;
@property (assign, nonatomic) UInt32 serverMessageId;
@property (assign, nonatomic) Byte messageStatus;
@property (strong, nonatomic) NSData *initializationVector;
@property (strong, nonatomic) NSData *payload;
@property (strong, nonatomic) NSData *signatureTag;

- (nullable NSData *)unwrap:(NSData *)wrappedData;
- (void)parsePolicyData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
