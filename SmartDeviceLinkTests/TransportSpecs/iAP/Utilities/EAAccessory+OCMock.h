//
//  EAAccessory+OCMock.h
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 10/1/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OCMock/OCMock.h>
#import <ExternalAccessory/ExternalAccessory.h>

@interface EAAccessory (OCMock)

+ (EAAccessory *)sdlCoreMock;

@end

@interface EAAccessoryManager (OCMock)

+ (EAAccessoryManager *)mockManager;

@end

@interface EASession (OCMock)

+ (EASession *)mockSessionWithAccessory:(EAAccessory *)mockAccessory protocolString:(NSString *)mockProtocolString inputStream:(NSInputStream *)mockInputStream outputStream:(NSOutputStream *)mockOutputStream;

@end
