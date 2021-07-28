//
//  TestSmartConnection.h
//  SmartDeviceLinkTests
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import <Foundation/Foundation.h>
#import "SDLRPCRequest.h"
#import "SDLRPCResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestSmartConnection : NSObject
@property (nonatomic, strong, nullable) SDLRPCRequest *request;
@property (nonatomic, strong, nullable) SDLRPCResponse *response;
@property (nonatomic, strong, nullable) NSError *error;
@property (nonatomic, assign) BOOL oneTimeUse;
@end

NS_ASSUME_NONNULL_END
