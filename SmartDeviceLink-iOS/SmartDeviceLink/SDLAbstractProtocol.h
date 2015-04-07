//  SDLAbstractProtocol.h
//

#import "SDLInterfaceProtocol.h"
#import "SDLTransport.h"
#import "SDLProtocolListener.h"


@interface SDLAbstractProtocol : NSObject<SDLInterfaceProtocol>

@property (strong) NSString *debugConsoleGroupName;
@property (strong) id<SDLTransport> transport;
@property (weak) id<SDLProtocolListener> protocolDelegate;

@end
