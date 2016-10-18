//
//  SDLTouchCoordSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTouchCoord.h"
#import "SDLNames.h"

QuickSpecBegin(SDLTouchCoordSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLTouchCoord* testStruct = [[SDLTouchCoord alloc] init];
        
        testStruct.x = @67;
        testStruct.y = @362;
        
        expect(testStruct.x).to(equal(@67));
        expect(testStruct.y).to(equal(@362));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameX:@67,
                                                       SDLNameY:@362} mutableCopy];
        SDLTouchCoord* testStruct = [[SDLTouchCoord alloc] initWithDictionary:dict];
        
        expect(testStruct.x).to(equal(@67));
        expect(testStruct.y).to(equal(@362));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLTouchCoord* testStruct = [[SDLTouchCoord alloc] init];
        
        expect(testStruct.x).to(beNil());
        expect(testStruct.y).to(beNil());
    });
});

QuickSpecEnd
