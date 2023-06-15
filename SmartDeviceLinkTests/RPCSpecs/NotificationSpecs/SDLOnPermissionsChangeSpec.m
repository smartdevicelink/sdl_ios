//
//  SDLOnPermissionsChangeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

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
        SDLOnPermissionsChange* testNotification = [[SDLOnPermissionsChange alloc] initWithDictionary:dict];
        
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
