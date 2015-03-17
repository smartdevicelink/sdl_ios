//
//  SDLPresetBankCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPresetBankCapabilities.h"
#import "SDLNames.h"

QuickSpecBegin(SDLPresetBankCapabilitiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLPresetBankCapabilities* testStruct = [[SDLPresetBankCapabilities alloc] init];
        
        testStruct.onScreenPresetsAvailable = [NSNumber numberWithBool:NO];
        
        expect(testStruct.onScreenPresetsAvailable).to(equal([NSNumber numberWithBool:NO]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_onScreenPresetsAvailable:[NSNumber numberWithBool:YES]} mutableCopy];
        SDLPresetBankCapabilities* testStruct = [[SDLPresetBankCapabilities alloc] initWithDictionary:dict];
        
        expect(testStruct.onScreenPresetsAvailable).to(equal([NSNumber numberWithBool:YES]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLPresetBankCapabilities* testStruct = [[SDLPresetBankCapabilities alloc] init];
        
        expect(testStruct.onScreenPresetsAvailable).to(beNil());
    });
});

QuickSpecEnd