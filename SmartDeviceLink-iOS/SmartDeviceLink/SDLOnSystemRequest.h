//  SDLOnSystemRequest.h
//



#import "SDLRPCNotification.h"

#import "SDLRequestType.h"
#import "SDLFileType.h"

@interface SDLOnSystemRequest : SDLRPCNotification {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLRequestType* requestType;
@property(strong) NSString* url;
@property(strong) NSNumber* timeout;
@property(strong) SDLFileType* fileType;
@property(strong) NSNumber* offset;
@property(strong) NSNumber* length;

@end
