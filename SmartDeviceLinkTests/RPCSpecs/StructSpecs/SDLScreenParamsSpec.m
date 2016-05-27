//
//  SDLScreenParamsSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLImageResolution.h"
#import "SDLNames.h"
#import "SDLScreenParams.h"
#import "SDLTouchEventCapabilities.h"


QuickSpecBegin(SDLScreenParamsSpec)

SDLImageResolution* resolution = [[SDLImageResolution alloc] init];
SDLTouchEventCapabilities* capabilities = [[SDLTouchEventCapabilities alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLScreenParams* testStruct = [[SDLScreenParams alloc] init];
        
        testStruct.resolution = resolution;
        testStruct.touchEventAvailable = capabilities;
        
        expect(testStruct.resolution).to(equal(resolution));
        expect(testStruct.touchEventAvailable).to(equal(capabilities));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_resolution:resolution,
                                       NAMES_touchEventAvailable:capabilities} mutableCopy];
        SDLScreenParams* testStruct = [[SDLScreenParams alloc] initWithDictionary:dict];
        
        expect(testStruct.resolution).to(equal(resolution));
        expect(testStruct.touchEventAvailable).to(equal(capabilities));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLScreenParams* testStruct = [[SDLScreenParams alloc] init];
        
        expect(testStruct.resolution).to(beNil());
        expect(testStruct.touchEventAvailable).to(beNil());
    });
});

QuickSpecEnd