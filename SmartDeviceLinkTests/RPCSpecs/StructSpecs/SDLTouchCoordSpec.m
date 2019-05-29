//
//  SDLTouchCoordSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTouchCoord.h"
#import "SDLRPCParameterNames.h"

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
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameX:@67,
                                                       SDLRPCParameterNameY:@362} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLTouchCoord* testStruct = [[SDLTouchCoord alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
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
