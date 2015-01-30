//
//  SDLProxyBase.h
//  SmartDeviceLink
//
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLProxyListener.h>
#import <SmartDeviceLink/SDLRPCRequest.h>
#import <SmartDeviceLink/SDLAbstractTransport.h>

#import <SmartDeviceLink/SDLAddCommand.h>

/*!
 @header SDLProxyBase.h
 
//TODO:Add header description if needed
 
 <p>SDLProxyBase is an abstract class which provides the
 basic structure for connecting to SDL vehicles.
 
 <p>//TODO: additional information as needed
 
 */

@interface SDLProxyBase : NSObject

-(instancetype)init NS_UNAVAILABLE;

/*!
 * @brief Initializes proxy for communicating between the App and SDL.
 *
 * @discussion Disconnects the application from SDL, then recreates the transport such that
 *             the next time a SDL unit discovers applications, this application will be
 *             available.
 *
 * @param Delegate that receives callbacks from SDL.
 *
 * @param appName - Name of the application displayed on SDL.
 *
 * @param isMediaApp - Indicates if the app is a media application.
 *
 * @param appID - Name of the application displayed on SDL.
 *
 * @param options - An optional dictionary specifying options for the proxy.
 */
-(instancetype)initWithProxyDelegate:(id<SDLProxyListener>)delegate
   enableAdvancedLifecycleManagement:(BOOL)enableAdvancedLifecycleManagement
                             appName:(NSString*)appName
                          isMediaApp:(NSNumber*)isMediaApp
                               appID:(NSString*)appID
                             options:(NSDictionary*)options;

-(void)cycleProxy;//TODO:Add with SDLDisconnectedReason
-(void)dispose;
-(NSString*)serializeJSON:(SDLRPCMessage*)message;
-(void)sendRPCRequest:(SDLRPCRequest*)request;
-(NSString*)stringFromSerializeRPCMessage:(SDLRPCMessage*)message;
-(void)endPutFileStream;
-(SDLTransportType)transportType;
-(NSTimeInterval)instanceTimeInterval;

@property (strong, nonatomic) NSString* applicationName;
@property (strong, nonatomic) NSString* ngnMediaScreenAppName;
@property (strong, nonatomic) NSString* applicationID;
@property (strong, nonatomic) NSString* connectionDetails;
@property (strong, nonatomic) NSString* policiesURLString;

+(void)enableSiphonDebug;
+(void)disableSiphonDebug;
+(void)enableDebugTool;
+(void)disableDebugTool;

//+(BOOL)isDebugEnabled;

//Helper Methods (More to be added)
-(void)addCommandWithCommandID:(NSNumber*)commandID menuText:(NSString*)menuText parentID:(NSNumber*)parentID position:(NSNumber*)position vrCommands:(NSArray*)vrCommands iconValue:(NSString*)iconValue iconType:(SDLImageType*)imageType correlationID:(NSNumber*)correlationID;
-(void)addSubMenuWithMenuID:(NSNumber*)menuID menuName:(NSString*)menuName correlationID:(NSNumber*)correlationID;

@end
