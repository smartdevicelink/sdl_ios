//  SDLPredefinedLayout.h
//


#import "SDLEnum.h"

@interface SDLPredefinedLayout : SDLEnum {
}

+ (SDLPredefinedLayout *)valueOf:(NSString *)value;
+ (NSArray *)values;

+ (SDLPredefinedLayout *)DEFAULT;
+ (SDLPredefinedLayout *)MEDIA;
+ (SDLPredefinedLayout *)NON_MEDIA;
+ (SDLPredefinedLayout *)ONSCREEN_PRESETS;
+ (SDLPredefinedLayout *)NAV_FULLSCREEN_MAP;
+ (SDLPredefinedLayout *)NAV_LIST;
+ (SDLPredefinedLayout *)NAV_KEYBOARD;
+ (SDLPredefinedLayout *)GRAPHIC_WITH_TEXT;
+ (SDLPredefinedLayout *)TEXT_WITH_GRAPHIC;
+ (SDLPredefinedLayout *)TILES_ONLY;
+ (SDLPredefinedLayout *)TEXTBUTTONS_ONLY;
+ (SDLPredefinedLayout *)GRAPHIC_WITH_TILES;
+ (SDLPredefinedLayout *)TILES_WITH_GRAPHIC;
+ (SDLPredefinedLayout *)GRAPHIC_WITH_TEXT_AND_SOFTBUTTONS;
+ (SDLPredefinedLayout *)TEXT_AND_SOFTBUTTONS_WITH_GRAPHIC;
+ (SDLPredefinedLayout *)GRAPHIC_WITH_TEXTBUTTONS;
+ (SDLPredefinedLayout *)TEXTBUTTONS_WITH_GRAPHIC;
+ (SDLPredefinedLayout *)LARGE_GRAPHIC_WITH_SOFTBUTTONS;
+ (SDLPredefinedLayout *)DOUBLE_GRAPHIC_WITH_SOFTBUTTONS;
+ (SDLPredefinedLayout *)LARGE_GRAPHIC_ONLY;

@end
