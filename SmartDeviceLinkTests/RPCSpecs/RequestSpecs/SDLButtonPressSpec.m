//
//  SDLButtonPressSpec.m
//  SmartDeviceLink-iOS
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLButtonPress.h"
#import "SDLModuleType.h"
#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"

QuickSpecBegin(SDLButtonPressSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLButtonPress* testRequest = [[SDLButtonPress alloc] init];
        
        testRequest.moduleType = SDLModuleTypeClimate;
        testRequest.buttonName = SDLButtonNameAC;
        testRequest.buttonPressMode = SDLButtonPressModeShort;
        
        expect(testRequest.moduleType).to(equal(SDLModuleTypeClimate));
        expect(testRequest.buttonName).to(equal(SDLButtonNameAC));
        expect(testRequest.buttonPressMode).to(equal(SDLButtonPressModeShort));

    });
    
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameModuleType : SDLModuleTypeClimate,
                                                                   SDLNameButtonName : SDLButtonNameAC,
                                                                   SDLNameButtonPressMode : SDLButtonPressModeShort},
                                                             SDLNameOperationName:SDLNameButtonPress}} mutableCopy];
        SDLButtonPress* testRequest = [[SDLButtonPress alloc] initWithDictionary:dict];

        expect(testRequest.moduleType).to(equal(SDLModuleTypeClimate));
        expect(testRequest.buttonName).to(equal(SDLButtonNameAC));
        expect(testRequest.buttonPressMode).to(equal(SDLButtonPressModeShort));
    });

    it(@"Should get correctly when initialized with button name and module type properties", ^ {
        SDLButtonPress* testRequest = [[SDLButtonPress alloc] initWithButtonName:SDLButtonNameAC moduleType:SDLModuleTypeClimate];

        expect(testRequest.buttonName).to(equal(SDLButtonNameAC));
        expect(testRequest.moduleType).to(equal(SDLModuleTypeClimate));
    });

    it(@"Should return nil if not set", ^ {
        SDLButtonPress* testRequest = [[SDLButtonPress alloc] init];
        
        expect(testRequest.moduleType).to(beNil());
        expect(testRequest.buttonName).to(beNil());
        expect(testRequest.buttonPressMode).to(beNil());
    });
});

QuickSpecEnd
