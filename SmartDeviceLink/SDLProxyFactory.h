//  SDLProxyFactory.h
//

#import <Foundation/Foundation.h>

#import "SDLProxyListener.h"

@class SDLProxy;

__deprecated_msg("Use SDLManager instead")
    @interface SDLProxyFactory : NSObject {
}

+ (SDLProxy *)buildSDLProxyWithListener:(NSObject<SDLProxyListener> *)listener;

+ (SDLProxy *)buildSDLProxyWithListener:(NSObject<SDLProxyListener> *)listener
                           tcpIPAddress:(NSString *)ipaddress
                                tcpPort:(NSString *)port;
@end
