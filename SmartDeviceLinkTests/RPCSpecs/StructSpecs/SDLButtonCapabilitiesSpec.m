//
//  SDLButtonCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonCapabilities.h"
#import "SDLButtonName.h"
#import "SDLRPCParameterNames.h"


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
        NSMutableDictionary* dict = [@{SDLRPCParameterNameName:SDLButtonNameCustomButton,
                                       SDLRPCParameterNameShortPressAvailable:@YES,
                                       SDLRPCParameterNameLongPressAvailable:@YES,
                                       SDLRPCParameterNameUpDownAvailable:@NO} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLButtonCapabilities* testStruct = [[SDLButtonCapabilities alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
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
