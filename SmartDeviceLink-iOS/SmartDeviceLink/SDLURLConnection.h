//
//  SDLURLConnection.h
//  SmartDeviceLink-iOS
//
//  Created by CHDSEZ318988DADM on 11/08/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SDLURLConnectionDelegate

-(void)syncPDatadataReady:(NSData*)data;
-(void)systemProprietarydataReady:(NSData*)data;
-(void)systemQueueAppDataReady:(NSData*)data;

@end

@interface SDLURLConnection : NSObject<NSURLConnectionDataDelegate>

-(id)initWithDelegate:(id<SDLURLConnectionDelegate>)delegate withDebugConsoleGroup:(NSString*)debugConsoleGroupName ;

- (void) uploadTaskWithPData:(NSData*)data withRequest:(NSMutableURLRequest*)request withTimeout:(NSNumber*) timeout;

- (void)uploadTaskWithSystemProprietaryDictionary:(NSDictionary *)dictionary withURLString:(NSString *)urlString;

- (void) dataTaskForSystemRequestURLString:(NSString *)urlString;

- (void) cancelAndInvalidate;
@end
