//
//  SDLPredefinedLayoutSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPredefinedLayout.h"

QuickSpecBegin(SDLPredefinedLayoutSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLPredefinedLayout DEFAULT].value).to(equal(@"DEFAULT"));
        expect([SDLPredefinedLayout MEDIA].value).to(equal(@"MEDIA"));
        expect([SDLPredefinedLayout NON_MEDIA].value).to(equal(@"NON-MEDIA"));
        expect([SDLPredefinedLayout ONSCREEN_PRESETS].value).to(equal(@"ONSCREEN_PRESETS"));
        expect([SDLPredefinedLayout NAV_FULLSCREEN_MAP].value).to(equal(@"NAV_FULLSCREEN_MAP"));
        expect([SDLPredefinedLayout NAV_LIST].value).to(equal(@"NAV_LIST"));
        expect([SDLPredefinedLayout NAV_KEYBOARD].value).to(equal(@"NAV_KEYBOARD"));
        expect([SDLPredefinedLayout GRAPHIC_WITH_TEXT].value).to(equal(@"GRAPHIC_WITH_TEXT"));
        expect([SDLPredefinedLayout TEXT_WITH_GRAPHIC].value).to(equal(@"TEXT_WITH_GRAPHIC"));
        expect([SDLPredefinedLayout TILES_ONLY].value).to(equal(@"TILES_ONLY"));
        expect([SDLPredefinedLayout TEXTBUTTONS_ONLY].value).to(equal(@"TEXTBUTTONS_ONLY"));
        expect([SDLPredefinedLayout GRAPHIC_WITH_TILES].value).to(equal(@"GRAPHIC_WITH_TILES"));
        expect([SDLPredefinedLayout TILES_WITH_GRAPHIC].value).to(equal(@"TILES_WITH_GRAPHIC"));
        expect([SDLPredefinedLayout GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS].value).to(equal(@"GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS"));
        expect([SDLPredefinedLayout TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC].value).to(equal(@"TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC"));
        expect([SDLPredefinedLayout GRAPHIC_WITH_TEXTBUTTONS].value).to(equal(@"GRAPHIC_WITH_TEXTBUTTONS"));
        expect([SDLPredefinedLayout TEXTBUTTONS_WITH_GRAPHIC].value).to(equal(@"TEXTBUTTONS_WITH_GRAPHIC"));
        expect([SDLPredefinedLayout LARGE_GRAPHIC_WITH_SOFTBUTTONS].value).to(equal(@"LARGE_GRAPHIC_WITH_SOFTBUTTONS"));
        expect([SDLPredefinedLayout DOUBLE_GRAPHIC_WITH_SOFTBUTTONS].value).to(equal(@"DOUBLE_GRAPHIC_WITH_SOFTBUTTONS"));
        expect([SDLPredefinedLayout LARGE_GRAPHIC_ONLY].value).to(equal(@"LARGE_GRAPHIC_ONLY"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLPredefinedLayout valueOf:@"DEFAULT"]).to(equal([SDLPredefinedLayout DEFAULT]));
        expect([SDLPredefinedLayout valueOf:@"MEDIA"]).to(equal([SDLPredefinedLayout MEDIA]));
        expect([SDLPredefinedLayout valueOf:@"NON-MEDIA"]).to(equal([SDLPredefinedLayout NON_MEDIA]));
        expect([SDLPredefinedLayout valueOf:@"ONSCREEN_PRESETS"]).to(equal([SDLPredefinedLayout ONSCREEN_PRESETS]));
        expect([SDLPredefinedLayout valueOf:@"NAV_FULLSCREEN_MAP"]).to(equal([SDLPredefinedLayout NAV_FULLSCREEN_MAP]));
        expect([SDLPredefinedLayout valueOf:@"NAV_LIST"]).to(equal([SDLPredefinedLayout NAV_LIST]));
        expect([SDLPredefinedLayout valueOf:@"NAV_KEYBOARD"]).to(equal([SDLPredefinedLayout NAV_KEYBOARD]));
        expect([SDLPredefinedLayout valueOf:@"GRAPHIC_WITH_TEXT"]).to(equal([SDLPredefinedLayout GRAPHIC_WITH_TEXT]));
        expect([SDLPredefinedLayout valueOf:@"TEXT_WITH_GRAPHIC"]).to(equal([SDLPredefinedLayout TEXT_WITH_GRAPHIC]));
        expect([SDLPredefinedLayout valueOf:@"TILES_ONLY"]).to(equal([SDLPredefinedLayout TILES_ONLY]));
        expect([SDLPredefinedLayout valueOf:@"TEXTBUTTONS_ONLY"]).to(equal([SDLPredefinedLayout TEXTBUTTONS_ONLY]));
        expect([SDLPredefinedLayout valueOf:@"GRAPHIC_WITH_TILES"]).to(equal([SDLPredefinedLayout GRAPHIC_WITH_TILES]));
        expect([SDLPredefinedLayout valueOf:@"TILES_WITH_GRAPHIC"]).to(equal([SDLPredefinedLayout TILES_WITH_GRAPHIC]));
        expect([SDLPredefinedLayout valueOf:@"GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS"]).to(equal([SDLPredefinedLayout GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS]));
        expect([SDLPredefinedLayout valueOf:@"TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC"]).to(equal([SDLPredefinedLayout TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC]));
        expect([SDLPredefinedLayout valueOf:@"GRAPHIC_WITH_TEXTBUTTONS"]).to(equal([SDLPredefinedLayout GRAPHIC_WITH_TEXTBUTTONS]));
        expect([SDLPredefinedLayout valueOf:@"TEXTBUTTONS_WITH_GRAPHIC"]).to(equal([SDLPredefinedLayout TEXTBUTTONS_WITH_GRAPHIC]));
        expect([SDLPredefinedLayout valueOf:@"LARGE_GRAPHIC_WITH_SOFTBUTTONS"]).to(equal([SDLPredefinedLayout LARGE_GRAPHIC_WITH_SOFTBUTTONS]));
        expect([SDLPredefinedLayout valueOf:@"DOUBLE_GRAPHIC_WITH_SOFTBUTTONS"]).to(equal([SDLPredefinedLayout DOUBLE_GRAPHIC_WITH_SOFTBUTTONS]));
        expect([SDLPredefinedLayout valueOf:@"LARGE_GRAPHIC_ONLY"]).to(equal([SDLPredefinedLayout LARGE_GRAPHIC_ONLY]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLPredefinedLayout valueOf:nil]).to(beNil());
        expect([SDLPredefinedLayout valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLPredefinedLayout values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLPredefinedLayout DEFAULT],
                        [SDLPredefinedLayout MEDIA],
                        [SDLPredefinedLayout NON_MEDIA],
                        [SDLPredefinedLayout ONSCREEN_PRESETS],
                        [SDLPredefinedLayout NAV_FULLSCREEN_MAP],
                        [SDLPredefinedLayout NAV_LIST],
                        [SDLPredefinedLayout NAV_KEYBOARD],
                        [SDLPredefinedLayout GRAPHIC_WITH_TEXT],
                        [SDLPredefinedLayout TEXT_WITH_GRAPHIC],
                        [SDLPredefinedLayout TILES_ONLY],
                        [SDLPredefinedLayout TEXTBUTTONS_ONLY],
                        [SDLPredefinedLayout GRAPHIC_WITH_TILES],
                        [SDLPredefinedLayout TILES_WITH_GRAPHIC],
                        [SDLPredefinedLayout GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS],
                        [SDLPredefinedLayout TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC],
                        [SDLPredefinedLayout GRAPHIC_WITH_TEXTBUTTONS],
                        [SDLPredefinedLayout TEXTBUTTONS_WITH_GRAPHIC],
                        [SDLPredefinedLayout LARGE_GRAPHIC_WITH_SOFTBUTTONS],
                        [SDLPredefinedLayout DOUBLE_GRAPHIC_WITH_SOFTBUTTONS],
                        [SDLPredefinedLayout LARGE_GRAPHIC_ONLY]] copy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd