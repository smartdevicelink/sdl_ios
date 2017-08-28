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
        expect(SDLButtonNameACMax).to(equal(@"AC_MAX"));
        expect(SDLButtonNameAC).to(equal(@"AC"));
        expect(SDLButtonNameRecirculate).to(equal(@"RECIRCULATE"));
        expect(SDLButtonNameFanUp).to(equal(@"FAN_UP"));
        expect(SDLButtonNameFanDown).to(equal(@"FAN_DOWN"));
        expect(SDLButtonNameTempUp).to(equal(@"TEMP_UP"));
        expect(SDLButtonNameTempDown).to(equal(@"TEMP_DOWN"));
        expect(SDLButtonNameDefrostMax).to(equal(@"DEFROST_MAX"));
        expect(SDLButtonNameDefrostRear).to(equal(@"DEFROST_REAR"));
        expect(SDLButtonNameDefrost).to(equal(@"DEFROST"));
        expect(SDLButtonNameUpperVent).to(equal(@"UPPER_VENT"));
        expect(SDLButtonNameLowerVent).to(equal(@"LOWER_VENT"));
        expect(SDLButtonNameVolumeUp).to(equal(@"VOLUME_UP"));
        expect(SDLButtonNameVolumeDown).to(equal(@"VOLUME_DOWN"));
        expect(SDLButtonNameEject).to(equal(@"EJECT"));
        expect(SDLButtonNameSource).to(equal(@"SOURCE"));
        expect(SDLButtonNameShuffle).to(equal(@"SHUFFLE"));
        expect(SDLButtonNameRepeat).to(equal(@"REPEAT"));
    });
});

QuickSpecEnd
