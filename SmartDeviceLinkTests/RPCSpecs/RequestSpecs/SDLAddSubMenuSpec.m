//
//  SDLAddSubMenuSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddSubMenu.h"
#import "SDLImage.h"
#import "SDLNames.h"

QuickSpecBegin(SDLAddSubMenuSpec)

describe(@"Getter/Setter Tests", ^ {
    __block UInt32 menuId = 4345645;
    __block UInt8 position = 27;
    __block NSString *menuName = @"Welcome to the menu";
    __block SDLImage *image = nil;

    beforeEach(^{
        image = [[SDLImage alloc] initWithName:@"Test" isTemplate:false];
    });

    it(@"should correctly initialize with initWithId:menuName:", ^{
        SDLAddSubMenu *testRequest = [[SDLAddSubMenu alloc] initWithId:menuId menuName:menuName];

        expect(testRequest.menuID).to(equal(@(menuId)));
        expect(testRequest.position).to(beNil());
        expect(testRequest.menuName).to(equal(menuName));
        expect(testRequest.menuIcon).to(beNil());
    });

    it(@"should correctly initialize with initWithId:menuName:position:", ^{
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLAddSubMenu *testRequest = [[SDLAddSubMenu alloc] initWithId:menuId menuName:menuName position:position];

        expect(testRequest.menuID).to(equal(@(menuId)));
        expect(testRequest.position).to(equal(@(position)));
        expect(testRequest.menuName).to(equal(menuName));
        expect(testRequest.menuIcon).to(beNil());
        #pragma clang diagnostic pop
    });

    it(@"should correctly initialize with initWithId:menuName:menuIcon:position:", ^{
        SDLAddSubMenu *testRequest = [[SDLAddSubMenu alloc] initWithId:menuId menuName:menuName menuIcon:image position:position];

        expect(testRequest.menuID).to(equal(@(menuId)));
        expect(testRequest.position).to(equal(@(position)));
        expect(testRequest.menuName).to(equal(menuName));
        expect(testRequest.menuIcon).to(equal(image));
    });

    it(@"Should set and get correctly", ^ {
        SDLAddSubMenu* testRequest = [[SDLAddSubMenu alloc] init];
        
        testRequest.menuID = @4345645;
        testRequest.position = @27;
        testRequest.menuName = @"Welcome to the menu";
        testRequest.menuIcon = image;
        
        expect(testRequest.menuID).to(equal(@(menuId)));
        expect(testRequest.position).to(equal(@(position)));
        expect(testRequest.menuName).to(equal(menuName));
        expect(testRequest.menuIcon).to(equal(image));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameMenuId:@4345645,
                                                                   SDLNamePosition:@27,
                                                                   SDLNameMenuName:@"Welcome to the menu",
                                                                   SDLNameMenuIcon: @{
                                                                           SDLNameValue: @"Test"
                                                                           }
                                                                   },
                                                             SDLNameOperationName:SDLNameAddSubMenu}} mutableCopy];
        SDLAddSubMenu* testRequest = [[SDLAddSubMenu alloc] initWithDictionary:dict];

        expect(testRequest.menuID).to(equal(@(menuId)));
        expect(testRequest.position).to(equal(@(position)));
        expect(testRequest.menuName).to(equal(menuName));
        expect(testRequest.menuIcon.value).to(equal(@"Test"));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAddSubMenu* testRequest = [[SDLAddSubMenu alloc] init];
        
        expect(testRequest.menuID).to(beNil());
        expect(testRequest.position).to(beNil());
        expect(testRequest.menuName).to(beNil());
        expect(testRequest.menuIcon).to(beNil());
    });
});

QuickSpecEnd
