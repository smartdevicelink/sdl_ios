//
//  SDLTurnSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTurn.h"
#import "SDLNames.h"
#import "SDLImage.h"

QuickSpecBegin(SDLTurnSpec)

SDLImage* image = [[SDLImage alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLTurn* testStruct = [[SDLTurn alloc] init];
        
        testStruct.navigationText = @"NAVTEXT";
        testStruct.turnIcon = image;
        
        expect(testStruct.navigationText).to(equal(@"NAVTEXT"));
        expect(testStruct.turnIcon).to(equal(image));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_navigationText:@"NAVTEXT",
                                       NAMES_turnIcon:image} mutableCopy];
        SDLTurn* testStruct = [[SDLTurn alloc] initWithDictionary:dict];
        
        expect(testStruct.navigationText).to(equal(@"NAVTEXT"));
        expect(testStruct.turnIcon).to(equal(image));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTurn* testStruct = [[SDLTurn alloc] init];
        
        expect(testStruct.navigationText).to(beNil());
        expect(testStruct.turnIcon).to(beNil());
    });
});

QuickSpecEnd