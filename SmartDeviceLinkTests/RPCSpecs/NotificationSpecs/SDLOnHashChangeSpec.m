//
//  SDLOnHashChangeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

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
        SDLOnHashChange* testNotification = [[SDLOnHashChange alloc] initWithDictionary:dict];
        
        expect(testNotification.hashID).to(equal(@"hash"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLOnHashChange* testNotification = [[SDLOnHashChange alloc] init];
        
        expect(testNotification.hashID).to(beNil());
    });
});

QuickSpecEnd
