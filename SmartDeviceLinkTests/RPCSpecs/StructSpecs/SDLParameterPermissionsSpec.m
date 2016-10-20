//
//  SDLParameterPermissionsSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLParameterPermissions.h"
#import "SDLHMILevel.h"
#import "SDLNames.h"

QuickSpecBegin(SDLParameterPermissionsSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLParameterPermissions* testStruct = [[SDLParameterPermissions alloc] init];
        
        testStruct.allowed = [@[SDLHMILevelBackground, SDLHMILevelFull] copy];
        testStruct.userDisallowed = [@[SDLHMILevelNone, SDLHMILevelLimited] copy];
        
        expect(testStruct.allowed).to(equal([@[SDLHMILevelBackground, SDLHMILevelFull] copy]));
        expect(testStruct.userDisallowed).to(equal([@[SDLHMILevelNone, SDLHMILevelLimited] copy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameAllowed:[@[SDLHMILevelBackground, SDLHMILevelFull] copy],
                                       SDLNameUserDisallowed:[@[SDLHMILevelNone, SDLHMILevelLimited] copy]} mutableCopy];
        SDLParameterPermissions* testStruct = [[SDLParameterPermissions alloc] initWithDictionary:dict];
        
        expect(testStruct.allowed).to(equal([@[SDLHMILevelBackground, SDLHMILevelFull] copy]));
        expect(testStruct.userDisallowed).to(equal([@[SDLHMILevelNone, SDLHMILevelLimited] copy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLParameterPermissions* testStruct = [[SDLParameterPermissions alloc] init];
        
        expect(testStruct.allowed).to(beNil());
        expect(testStruct.userDisallowed).to(beNil());
    });
});

QuickSpecEnd
