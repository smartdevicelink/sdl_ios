//  SDLOnSystemRequest.h
//

#import "SDLRPCNotification.h"

#import "SDLFileType.h"
#import "SDLRequestType.h"


@interface SDLOnSystemRequest : SDLRPCNotification

@property (strong) SDLRequestType requestType;
@property (strong) NSString *url;
@property (strong) NSNumber<SDLInt> *timeout;
@property (strong) SDLFileType fileType;
@property (strong) NSNumber<SDLUInt> *offset;
@property (strong) NSNumber<SDLUInt> *length;

@end
