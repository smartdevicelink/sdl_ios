//
//  SDLSoftButtonCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSoftButtonCapabilities.h"
#import "SDLNames.h"

QuickSpecBegin(SDLSoftButtonCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSoftButtonCapabilities* testStruct = [[SDLSoftButtonCapabilities alloc] init];
        
        testStruct.shortPressAvailable = @NO;
        testStruct.longPressAvailable = @YES;
        testStruct.upDownAvailable = @NO;
        testStruct.imageSupported = @NO;
        
        expect(testStruct.shortPressAvailable).to(equal(@NO));
        expect(testStruct.longPressAvailable).to(equal(@YES));
        expect(testStruct.upDownAvailable).to(equal(@NO));
        expect(testStruct.imageSupported).to(equal(@NO));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameShortPressAvailable:@NO,
                                                       SDLNameLongPressAvailable:@YES,
                                                       SDLNameUpDownAvailable:@NO,
                                                       SDLNameImageSupported:@NO} mutableCopy];
        SDLSoftButtonCapabilities* testStruct = [[SDLSoftButtonCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.shortPressAvailable).to(equal(@NO));
        expect(testStruct.longPressAvailable).to(equal(@YES));
        expect(testStruct.upDownAvailable).to(equal(@NO));
        expect(testStruct.imageSupported).to(equal(@NO));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLSoftButtonCapabilities* testStruct = [[SDLSoftButtonCapabilities alloc] init];
        
        expect(testStruct.shortPressAvailable).to(beNil());
        expect(testStruct.longPressAvailable).to(beNil());
        expect(testStruct.upDownAvailable).to(beNil());
        expect(testStruct.imageSupported).to(beNil());
    });
});

QuickSpecEnd
