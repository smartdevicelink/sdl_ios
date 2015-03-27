//  SDLSyncProxyFactory.h
//



#import "SDLProxy.h"

@interface SDLProxyFactory : NSObject {}

+(SDLProxy*) buildSDLProxyWithListener:(NSObject<SDLProxyListener>*) listener;

+(SDLProxy*) buildSDLProxyWithListener:(NSObject<SDLProxyListener>*) listener
                              tcpIPAddress: (NSString*) ipaddress
                                   tcpPort: (NSString*) port;
@end
