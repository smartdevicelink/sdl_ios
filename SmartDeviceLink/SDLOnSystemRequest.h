//  SDLOnSystemRequest.h
//

#import "SDLRPCNotification.h"

#import "SDLFileType.h"
#import "SDLRequestType.h"


@interface SDLOnSystemRequest : SDLRPCNotification

@property (strong, nonatomic) SDLRequestType requestType;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSNumber<SDLInt> *timeout;
@property (strong, nonatomic) SDLFileType fileType;
@property (strong, nonatomic) NSNumber<SDLUInt> *offset;
@property (strong, nonatomic) NSNumber<SDLUInt> *length;

@end
