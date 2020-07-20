//  SDLPredefinedLayout.h
//


#import "SDLEnum.h"

/**
 A template layout an app uses to display information. The broad details of the layout are defined, but the details depend on the IVI system. Used in SetDisplayLayout.
 */
typedef SDLEnum SDLPredefinedLayout SDL_SWIFT_ENUM;

/**
 A default layout
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutDefault;

/**
 The default media layout
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutMedia;

/**
 The default non-media layout
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutNonMedia;

/**
 A media layout containing preset buttons
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutOnscreenPresets;

/**
 The default navigation layout with a fullscreen map
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutNavigationFullscreenMap;

/**
 A list layout used for navigation apps
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutNavigationList;

/**
 A keyboard layout used for navigation apps
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutNavigationKeyboard;

/**
 A layout with a single graphic on the left and text on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutGraphicWithText;

/**
 A layout with text on the left and a single graphic on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTextWithGraphic;

/**
 A layout with only softbuttons placed in a tile layout
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTilesOnly;

/**
 A layout with only soft buttons that only accept text
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTextButtonsOnly;

/**
 A layout with a single graphic on the left and soft buttons in a tile layout on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutGraphicWithTiles;

/**
 A layout with soft buttons in a tile layout on the left and a single graphic on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTilesWithGraphic;

/**
 A layout with a single graphic on the left and both text and soft buttons on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutGraphicWithTextAndSoftButtons;

/**
 A layout with both text and soft buttons on the left and a single graphic on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTextAndSoftButtonsWithGraphic;

/**
 A layout with a single graphic on the left and text-only soft buttons on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutGraphicWithTextButtons;

/**
 A layout with text-only soft buttons on the left and a single graphic on the right
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutTextButtonsWithGraphic;

/**
 A layout with a single large graphic and soft buttons
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutLargeGraphicWithSoftButtons;

/**
 A layout with two graphics and soft buttons
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutDoubleGraphicWithSoftButtons;

/**
 A layout with only a single large graphic
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutLargeGraphicOnly;


/**
 Custom root template allowing in-vehicle WebEngine applications with
 appropriate permissions to show the application's own web view.

 @since 7.0
 */
extern SDLPredefinedLayout const SDLPredefinedLayoutWebView;
