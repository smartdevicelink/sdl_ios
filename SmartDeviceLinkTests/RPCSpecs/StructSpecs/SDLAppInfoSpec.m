//
//  SDLAppInfoSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 7/30/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppInfo.h"
#import "SDLNames.h"

QuickSpecBegin(SDLAppInfoSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAppInfo* testStruct = [[SDLAppInfo alloc] init];
        
        testStruct.appDisplayName = @"display name";
        testStruct.appVersion = @"1.2.3.4";
        testStruct.appBundleID = @"com.app.bundle";
        
        expect(testStruct.appDisplayName).to(equal(@"display name"));
        expect(testStruct.appVersion).to(equal(@"1.2.3.4"));
        expect(testStruct.appBundleID).to(equal(@"com.app.bundle"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_appDisplayName:@"display name",
                                       NAMES_appVersion:@"1.2.3.4",
                                       NAMES_appBundleID:@"com.app.bundle"} mutableCopy];
        SDLAppInfo* testStruct = [[SDLAppInfo alloc] initWithDictionary:dict];
        
        expect(testStruct.appDisplayName).to(equal(@"display name"));
        expect(testStruct.appVersion).to(equal(@"1.2.3.4"));
        expect(testStruct.appBundleID).to(equal(@"com.app.bundle"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAppInfo* testStruct = [[SDLAppInfo alloc] init];
        
        expect(testStruct.appDisplayName).to(beNil());
        expect(testStruct.appVersion).to(beNil());
        expect(testStruct.appBundleID).to(beNil());
    });
});

QuickSpecEnd