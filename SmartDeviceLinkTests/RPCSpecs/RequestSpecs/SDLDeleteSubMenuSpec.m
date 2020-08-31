//
//  SDLDeleteSubMenuSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteSubMenu.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLDeleteSubMenuSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeleteSubMenu* testRequest = [[SDLDeleteSubMenu alloc] init];
        
		testRequest.menuID = @25614;

		expect(testRequest.menuID).to(equal(@25614));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameMenuID:@25614},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameDeleteSubMenu}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLDeleteSubMenu* testRequest = [[SDLDeleteSubMenu alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.menuID).to(equal(@25614));
    });

    it(@"Should return nil if not set", ^ {
        SDLDeleteSubMenu* testRequest = [[SDLDeleteSubMenu alloc] init];
        
		expect(testRequest.menuID).to(beNil());
	});
});

QuickSpecEnd
