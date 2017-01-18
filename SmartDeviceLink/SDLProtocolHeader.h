//  SDLProtocolHeader.h
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(UInt8, SDLFrameType) {
    SDLFrameType_Control = 0x00,
    SDLFrameType_Single = 0x01,
    SDLFrameType_First = 0x02,
    SDLFrameType_Consecutive = 0x03
};

typedef NS_ENUM(UInt8, SDLServiceType) {
    SDLServiceType_Control = 0x00,
    SDLServiceType_RPC = 0x07,
    SDLServiceType_Audio = 0x0A,
    SDLServiceType_Video = 0x0B,
    SDLServiceType_BulkData = 0x0F
};

typedef NS_ENUM(UInt8, SDLFrameData) {
    SDLFrameData_Heartbeat = 0x00,
    SDLFrameData_StartSession = 0x01,
    SDLFrameData_StartSessionACK = 0x02,
    SDLFrameData_StartSessionNACK = 0x03,
    SDLFrameData_EndSession = 0x04,
    SDLFrameData_EndSessionACK = 0x05,
    SDLFrameData_EndSessionNACK = 0x06,
    SDLFrameData_ServiceDataACK = 0xFE,
    SDLFrameData_HeartbeatACK = 0xFF,
    // If frameType == Single (0x01)
    SDLFrameData_SingleFrame = 0x00,
    // If frameType == First (0x02)
    SDLFrameData_FirstFrame = 0x00,
    // If frametype == Consecutive (0x03)
    SDLFrameData_ConsecutiveLastFrame = 0x00
};

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolHeader : NSObject <NSCopying> {
    UInt8 _version;
    NSUInteger _size;
}

@property (assign, nonatomic, readonly) UInt8 version;
@property (assign, nonatomic, readonly) NSUInteger size;
@property (assign, nonatomic) BOOL compressed __deprecated_msg("This is a mirror for encrypted");
@property (assign, nonatomic) BOOL encrypted;
@property (assign, nonatomic) SDLFrameType frameType;
@property (assign, nonatomic) SDLServiceType serviceType;
@property (assign, nonatomic) SDLFrameData frameData;
@property (assign, nonatomic) UInt8 sessionID;
@property (assign, nonatomic) UInt32 bytesInPayload;

- (instancetype)init;
- (nullable NSData *)data;
- (void)parse:(NSData *)data;
- (NSString *)description;
+ (__kindof SDLProtocolHeader *)headerForVersion:(UInt8)version;

@end

NS_ASSUME_NONNULL_END
