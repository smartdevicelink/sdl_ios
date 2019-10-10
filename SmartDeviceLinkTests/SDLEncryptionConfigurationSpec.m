//
//  SDLEncryptionConfigurationSpec.m
//  SmartDeviceLinkTests
//
//  Created by standa1 on 7/17/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <VideoToolbox/VideoToolbox.h>

#import "SDLEncryptionConfiguration.h"

#import "SDLFakeSecurityManager.h"

QuickSpecBegin(SDLEncryptionConfigurationSpec)

describe(@"a streaming media configuration", ^{
    __block SDLEncryptionConfiguration *testConfig = nil;
    
    context(@"That is created with a full initializer", ^{
        __block SDLFakeSecurityManager *testFakeSecurityManager = nil;
        
        beforeEach(^{
            testFakeSecurityManager = [[SDLFakeSecurityManager alloc] init];
            
            testConfig = [[SDLEncryptionConfiguration alloc] initWithSecurityManagers:@[testFakeSecurityManager.class] delegate:nil];
        });
        
        it(@"should have properly set properties", ^{
            expect(testConfig.securityManagers).to(contain(testFakeSecurityManager.class));
        });
    });
    
    context(@"That is created with init", ^{
        beforeEach(^{
            testConfig = [[SDLEncryptionConfiguration alloc] init];
        });
        
        it(@"should have all properties nil", ^{
            expect(testConfig.securityManagers).to(beNil());
        });
    });
});

QuickSpecEnd
