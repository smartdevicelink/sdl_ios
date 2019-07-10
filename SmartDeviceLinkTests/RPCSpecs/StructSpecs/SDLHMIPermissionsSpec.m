//
//  SDLHMIPermissionsSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMIPermissions.h"
#import "SDLHMILevel.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLHMIPermissionsSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLHMIPermissions* testStruct = [[SDLHMIPermissions alloc] init];
        
        testStruct.allowed = [@[SDLHMILevelBackground, SDLHMILevelFull] copy];
        testStruct.userDisallowed = [@[SDLHMILevelNone, SDLHMILevelLimited] copy];
        
        expect(testStruct.allowed).to(equal([@[SDLHMILevelBackground, SDLHMILevelFull] copy]));
        expect(testStruct.userDisallowed).to(equal([@[SDLHMILevelNone, SDLHMILevelLimited] copy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameAllowed:[@[SDLHMILevelBackground, SDLHMILevelFull] copy],
                                       SDLRPCParameterNameUserDisallowed:[@[SDLHMILevelNone, SDLHMILevelLimited] copy]} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLHMIPermissions* testStruct = [[SDLHMIPermissions alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.allowed).to(equal([@[SDLHMILevelBackground, SDLHMILevelFull] copy]));
        expect(testStruct.userDisallowed).to(equal([@[SDLHMILevelNone, SDLHMILevelLimited] copy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLHMIPermissions* testStruct = [[SDLHMIPermissions alloc] init];
        
        expect(testStruct.allowed).to(beNil());
        expect(testStruct.userDisallowed).to(beNil());
    });
});

QuickSpecEnd
