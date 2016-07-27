//
//  SDLResetGlobalPropertiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLResetGlobalProperties.h"
#import "SDLGlobalProperty.h"
#import "SDLNames.h"

QuickSpecBegin(SDLResetGlobalPropertiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLResetGlobalProperties* testRequest = [[SDLResetGlobalProperties alloc] init];
        
        testRequest.properties = [@[[SDLGlobalProperty MENUNAME], [SDLGlobalProperty VRHELPTITLE]] copy];
        
        expect(testRequest.properties).to(equal([@[[SDLGlobalProperty MENUNAME], [SDLGlobalProperty VRHELPTITLE]] copy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_properties:[@[[SDLGlobalProperty MENUNAME], [SDLGlobalProperty VRHELPTITLE]] copy]},
                                             NAMES_operation_name:NAMES_ResetGlobalProperties}} mutableCopy];
        SDLResetGlobalProperties* testRequest = [[SDLResetGlobalProperties alloc] initWithDictionary:dict];
        
        expect(testRequest.properties).to(equal([@[[SDLGlobalProperty MENUNAME], [SDLGlobalProperty VRHELPTITLE]] copy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLResetGlobalProperties* testRequest = [[SDLResetGlobalProperties alloc] init];
        
        expect(testRequest.properties).to(beNil());
    });
});

QuickSpecEnd