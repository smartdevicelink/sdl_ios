//  SDLProtocolHeader.h
//

#import <Foundation/Foundation.h>

#import "SDLProtocolConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLProtocolHeader : NSObject <NSCopying> {
    UInt8 _version;
    NSUInteger _size;
}

@property (assign, nonatomic, readonly) UInt8 version;
@property (assign, nonatomic, readonly) NSUInteger size;
@property (assign, nonatomic) BOOL encrypted;
@property (assign, nonatomic) SDLFrameType frameType;
@property (assign, nonatomic) SDLServiceType serviceType;
@property (assign, nonatomic) SDLFrameInfo frameData;
@property (assign, nonatomic) UInt8 sessionID;
@property (assign, nonatomic) UInt32 bytesInPayload;

- (instancetype)init;
- (nullable NSData *)data;
- (void)parse:(NSData *)data;
- (NSString *)description;
+ (__kindof SDLProtocolHeader *)headerForVersion:(UInt8)version;
+ (UInt8)determineVersion:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
