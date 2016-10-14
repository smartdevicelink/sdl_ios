//
//  SDLAddSubMenuSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddSubMenu.h"
#import "SDLNames.h"

QuickSpecBegin(SDLAddSubMenuSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAddSubMenu* testRequest = [[SDLAddSubMenu alloc] init];
        
        testRequest.menuID = @4345645;
        testRequest.position = @27;
        testRequest.menuName = @"Welcome to the menu";
        
        expect(testRequest.menuID).to(equal(@4345645));
        expect(testRequest.position).to(equal(@27));
        expect(testRequest.menuName).to(equal(@"Welcome to the menu"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameMenuId:@4345645,
                                                                   SDLNamePosition:@27,
                                                                   SDLNameMenuName:@"Welcome to the menu"},
                                                             SDLNameOperationName:SDLNameAddSubMenu}} mutableCopy];
        SDLAddSubMenu* testRequest = [[SDLAddSubMenu alloc] initWithDictionary:dict];

        expect(testRequest.menuID).to(equal(@4345645));
        expect(testRequest.position).to(equal(@27));
        expect(testRequest.menuName).to(equal(@"Welcome to the menu"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAddSubMenu* testRequest = [[SDLAddSubMenu alloc] init];
        
        expect(testRequest.menuID).to(beNil());
        expect(testRequest.position).to(beNil());
        expect(testRequest.menuName).to(beNil());
    });
});

QuickSpecEnd
