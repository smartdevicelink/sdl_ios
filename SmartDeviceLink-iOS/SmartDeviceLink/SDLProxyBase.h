//
//  SDLProxyBase.h
//  SmartDeviceLink
//
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLProxyListener.h"
#import "SDLRPCRequest.h"
#import "SDLAbstractTransport.h"
#import "SDLAddCommand.h"
#import "SDLProxyALMOptions.h"
#import "SDLImageType.h"
#import "SDLDisconnectReason.h"

static NSString* SDLInvalidArgumentException;

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
 *
 * @exception Throws an exception when required parameters or objects are not set.
 */
-(instancetype)initWithProxyDelegate:(NSObject<SDLProxyListener>*)delegate
   enableAdvancedLifecycleManagement:(BOOL)enableAdvancedLifecycleManagement
                             appName:(NSString*)appName
                          isMediaApp:(NSNumber*)isMediaApp
                               appID:(NSString*)appID
                             options:(SDLProxyALMOptions*)options;

-(void)cycleProxy:(SDLDisconnectReason)reason;//TODO:Add with SDLDisconnectedReason?
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

//TODO:Add helper methods
//Helper Methods (More to be added)
-(void)addCommandWithCommandID:(NSNumber*)commandID menuText:(NSString*)menuText parentID:(NSNumber*)parentID position:(NSNumber*)position vrCommands:(NSArray*)vrCommands iconValue:(NSString*)iconValue iconType:(SDLImageType*)imageType correlationID:(NSNumber*)correlationID;
-(void)addSubMenuWithMenuID:(NSNumber*)menuID menuName:(NSString*)menuName correlationID:(NSNumber*)correlationID;

@end
