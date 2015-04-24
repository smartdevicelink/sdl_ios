//
//  SDLOnPermissionsChangeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnPermissionsChange.h"
#import "SDLPermissionItem.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnPermissionsChangeSpec)

SDLPermissionItem* item = [[SDLPermissionItem alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnPermissionsChange* testNotification = [[SDLOnPermissionsChange alloc] init];
        
        testNotification.permissionItem = [@[item] mutableCopy];
        
        expect(testNotification.permissionItem).to(equal([@[item] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_permissionItem:[@[item] mutableCopy]},
                                             NAMES_operation_name:NAMES_OnPermissionsChange}} mutableCopy];
        SDLOnPermissionsChange* testNotification = [[SDLOnPermissionsChange alloc] initWithDictionary:dict];
        
        expect(testNotification.permissionItem).to(equal([@[item] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnPermissionsChange* testNotification = [[SDLOnPermissionsChange alloc] init];
        
        expect(testNotification.permissionItem).to(beNil());
    });
});

QuickSpecEnd