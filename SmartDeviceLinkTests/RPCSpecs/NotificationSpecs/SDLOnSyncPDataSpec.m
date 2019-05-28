//
//  SDLOnSyncPDataSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnSyncPData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

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
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameNotification:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameURLUppercase:@"https://www.youtube.com/watch?v=ygr5AHufBN4",
                                                                   SDLRPCParameterNameTimeoutCapitalized:@8357},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnSyncPData}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnSyncPData* testNotification = [[SDLOnSyncPData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
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
