//
//  TestSmartConnectionManager.h
//  SmartDeviceLinkTests
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import <Foundation/Foundation.h>
#import "TestConnectionManager.h"
#import "TestSmartConnection.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SmartConnectionManagerBlock)(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error);

@interface TestSmartConnectionManager : TestConnectionManager

- (void)addConnectionModel:(TestSmartConnection *)model;

@property (copy, nullable) SmartConnectionManagerBlock lastRequestBlock;

@end

NS_ASSUME_NONNULL_END
