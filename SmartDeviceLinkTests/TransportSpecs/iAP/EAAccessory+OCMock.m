//
//  EAAccessory+OCMock.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/24/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <OCMock/OCMock.h>
#import <ExternalAccessory/ExternalAccessory.h>

// Based off of the Pebble Accessory OCKMock by Heiko Behrens https://github.com/HBehrens/PebbleKit-ios-sdk-test/blob/master/PebbleVendor/EAAccessoryFramework%2BOCMock.m

@implementation EAAccessory (OCMock)
static id coreMockDelegate = nil;
+ (EAAccessory *)sdlCoreMock {
    id mockEAAccessory = OCMClassMock([EAAccessory class]);
    OCMStub([mockEAAccessory protocolStrings]).andReturn(@[@"com.smartdevicelink.multisession"]);
    [[[mockEAAccessory stub] andReturnValue:OCMOCK_VALUE((NSString *)@"SDLTestHeadUnit")] name];
    OCMStub([mockEAAccessory modelNumber]).andReturn(@"0.0.0");
    OCMStub([mockEAAccessory serialNumber]).andReturn(@"123456");
    OCMStub([mockEAAccessory firmwareRevision]).andReturn(@"1.2.3");
    OCMStub([mockEAAccessory hardwareRevision]).andReturn(@"3.2.1");
    OCMStub([mockEAAccessory isConnected]).andReturn(OCMOCK_VALUE(YES));
    OCMStub([mockEAAccessory setDelegate:[OCMArg checkWithBlock:^BOOL(id obj) {
        coreMockDelegate = obj;
        return YES;
    }]]);
    OCMStub([mockEAAccessory delegate]).andCall(self, @selector(coreDelegate));
    [[[mockEAAccessory stub] andReturnValue:OCMOCK_VALUE((NSUInteger){5})] connectionID];

    return mockEAAccessory;
}
- (id)coreDelegate {
    return coreMockDelegate;
}
@end

@implementation EAAccessoryManager (OCMock)
+ (EAAccessoryManager *)mockManager {
    id mockEAAccessoryManager = OCMClassMock([EAAccessoryManager class]);
    id mockEAAccessory = [EAAccessory sdlCoreMock];
    OCMStub([mockEAAccessoryManager connectedAccessories]).andReturn(@[mockEAAccessory]);
    OCMStub([mockEAAccessory registerForLocalNotifications]);
    OCMStub([mockEAAccessory unregisterForLocalNotifications]);
    return mockEAAccessoryManager;
}
@end

@implementation EASession (OCMock)
+ (EASession *)mockSessionWithAccessory:(EAAccessory*)mockAccessory protocolString:(NSString*)mockProtocolString inputStream:(NSInputStream*)mockInputStream outputStream:(NSOutputStream*)mockOutputStream {
    id session = OCMClassMock([EASession class]);
    OCMStub([session accessory]).andReturn(mockAccessory);
    OCMStub([session protocolString]).andReturn(mockProtocolString);
    OCMStub([session inputStream]).andReturn(mockInputStream);
    OCMStub([session outputStream]).andReturn(mockOutputStream);
    return session;
}
@end

