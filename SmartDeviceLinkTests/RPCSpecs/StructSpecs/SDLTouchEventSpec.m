//
//  SDLTouchEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTouchEvent.h"
#import "SDLTouchCoord.h"
#import "SDLNames.h"

QuickSpecBegin(SDLTouchEventSpec)

SDLTouchCoord* coord = [[SDLTouchCoord alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLTouchEvent* testStruct = [[SDLTouchEvent alloc] init];
        
        testStruct.touchEventId = @3;
        testStruct.timeStamp = [@[@23, @52, @41345234] mutableCopy];
        testStruct.coord = [@[coord] mutableCopy];
        
        expect(testStruct.touchEventId).to(equal(@3));
        expect(testStruct.timeStamp).to(equal([@[@23, @52, @41345234] mutableCopy]));
        expect(testStruct.coord).to(equal([@[coord] mutableCopy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_id:@3,
                                       NAMES_ts:[@[@23, @52, @41345234] mutableCopy],
                                       NAMES_c:[@[coord] mutableCopy]} mutableCopy];
        SDLTouchEvent* testStruct = [[SDLTouchEvent alloc] initWithDictionary:dict];
        
        expect(testStruct.touchEventId).to(equal(@3));
        expect(testStruct.timeStamp).to(equal([@[@23, @52, @41345234] mutableCopy]));
        expect(testStruct.coord).to(equal([@[coord] mutableCopy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTouchEvent* testStruct = [[SDLTouchEvent alloc] init];
        
        expect(testStruct.touchEventId).to(beNil());
        expect(testStruct.timeStamp).to(beNil());
        expect(testStruct.coord).to(beNil());
    });
});

QuickSpecEnd