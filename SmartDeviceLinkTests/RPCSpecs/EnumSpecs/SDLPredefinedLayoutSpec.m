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
        expect(SDLPredefinedLayoutDefault).to(equal(@"DEFAULT"));
        expect(SDLPredefinedLayoutMedia).to(equal(@"MEDIA"));
        expect(SDLPredefinedLayoutNonMedia).to(equal(@"NON-MEDIA"));
        expect(SDLPredefinedLayoutOnscreenPresets).to(equal(@"ONSCREEN_PRESETS"));
        expect(SDLPredefinedLayoutNavigationFullscreenMap).to(equal(@"NAV_FULLSCREEN_MAP"));
        expect(SDLPredefinedLayoutNavigationList).to(equal(@"NAV_LIST"));
        expect(SDLPredefinedLayoutNavigationKeyboard).to(equal(@"NAV_KEYBOARD"));
        expect(SDLPredefinedLayoutGraphicWithText).to(equal(@"GRAPHIC_WITH_TEXT"));
        expect(SDLPredefinedLayoutTextWithGraphic).to(equal(@"TEXT_WITH_GRAPHIC"));
        expect(SDLPredefinedLayoutTilesOnly).to(equal(@"TILES_ONLY"));
        expect(SDLPredefinedLayoutTextButtonsOnly).to(equal(@"TEXTBUTTONS_ONLY"));
        expect(SDLPredefinedLayoutGraphicWithTiles).to(equal(@"GRAPHIC_WITH_TILES"));
        expect(SDLPredefinedLayoutTilesWithGraphic).to(equal(@"TILES_WITH_GRAPHIC"));
        expect(SDLPredefinedLayoutGraphicWithTextAndSoftButtons).to(equal(@"GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS"));
        expect(SDLPredefinedLayoutTextAndSoftButtonsWithGraphic).to(equal(@"TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC"));
        expect(SDLPredefinedLayoutGraphicWithTextButtons).to(equal(@"GRAPHIC_WITH_TEXTBUTTONS"));
        expect(SDLPredefinedLayoutTextButtonsWithGraphic).to(equal(@"TEXTBUTTONS_WITH_GRAPHIC"));
        expect(SDLPredefinedLayoutLargeGraphicWithSoftButtons).to(equal(@"LARGE_GRAPHIC_WITH_SOFTBUTTONS"));
        expect(SDLPredefinedLayoutDoubleGraphicWithSoftButtons).to(equal(@"DOUBLE_GRAPHIC_WITH_SOFTBUTTONS"));
        expect(SDLPredefinedLayoutLargeGraphicOnly).to(equal(@"LARGE_GRAPHIC_ONLY"));
        expect(SDLPredefinedLayoutWebView).to(equal(@"WEB_VIEW"));
    });
});

QuickSpecEnd
