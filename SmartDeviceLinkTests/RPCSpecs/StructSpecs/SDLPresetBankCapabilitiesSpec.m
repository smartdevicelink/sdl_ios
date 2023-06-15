//
//  SDLPresetBankCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLPresetBankCapabilities.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLPresetBankCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPresetBankCapabilities* testStruct = [[SDLPresetBankCapabilities alloc] init];
        
        testStruct.onScreenPresetsAvailable = @NO;
        
        expect(testStruct.onScreenPresetsAvailable).to(equal(@NO));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameOnScreenPresetsAvailable:@YES} mutableCopy];
        SDLPresetBankCapabilities* testStruct = [[SDLPresetBankCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.onScreenPresetsAvailable).to(equal(@YES));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLPresetBankCapabilities* testStruct = [[SDLPresetBankCapabilities alloc] init];
        
        expect(testStruct.onScreenPresetsAvailable).to(beNil());
    });
});

QuickSpecEnd
