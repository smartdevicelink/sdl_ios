//
//  SDLConnectionProtocol.m
//  SmartDeviceLink-iOS
//
//  Created by CHDSEZ318988DADM on 11/08/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLConnectionProtocol.h"
#import "SDLDebugTool.h"
#import "SDLURLConnection.h"
#import "SDLURLSession.h"
#import <UIKit/UIKit.h>


@interface SDLConnectionProtocol () {
    id _delegate;
}
@property (nonatomic,strong) id connectionObject;

@end

@implementation SDLConnectionProtocol
- (id)initWithDelegate:(id<SDLConnectionDelegate>)delegate withDebugConsoleGroup:(NSString *)debugConsoleGroupName{
    self = [super init];
    if(self) {
        _delegate = delegate;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        self.connectionObject = [[SDLURLSession alloc] initWithDelegate:(id)self withDebugConsoleGroup:debugConsoleGroupName];
    }
    else {
        self.connectionObject = [[SDLURLConnection alloc] initWithDelegate:(id)self withDebugConsoleGroup:debugConsoleGroupName];
        
    }
    return self;
}

- (void)uploadTaskWithPData:(NSData *)data withRequest:(NSMutableURLRequest *)request withTimeout:(NSNumber*) timeout{
    [self.connectionObject uploadTaskWithPData:data withRequest:request withTimeout:timeout];
}

- (void)uploadTaskWithSystemProprietaryDictionary:(NSDictionary *)dictionary withURLString:(NSString *)urlString {
    [self.connectionObject uploadTaskWithSystemProprietaryDictionary:dictionary withURLString:urlString];
}


- (void) dataTaskForSystemRequestURLString:(NSString *)urlString {
    [self.connectionObject dataTaskForSystemRequestURLString:urlString];
}

- (void)cancelAndInvalidate {
    [self.connectionObject cancelAndInvalidate];
}
#pragma mark - connection delegate
-(void)syncPDatadataReady:(NSData*)data {
    if (_delegate && [_delegate respondsToSelector:@selector(SyncPDataNetworkRequestCompleteWithData:)]) {
        [_delegate SyncPDataNetworkRequestCompleteWithData:data];
    }
}

-(void) systemProprietarydataReady:(NSData*)data {
    if (_delegate && [_delegate respondsToSelector:@selector(handleSystemResponseProprietary:)]) {
        [_delegate  handleSystemResponseProprietary:data];
    }
}

-(void) systemQueueAppDataReady:(NSData*)data {
    if (_delegate && [_delegate respondsToSelector:@selector(handleSystemQueryAppsResponse:andTask:)]) {
        [_delegate  handleSystemQueryAppsResponse:data andTask:self];
    }
}

@end