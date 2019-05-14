//  SDLOnRCStatusSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLOnRCStatus.h"
#import "SDLModuleData.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLOnRCStatusSpec)
SDLModuleData * allocatedModule = [[SDLModuleData alloc] init];
SDLModuleData * freeModule = [[SDLModuleData alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLOnRCStatus* testNotification = [[SDLOnRCStatus alloc] init];
        testNotification.allowed = @YES;
        testNotification.allocatedModules = [@[allocatedModule] copy];
        testNotification.freeModules = [@[freeModule] copy];

        expect(testNotification.allowed).to(equal(@YES));
        expect(testNotification.allocatedModules).to(equal([@[allocatedModule] copy]));
        expect(testNotification.freeModules).to(equal([@[freeModule] copy]));

    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameNotification:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameAllocatedModules:[@[allocatedModule] copy],
                                                                   SDLRPCParameterNameFreeModules:[@[freeModule] copy],
                                                                   SDLRPCParameterNameAllowed:@YES
                                                                   },
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameOnRCStatus}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLOnRCStatus* testNotification = [[SDLOnRCStatus alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testNotification.allowed).to(equal(@YES));
        expect(testNotification.allocatedModules).to(equal([@[allocatedModule] copy]));
        expect(testNotification.freeModules).to(equal([@[freeModule] copy]));
    });

    it(@"Should return nil if not set", ^ {
        SDLOnRCStatus* testNotification = [[SDLOnRCStatus alloc] init];

        expect(testNotification.allowed).to(beNil());
        expect(testNotification.allocatedModules).to(beNil());
        expect(testNotification.freeModules).to(beNil());
    });
});

QuickSpecEnd
