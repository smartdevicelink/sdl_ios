//
//  SDLResetGlobalPropertiesSpec.m
//  SmartDeviceLink
//
//  Created by Jacob Keeler on 1/29/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//
//#define EXP_SHORTHAND

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
        
        testRequest.properties = [@[[SDLGlobalProperty MENUNAME], [SDLGlobalProperty VRHELPTITLE]] mutableCopy];
        
        expect(testRequest.properties).to(equal([@[[SDLGlobalProperty MENUNAME], [SDLGlobalProperty VRHELPTITLE]] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_properties:[@[[SDLGlobalProperty MENUNAME], [SDLGlobalProperty VRHELPTITLE]] mutableCopy]},
                                             NAMES_operation_name:NAMES_ResetGlobalProperties}} mutableCopy];
        SDLResetGlobalProperties* testRequest = [[SDLResetGlobalProperties alloc] initWithDictionary:dict];
        
        expect(testRequest.properties).to(equal([@[[SDLGlobalProperty MENUNAME], [SDLGlobalProperty VRHELPTITLE]] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLResetGlobalProperties* testRequest = [[SDLResetGlobalProperties alloc] init];
        
        expect(testRequest.properties).to(beNil());
    });
});

QuickSpecEnd