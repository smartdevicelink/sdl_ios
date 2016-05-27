//
//  SDLDeleteSubMenuSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteSubMenu.h"
#import "SDLNames.h"

QuickSpecBegin(SDLDeleteSubMenuSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeleteSubMenu* testRequest = [[SDLDeleteSubMenu alloc] init];
        
		testRequest.menuID = @25614;

		expect(testRequest.menuID).to(equal(@25614));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_menuID:@25614},
                                             NAMES_operation_name:NAMES_DeleteSubMenu}} mutableCopy];
        SDLDeleteSubMenu* testRequest = [[SDLDeleteSubMenu alloc] initWithDictionary:dict];
        
        expect(testRequest.menuID).to(equal(@25614));
    });

    it(@"Should return nil if not set", ^ {
        SDLDeleteSubMenu* testRequest = [[SDLDeleteSubMenu alloc] init];
        
		expect(testRequest.menuID).to(beNil());
	});
});

QuickSpecEnd