//
//  SDLBaseTransportConfig.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLAbstractTransport.h"

@interface SDLBaseTransportConfig : NSObject

@property (nonatomic) NSTimeInterval heartBeatTimeout;
@property (nonatomic) BOOL shareConnection;
@property (nonatomic) SDLTransportType transportType;

@end
