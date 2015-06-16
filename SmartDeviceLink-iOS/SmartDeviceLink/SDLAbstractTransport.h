//  SDLAbstractTransport.h

@import Foundation;

#import "SDLTransportDelegate.h"

@class SDLBaseTransportConfig;

typedef NS_ENUM(NSUInteger, SDLTransportType){
    SDLTransportTypeiAP,
    SDLTransportTypeTCP
};

@interface SDLAbstractTransport : NSObject<SDLTransport>

@property (weak) id<SDLTransportDelegate> delegate;
@property (strong) NSString *debugConsoleGroupName;
@property (strong, readonly) NSString* endpointName;
@property (strong, readonly) NSString* endpointParam;
@property (nonatomic) SDLTransportType transportType;
@property (strong, nonatomic) NSString* notificationComment;
@property (nonatomic, getter=isConnected, readonly) BOOL connected;

-(instancetype)initWithEndpoint:(NSString*) endpoint endpointParam:(NSString*) endointParam;
-(instancetype)initWithTransportConfig:(SDLBaseTransportConfig*)transportConfig delegate:(id<SDLTransportDelegate>)delegate;
- (void)notifyTransportConnected;
- (void)notifyTransportDisconnected;
- (void)handleDataReceivedFromTransport:(NSData *)receivedData;

@end
