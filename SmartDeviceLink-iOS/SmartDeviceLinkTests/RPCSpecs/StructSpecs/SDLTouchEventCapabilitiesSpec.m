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
        
        testStruct.pressAvailable = @YES;
        testStruct.multiTouchAvailable = @NO;
        testStruct.doublePressAvailable = @YES;
        
        expect(testStruct.pressAvailable).to(equal(@YES));
        expect(testStruct.multiTouchAvailable).to(equal(@NO));
        expect(testStruct.doublePressAvailable).to(equal(@YES));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_pressAvailable:@YES,
                                       NAMES_multiTouchAvailable:@NO,
                                       NAMES_doublePressAvailable:@NO} mutableCopy];
        SDLTouchEventCapabilities* testStruct = [[SDLTouchEventCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.pressAvailable).to(equal(@YES));
        expect(testStruct.multiTouchAvailable).to(equal(@NO));
        expect(testStruct.doublePressAvailable).to(equal(@NO));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTouchEventCapabilities* testStruct = [[SDLTouchEventCapabilities alloc] init];
        
        expect(testStruct.pressAvailable).to(beNil());
        expect(testStruct.multiTouchAvailable).to(beNil());
        expect(testStruct.doublePressAvailable).to(beNil());
    });
});

QuickSpecEnd