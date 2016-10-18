//
//  SDLOnEncodedSyncPDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnEncodedSyncPData.h"
#import "SDLNames.h"

QuickSpecBegin(SDLOnEncodedSyncPDataSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnEncodedSyncPData* testNotification = [[SDLOnEncodedSyncPData alloc] init];
        
        testNotification.data = [@[@0] mutableCopy];
        testNotification.URL = @"www.zombo.com";
        testNotification.Timeout = @564;
        
        expect(testNotification.data).to(equal([@[@0] mutableCopy]));
        expect(testNotification.URL).to(equal(@"www.zombo.com"));
        expect(testNotification.Timeout).to(equal(@564));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameNotification:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameData:[@[@0] mutableCopy],
                                                                   SDLNameURLUppercase:@"www.zombo.com",
                                                                   SDLNameTimeoutCapitalized:@564},
                                                             SDLNameOperationName:SDLNameOnEncodedSyncPData}} mutableCopy];
        SDLOnEncodedSyncPData* testNotification = [[SDLOnEncodedSyncPData alloc] initWithDictionary:dict];
        
        expect(testNotification.data).to(equal([@[@0] mutableCopy]));
        expect(testNotification.URL).to(equal(@"www.zombo.com"));
        expect(testNotification.Timeout).to(equal(@564));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnEncodedSyncPData* testNotification = [[SDLOnEncodedSyncPData alloc] init];
        
        expect(testNotification.data).to(beNil());
        expect(testNotification.URL).to(beNil());
        expect(testNotification.Timeout).to(beNil());
    });
});

QuickSpecEnd
