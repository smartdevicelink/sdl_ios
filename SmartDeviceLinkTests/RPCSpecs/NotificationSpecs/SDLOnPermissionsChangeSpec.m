//
//  SDLOnPermissionsChangeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnPermissionsChange.h"
#import "SDLPermissionItem.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLOnPermissionsChangeSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLPermissionItem *testPermissionItem = nil;
    
    beforeEach(^{
        testPermissionItem = [[SDLPermissionItem alloc] init];
    });

    it(@"Should set and get correctly", ^ {
        SDLOnPermissionsChange *testNotification = [[SDLOnPermissionsChange alloc] init];
        
        testNotification.permissionItem = [@[testPermissionItem] mutableCopy];
        testNotification.requireEncryption = @YES;

        expect(testNotification.permissionItem).to(equal([@[testPermissionItem] mutableCopy]));
        expect(testNotification.requireEncryption.boolValue).to(beTrue());
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameNotification:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNamePermissionItem:@[testPermissionItem],
                                                                   SDLRPCParameterNameRequireEncryption:@YES}, SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnPermissionsChange}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnPermissionsChange* testNotification = [[SDLOnPermissionsChange alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.permissionItem).to(equal([@[testPermissionItem] mutableCopy]));
        expect(testNotification.requireEncryption.boolValue).to(beTrue());
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnPermissionsChange *testNotification = [[SDLOnPermissionsChange alloc] init];
        
        expect(testNotification.permissionItem).to(beNil());
        expect(testNotification.requireEncryption.boolValue).to(beFalse());
    });
});

QuickSpecEnd
