//  SDLRequestType.h
//



#import "SDLEnum.h"

@interface SDLRequestType : SDLEnum {}

+(SDLRequestType*) valueOf:(NSString*) value;
+(NSArray*) values;

+(SDLRequestType*) HTTP;
+(SDLRequestType*) FILE_RESUME;
+(SDLRequestType*) AUTH_REQUEST;
+(SDLRequestType*) AUTH_CHALLENGE;
+(SDLRequestType*) AUTH_ACK;
+(SDLRequestType*) PROPRIETARY;

@end
