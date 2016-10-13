//
//  SDLButtonCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonCapabilities.h"
#import "SDLButtonName.h"
#import "SDLNames.h"


QuickSpecBegin(SDLButtonCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLButtonCapabilities* testStruct = [[SDLButtonCapabilities alloc] init];
        
        testStruct.name = SDLButtonNameTuneUp;
        testStruct.shortPressAvailable = @YES;
        testStruct.longPressAvailable = @YES;
        testStruct.upDownAvailable = @NO;
        
        expect(testStruct.name).to(equal(SDLButtonNameTuneUp));
        expect(testStruct.shortPressAvailable).to(equal(@YES));
        expect(testStruct.longPressAvailable).to(equal(@YES));
        expect(testStruct.upDownAvailable).to(equal(@NO));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameName:SDLButtonNameCustomButton,
                                       SDLNameShortPressAvailable:@YES,
                                       SDLNameLongPressAvailable:@YES,
                                       SDLNameUpDownAvailable:@NO} mutableCopy];
        SDLButtonCapabilities* testStruct = [[SDLButtonCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.name).to(equal(SDLButtonNameCustomButton));
        expect(testStruct.shortPressAvailable).to(equal(@YES));
        expect(testStruct.longPressAvailable).to(equal(@YES));
        expect(testStruct.upDownAvailable).to(equal(@NO));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLButtonCapabilities* testStruct = [[SDLButtonCapabilities alloc] init];
        
        expect(testStruct.name).to(beNil());
        expect(testStruct.shortPressAvailable).to(beNil());
        expect(testStruct.longPressAvailable).to(beNil());
        expect(testStruct.upDownAvailable).to(beNil());
    });
});

QuickSpecEnd
