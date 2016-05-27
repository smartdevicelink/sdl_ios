//
//  SDLHMIPermissionsSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMIPermissions.h"
#import "SDLHMILevel.h"
#import "SDLNames.h"

QuickSpecBegin(SDLHMIPermissionsSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLHMIPermissions* testStruct = [[SDLHMIPermissions alloc] init];
        
        testStruct.allowed = [@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL]] copy];
        testStruct.userDisallowed = [@[[SDLHMILevel NONE], [SDLHMILevel LIMITED]] copy];
        
        expect(testStruct.allowed).to(equal([@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL]] copy]));
        expect(testStruct.userDisallowed).to(equal([@[[SDLHMILevel NONE], [SDLHMILevel LIMITED]] copy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_allowed:[@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL]] copy],
                                       NAMES_userDisallowed:[@[[SDLHMILevel NONE], [SDLHMILevel LIMITED]] copy]} mutableCopy];
        SDLHMIPermissions* testStruct = [[SDLHMIPermissions alloc] initWithDictionary:dict];
        
        expect(testStruct.allowed).to(equal([@[[SDLHMILevel BACKGROUND], [SDLHMILevel FULL]] copy]));
        expect(testStruct.userDisallowed).to(equal([@[[SDLHMILevel NONE], [SDLHMILevel LIMITED]] copy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLHMIPermissions* testStruct = [[SDLHMIPermissions alloc] init];
        
        expect(testStruct.allowed).to(beNil());
        expect(testStruct.userDisallowed).to(beNil());
    });
});

QuickSpecEnd