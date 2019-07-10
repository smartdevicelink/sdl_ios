//
//  SDLPresetBankCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLPresetBankCapabilities* testStruct = [[SDLPresetBankCapabilities alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testStruct.onScreenPresetsAvailable).to(equal(@YES));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLPresetBankCapabilities* testStruct = [[SDLPresetBankCapabilities alloc] init];
        
        expect(testStruct.onScreenPresetsAvailable).to(beNil());
    });
});

QuickSpecEnd
