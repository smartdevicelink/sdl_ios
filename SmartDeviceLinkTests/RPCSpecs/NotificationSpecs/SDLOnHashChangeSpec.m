//
//  SDLOnHashChangeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnHashChange.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLOnHashChangeSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnHashChange* testNotification = [[SDLOnHashChange alloc] init];
        
        testNotification.hashID = @"hash";
        
        expect(testNotification.hashID).to(equal(@"hash"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameNotification:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameHashId:@"hash"},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnHashChange}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnHashChange* testNotification = [[SDLOnHashChange alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testNotification.hashID).to(equal(@"hash"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnHashChange* testNotification = [[SDLOnHashChange alloc] init];
        
        expect(testNotification.hashID).to(beNil());
    });
});

QuickSpecEnd
