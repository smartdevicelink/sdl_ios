//
//  SDLAlertResponseSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAlertResponse.h"
#import "SDLNames.h"

QuickSpecBegin(SDLAlertResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLAlertResponse* testResponse = [[SDLAlertResponse alloc] init];
        testResponse.tryAgainTime = @2;

        expect(testResponse.tryAgainTime).to(equal(@2));
    });

    it(@"Should return nil if not set", ^ {
        SDLAlertResponse* testResponse = [[SDLAlertResponse alloc] init];

        expect(testResponse.tryAgainTime).to(beNil());
    });
});

QuickSpecEnd
