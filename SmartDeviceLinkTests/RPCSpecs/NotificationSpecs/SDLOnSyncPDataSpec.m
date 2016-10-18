//
//  SDLOnSyncPDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnSyncPData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnSyncPDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnSyncPData* testNotification = [[SDLOnSyncPData alloc] init];
        
        testNotification.URL = @"https://www.youtube.com/watch?v=ygr5AHufBN4";
        testNotification.Timeout = @8357;
        
        expect(testNotification.URL).to(equal(@"https://www.youtube.com/watch?v=ygr5AHufBN4"));
        expect(testNotification.Timeout).to(equal(@8357));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameNotification:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameURLUppercase:@"https://www.youtube.com/watch?v=ygr5AHufBN4",
                                                                   SDLNameTimeoutCapitalized:@8357},
                                                             SDLNameOperationName:SDLNameOnSyncPData}} mutableCopy];
        SDLOnSyncPData* testNotification = [[SDLOnSyncPData alloc] initWithDictionary:dict];
        
        expect(testNotification.URL).to(equal(@"https://www.youtube.com/watch?v=ygr5AHufBN4"));
        expect(testNotification.Timeout).to(equal(@8357));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnSyncPData* testNotification = [[SDLOnSyncPData alloc] init];
        
        expect(testNotification.URL).to(beNil());
        expect(testNotification.Timeout).to(beNil());
    });
});

QuickSpecEnd
