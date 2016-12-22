//  SDLOnSystemRequest.h
//

#import "SDLRPCNotification.h"

#import "SDLFileType.h"
#import "SDLRequestType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnSystemRequest : SDLRPCNotification

@property (strong) SDLRequestType requestType;
@property (nullable, strong) NSString *url;
@property (nullable, strong) NSNumber<SDLInt> *timeout;
@property (nullable, strong) SDLFileType fileType;
@property (nullable, strong) NSNumber<SDLUInt> *offset;
@property (nullable, strong) NSNumber<SDLUInt> *length;

@end

NS_ASSUME_NONNULL_END
