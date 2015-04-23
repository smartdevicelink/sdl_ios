//  SDLRPCMessageType.h
//



#import "SDLEnum.h"

/**
 Declare the RPC Mesage types (request / response / notification)
 */
@interface SDLRPCMessageType : SDLEnum {}

/**
 @abstract get a SDLRPCMessageType object from value
 @param value NSString
 @return SDLRPCMessageType
 */
+(SDLRPCMessageType*) valueOf:(NSString*) value;
/**
 @abstract declare an array to store all possible values of Message Types
 @return the array
 */
+(NSMutableArray*) values;

/**
 @abstract SDLRPCMessageType : request
 @return the SDLRPCMessageType object with value of *request*
 */
+(SDLRPCMessageType*) request;
/**
 @abstract SDLRPCMessageType : response
 @return the SDLRPCMessageType object with value of *response*
 */
+(SDLRPCMessageType*) response;
/**
 @abstract SDLRPCMessageType : notification
 @return the SDLRPCMessageType object with value of *notification*
 */
+(SDLRPCMessageType*) notification;

@end
