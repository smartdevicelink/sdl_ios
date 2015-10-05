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
        
        testStruct.allowed = [@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL]] copy];
        testStruct.userDisallowed = [@[[SDLHMILevel NONE], [SDLHMILevel LIMITED]] copy];
        
        expect(testStruct.allowed).to(equal([@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL]] copy]));
        expect(testStruct.userDisallowed).to(equal([@[[SDLHMILevel NONE], [SDLHMILevel LIMITED]] copy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_allowed:[@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL]] copy],
                                       NAMES_userDisallowed:[@[[SDLHMILevel NONE], [SDLHMILevel LIMITED]] copy]} mutableCopy];
        SDLParameterPermissions* testStruct = [[SDLParameterPermissions alloc] initWithDictionary:dict];
        
        expect(testStruct.allowed).to(equal([@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL]] copy]));
        expect(testStruct.userDisallowed).to(equal([@[[SDLHMILevel NONE], [SDLHMILevel LIMITED]] copy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLParameterPermissions* testStruct = [[SDLParameterPermissions alloc] init];
        
        expect(testStruct.allowed).to(beNil());
        expect(testStruct.userDisallowed).to(beNil());
    });
});

QuickSpecEnd