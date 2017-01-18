//  SDLSmartDeviceLinkProtocolMessageAssembler.h
//

#import <Foundation/Foundation.h>

@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

typedef void (^SDLMessageAssemblyCompletionHandler)(BOOL done,  SDLProtocolMessage * _Nullable assembledMessage);


@interface SDLProtocolMessageAssembler : NSObject

@property (assign, nonatomic, readonly) UInt8 sessionID;
@property (assign, nonatomic) UInt32 frameCount; // number of consecutive frames required for reassembly
@property (assign, nonatomic) UInt32 expectedBytes;

- (instancetype)initWithSessionID:(UInt8)sessionID;
- (void)handleMessage:(SDLProtocolMessage *)message withCompletionHandler:(SDLMessageAssemblyCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
