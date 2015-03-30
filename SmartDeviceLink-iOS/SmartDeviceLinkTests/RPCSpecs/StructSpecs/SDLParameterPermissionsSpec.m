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
        
        testStruct.allowed = [@[[SDLHMILevel HMI_BACKGROUND], [SDLHMILevel HMI_FULL]] mutableCopy];
        testStruct.userDisallowed = [@[[SDLHMILevel HMI_NONE], [SDLHMILevel HMI_LIMITED]] mutableCopy];
        
        expect(testStruct.allowed).to(equal([@[[SDLHMILevel HMI_BACKGROUND], [SDLHMILevel HMI_FULL]] mutableCopy]));
        expect(testStruct.userDisallowed).to(equal([@[[SDLHMILevel HMI_NONE], [SDLHMILevel HMI_LIMITED]] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_allowed:[@[[SDLHMILevel HMI_BACKGROUND], [SDLHMILevel HMI_FULL]] mutableCopy],
                                       NAMES_userDisallowed:[@[[SDLHMILevel HMI_NONE], [SDLHMILevel HMI_LIMITED]] mutableCopy]} mutableCopy];
        SDLParameterPermissions* testStruct = [[SDLParameterPermissions alloc] initWithDictionary:dict];
        
        expect(testStruct.allowed).to(equal([@[[SDLHMILevel HMI_BACKGROUND], [SDLHMILevel HMI_FULL]] mutableCopy]));
        expect(testStruct.userDisallowed).to(equal([@[[SDLHMILevel HMI_NONE], [SDLHMILevel HMI_LIMITED]] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLParameterPermissions* testStruct = [[SDLParameterPermissions alloc] init];
        
        expect(testStruct.allowed).to(beNil());
        expect(testStruct.userDisallowed).to(beNil());
    });
});

QuickSpecEnd