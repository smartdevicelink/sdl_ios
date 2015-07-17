//  SDLAbstractTransport.h

@import Foundation;

#import "SDLTransportDelegate.h"

typedef NS_ENUM(NSUInteger, SDLProxyTransportType) {
    SDLProxyTransportTypeUnknown,
    SDLProxyTransportTypeTCP,
    SDLProxyTransportTypeIAP
};

@interface SDLAbstractTransport : NSObject

@property (weak) id<SDLTransportDelegate> delegate;
@property (strong) NSString *debugConsoleGroupName;

- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)dataToSend;
- (void)dispose;
- (double)retryDelay;

@end