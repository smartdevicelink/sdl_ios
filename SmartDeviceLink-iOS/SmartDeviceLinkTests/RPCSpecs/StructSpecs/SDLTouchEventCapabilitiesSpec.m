//
//  SDLTouchEventCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTouchEventCapabilities.h"
#import "SDLNames.h"

QuickSpecBegin(SDLTouchEventCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLTouchEventCapabilities* testStruct = [[SDLTouchEventCapabilities alloc] init];
        
        testStruct.pressAvailable = [NSNumber numberWithBool:YES];
        testStruct.multiTouchAvailable = [NSNumber numberWithBool:NO];
        testStruct.doublePressAvailable = [NSNumber numberWithBool:YES];
        
        expect(testStruct.pressAvailable).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.multiTouchAvailable).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.doublePressAvailable).to(equal([NSNumber numberWithBool:YES]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_pressAvailable:[NSNumber numberWithBool:YES],
                                       NAMES_multiTouchAvailable:[NSNumber numberWithBool:NO],
                                       NAMES_doublePressAvailable:[NSNumber numberWithBool:NO]} mutableCopy];
        SDLTouchEventCapabilities* testStruct = [[SDLTouchEventCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.pressAvailable).to(equal([NSNumber numberWithBool:YES]));
        expect(testStruct.multiTouchAvailable).to(equal([NSNumber numberWithBool:NO]));
        expect(testStruct.doublePressAvailable).to(equal([NSNumber numberWithBool:NO]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTouchEventCapabilities* testStruct = [[SDLTouchEventCapabilities alloc] init];
        
        expect(testStruct.pressAvailable).to(beNil());
        expect(testStruct.multiTouchAvailable).to(beNil());
        expect(testStruct.doublePressAvailable).to(beNil());
    });
});

QuickSpecEnd