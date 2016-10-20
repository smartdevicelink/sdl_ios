//
//  SDLButtonNameSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLButtonName.h"

QuickSpecBegin(SDLButtonNameSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLButtonNameOk).to(equal(@"OK"));
        expect(SDLButtonNameSeekLeft).to(equal(@"SEEKLEFT"));
        expect(SDLButtonNameSeekRight).to(equal(@"SEEKRIGHT"));
        expect(SDLButtonNameTuneUp).to(equal(@"TUNEUP"));
        expect(SDLButtonNameTuneDown).to(equal(@"TUNEDOWN"));
        expect(SDLButtonNamePreset0).to(equal(@"PRESET_0"));
        expect(SDLButtonNamePreset1).to(equal(@"PRESET_1"));
        expect(SDLButtonNamePreset2).to(equal(@"PRESET_2"));
        expect(SDLButtonNamePreset3).to(equal(@"PRESET_3"));
        expect(SDLButtonNamePreset4).to(equal(@"PRESET_4"));
        expect(SDLButtonNamePreset5).to(equal(@"PRESET_5"));
        expect(SDLButtonNamePreset6).to(equal(@"PRESET_6"));
        expect(SDLButtonNamePreset7).to(equal(@"PRESET_7"));
        expect(SDLButtonNamePreset8).to(equal(@"PRESET_8"));
        expect(SDLButtonNamePreset9).to(equal(@"PRESET_9"));
        expect(SDLButtonNameCustomButton).to(equal(@"CUSTOM_BUTTON"));
        expect(SDLButtonNameSearch).to(equal(@"SEARCH"));
    });
});

QuickSpecEnd
