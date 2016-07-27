//
//  SDLOnHashChangeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnHashChange.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnHashChangeSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnHashChange* testNotification = [[SDLOnHashChange alloc] init];
        
        testNotification.hashID = @"hash";
        
        expect(testNotification.hashID).to(equal(@"hash"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_notification:
                                           @{NAMES_parameters:
                                                 @{NAMES_hashID:@"hash"},
                                             NAMES_operation_name:NAMES_OnHashChange}} mutableCopy];
        SDLOnHashChange* testNotification = [[SDLOnHashChange alloc] initWithDictionary:dict];
        
        expect(testNotification.hashID).to(equal(@"hash"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnHashChange* testNotification = [[SDLOnHashChange alloc] init];
        
        expect(testNotification.hashID).to(beNil());
    });
});

QuickSpecEnd