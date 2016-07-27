//  SDLImageFieldName.m
//


#import "SDLImageFieldName.h"

SDLImageFieldName *SDLImageFieldName_softButtonImage = nil;
SDLImageFieldName *SDLImageFieldName_choiceImage = nil;
SDLImageFieldName *SDLImageFieldName_choiceSecondaryImage = nil;
SDLImageFieldName *SDLImageFieldName_vrHelpItem = nil;
SDLImageFieldName *SDLImageFieldName_turnIcon = nil;
SDLImageFieldName *SDLImageFieldName_menuIcon = nil;
SDLImageFieldName *SDLImageFieldName_cmdIcon = nil;
SDLImageFieldName *SDLImageFieldName_appIcon = nil;
SDLImageFieldName *SDLImageFieldName_graphic = nil;
SDLImageFieldName *SDLImageFieldName_showConstantTBTIcon = nil;
SDLImageFieldName *SDLImageFieldName_showConstantTBTNextTurnIcon = nil;
SDLImageFieldName *SDLImageFieldName_locationImage = nil;

NSArray *SDLImageFieldName_values = nil;

@implementation SDLImageFieldName

+ (SDLImageFieldName *)valueOf:(NSString *)value {
    for (SDLImageFieldName *item in SDLImageFieldName.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLImageFieldName_values == nil) {
        SDLImageFieldName_values = @[
            SDLImageFieldName.softButtonImage,
            SDLImageFieldName.choiceImage,
            SDLImageFieldName.choiceSecondaryImage,
            SDLImageFieldName.vrHelpItem,
            SDLImageFieldName.turnIcon,
            SDLImageFieldName.menuIcon,
            SDLImageFieldName.cmdIcon,
            SDLImageFieldName.appIcon,
            SDLImageFieldName.graphic,
            SDLImageFieldName.showConstantTBTIcon,
            SDLImageFieldName.showConstantTBTNextTurnIcon,
            SDLImageFieldName.locationImage,
        ];
    }
    return SDLImageFieldName_values;
}

+ (SDLImageFieldName *)softButtonImage {
    if (SDLImageFieldName_softButtonImage == nil) {
        SDLImageFieldName_softButtonImage = [[SDLImageFieldName alloc] initWithValue:@"softButtonImage"];
    }
    return SDLImageFieldName_softButtonImage;
}

+ (SDLImageFieldName *)choiceImage {
    if (SDLImageFieldName_choiceImage == nil) {
        SDLImageFieldName_choiceImage = [[SDLImageFieldName alloc] initWithValue:@"choiceImage"];
    }
    return SDLImageFieldName_choiceImage;
}

+ (SDLImageFieldName *)choiceSecondaryImage {
    if (SDLImageFieldName_choiceSecondaryImage == nil) {
        SDLImageFieldName_choiceSecondaryImage = [[SDLImageFieldName alloc] initWithValue:@"choiceSecondaryImage"];
    }
    return SDLImageFieldName_choiceSecondaryImage;
}

+ (SDLImageFieldName *)vrHelpItem {
    if (SDLImageFieldName_vrHelpItem == nil) {
        SDLImageFieldName_vrHelpItem = [[SDLImageFieldName alloc] initWithValue:@"vrHelpItem"];
    }
    return SDLImageFieldName_vrHelpItem;
}

+ (SDLImageFieldName *)turnIcon {
    if (SDLImageFieldName_turnIcon == nil) {
        SDLImageFieldName_turnIcon = [[SDLImageFieldName alloc] initWithValue:@"turnIcon"];
    }
    return SDLImageFieldName_turnIcon;
}

+ (SDLImageFieldName *)menuIcon {
    if (SDLImageFieldName_menuIcon == nil) {
        SDLImageFieldName_menuIcon = [[SDLImageFieldName alloc] initWithValue:@"menuIcon"];
    }
    return SDLImageFieldName_menuIcon;
}

+ (SDLImageFieldName *)cmdIcon {
    if (SDLImageFieldName_cmdIcon == nil) {
        SDLImageFieldName_cmdIcon = [[SDLImageFieldName alloc] initWithValue:@"cmdIcon"];
    }
    return SDLImageFieldName_cmdIcon;
}

+ (SDLImageFieldName *)appIcon {
    if (SDLImageFieldName_appIcon == nil) {
        SDLImageFieldName_appIcon = [[SDLImageFieldName alloc] initWithValue:@"appIcon"];
    }
    return SDLImageFieldName_appIcon;
}

+ (SDLImageFieldName *)graphic {
    if (SDLImageFieldName_graphic == nil) {
        SDLImageFieldName_graphic = [[SDLImageFieldName alloc] initWithValue:@"graphic"];
    }
    return SDLImageFieldName_graphic;
}

+ (SDLImageFieldName *)showConstantTBTIcon {
    if (SDLImageFieldName_showConstantTBTIcon == nil) {
        SDLImageFieldName_showConstantTBTIcon = [[SDLImageFieldName alloc] initWithValue:@"showConstantTBTIcon"];
    }
    return SDLImageFieldName_showConstantTBTIcon;
}

+ (SDLImageFieldName *)showConstantTBTNextTurnIcon {
    if (SDLImageFieldName_showConstantTBTNextTurnIcon == nil) {
        SDLImageFieldName_showConstantTBTNextTurnIcon = [[SDLImageFieldName alloc] initWithValue:@"showConstantTBTNextTurnIcon"];
    }
    return SDLImageFieldName_showConstantTBTNextTurnIcon;
}

+ (SDLImageFieldName *)locationImage {
    if (SDLImageFieldName_locationImage == nil) {
        SDLImageFieldName_locationImage = [[SDLImageFieldName alloc] initWithValue:@"locationImage"];
    }
    return SDLImageFieldName_locationImage;
}

@end
