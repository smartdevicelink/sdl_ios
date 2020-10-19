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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnSyncPData* testNotification = [[SDLOnSyncPData alloc] init];
#pragma clang diagnostic pop
        
        testNotification.URL = @"https://www.youtube.com/watch?v=ygr5AHufBN4";
        testNotification.Timeout = @8357;
        
        expect(testNotification.URL).to(equal(@"https://www.youtube.com/watch?v=ygr5AHufBN4"));
        expect(testNotification.Timeout).to(equal(@8357));
    });
    
    it(@"Should get correctly when initialized", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameNotification:
                                                   @{SDLRPCParameterNameParameters:
                                                         @{SDLRPCParameterNameURLUppercase:@"https://www.youtube.com/watch?v=ygr5AHufBN4",
                                                           SDLRPCParameterNameTimeoutCapitalized:@8357},
                                                     SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnSyncPData}};
#pragma clang diagnostic pop

        SDLOnSyncPData* testNotification = [[SDLOnSyncPData alloc] initWithDictionary:dict];
        
        expect(testNotification.URL).to(equal(@"https://www.youtube.com/watch?v=ygr5AHufBN4"));
        expect(testNotification.Timeout).to(equal(@8357));
    });
    
    it(@"Should return nil if not set", ^ {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnSyncPData* testNotification = [[SDLOnSyncPData alloc] init];
#pragma clang diagnostic pop
        
        expect(testNotification.URL).to(beNil());
        expect(testNotification.Timeout).to(beNil());
    });
});

QuickSpecEnd
