//
//  TestSmartConnectionManager.m
//  SmartDeviceLinkTests
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import "TestSmartConnectionManager.h"
#import "SDLGetSystemCapability.h"

@interface TestSmartConnectionManager ()
@property (nonatomic, strong) NSMutableArray *connectionMap;
@end

@implementation TestSmartConnectionManager

- (instancetype)init {
    if ((self = [super init])) {
        _connectionMap = [[NSMutableArray alloc] initWithCapacity:8];
    }
    return self;
}

- (void)addConnectionModel:(TestSmartConnection *)model {
    if (model) {
        [self.connectionMap addObject:model];
    }
}

- (void)sendConnectionRequest:(__kindof SDLRPCRequest *)request withResponseHandler:(nullable SDLResponseHandler)handler {
    [super sendConnectionRequest:request withResponseHandler:handler];

    TestSmartConnection *connectionModel = [self connectionModelForRequest:request];
    if (connectionModel) {
        if (handler) {
            handler(request, connectionModel.response, connectionModel.error);
        }
        if (connectionModel.oneTimeUse) {
            [self.connectionMap removeObject:connectionModel];
        }
    }
}

- (nullable TestSmartConnection *)connectionModelForRequest:(__kindof SDLRPCRequest *)request {
    if (!request || !self.connectionMap.count) {
        return nil;
    }
    for (TestSmartConnection *aModel in self.connectionMap) {
        SDLRPCRequest *modelRequest = aModel.request;
        if ([modelRequest isKindOfClass:[SDLGetSystemCapability class]] && [request isKindOfClass:[SDLGetSystemCapability class]]) {
            SDLGetSystemCapability *getSCRequest1 = (SDLGetSystemCapability *)modelRequest;
            SDLGetSystemCapability *getSCRequest2 = (SDLGetSystemCapability *)request;
            if ([getSCRequest1.systemCapabilityType isEqualToEnum:getSCRequest2.systemCapabilityType]) {
                return aModel;
            }
        }
    }
    return nil;
}

@end
