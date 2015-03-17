//  SDLRPCMessageType.h
//



#import "SDLEnum.h"

/*!
 Declare the RPC Mesage types (request / response / notification)
 */
@interface SDLRPCMessageType : SDLEnum {}

/*!
 @abstract get a SDLRPCMessageType object from value
 @param value NSString
 @result return SDLRPCMessageType
 */
+(SDLRPCMessageType*) valueOf:(NSString*) value;
/*!
 @abstract declare an array to store all possible values of Message Types
 @result return the array
 */
+(NSMutableArray*) values;

/*!
 @abstract SDLRPCMessageType : request
 @result return the SDLRPCMessageType object with value of <font color=gray><i> request </i></font>
 */
+(SDLRPCMessageType*) request;
/*!
 @abstract SDLRPCMessageType : response
 @result return the SDLRPCMessageType object with value of <font color=gray><i> response </i></font>
 */
+(SDLRPCMessageType*) response;
/*!
 @abstract SDLRPCMessageType : notification
 @result return the SDLRPCMessageType object with value of <font color=gray><i> notification </i></font>
 */
+(SDLRPCMessageType*) notification;

@end
