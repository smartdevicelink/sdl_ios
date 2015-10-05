//
//  SDLAddCommandSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAddCommand.h"
#import "SDLImage.h"
#import "SDLMenuParams.h"
#import "SDLNames.h"

QuickSpecBegin(SDLAddCommandSpec)

SDLMenuParams* menu = [[SDLMenuParams alloc] init];
SDLImage* image = [[SDLImage alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAddCommand* testRequest = [[SDLAddCommand alloc] init];
        
        testRequest.cmdID = @434577;
        testRequest.menuParams = menu;
        testRequest.vrCommands = [@[@"name", @"anotherName"] mutableCopy];
        testRequest.cmdIcon = image;
        
        expect(testRequest.cmdID).to(equal(@434577));
        expect(testRequest.menuParams).to(equal(menu));
        expect(testRequest.vrCommands).to(equal([@[@"name", @"anotherName"] mutableCopy]));
        expect(testRequest.cmdIcon).to(equal(image));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_request:
                                           @{NAMES_parameters:
                                                 @{NAMES_cmdID:@434577,
                                                   NAMES_menuParams:menu,
                                                   NAMES_vrCommands:[@[@"name", @"anotherName"] mutableCopy],
                                                   NAMES_cmdIcon:image},
                                             NAMES_operation_name:NAMES_AddCommand}} mutableCopy];
        SDLAddCommand* testRequest = [[SDLAddCommand alloc] initWithDictionary:dict];
        
        expect(testRequest.cmdID).to(equal(@434577));
        expect(testRequest.menuParams).to(equal(menu));
        expect(testRequest.vrCommands).to(equal([@[@"name", @"anotherName"] mutableCopy]));
        expect(testRequest.cmdIcon).to(equal(image));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLAddCommand* testRequest = [[SDLAddCommand alloc] init];
        
        expect(testRequest.cmdID).to(beNil());
        expect(testRequest.menuParams).to(beNil());
        expect(testRequest.vrCommands).to(beNil());
        expect(testRequest.cmdIcon).to(beNil());
    });
});

QuickSpecEnd