//  SDLSyncProxyFactory.m
//

#import "SDLProxyFactory.h"

#import "SDLDebugTool.h"
#import "SDLIAPTransport.h"
#import "SDLProtocol.h"
#import "SDLProxy.h"
#import "SDLTCPTransport.h"


@implementation SDLProxyFactory

+ (SDLProxy *)buildSDLProxyWithListener:(NSObject<SDLProxyListener> *)delegate {
    SDLIAPTransport *transport = [[SDLIAPTransport alloc] init];
    SDLProtocol *protocol = [[SDLProtocol alloc] init];
    SDLProxy *ret = [[SDLProxy alloc] initWithTransport:transport protocol:protocol delegate:delegate];

    return ret;
}

+ (SDLProxy *)buildSDLProxyWithListener:(NSObject<SDLProxyListener> *)delegate
                           tcpIPAddress:(NSString *)ipaddress
                                tcpPort:(NSString *)port {
    SDLTCPTransport *transport = [[SDLTCPTransport alloc] init];
    transport.hostName = ipaddress;
    transport.portNumber = port;

    SDLProtocol *protocol = [[SDLProtocol alloc] init];

    SDLProxy *ret = [[SDLProxy alloc] initWithTransport:transport protocol:protocol delegate:delegate];

    return ret;
}

@end
