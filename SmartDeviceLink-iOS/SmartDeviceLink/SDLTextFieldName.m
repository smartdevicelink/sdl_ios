//  SDLTextFieldName.m
//


#import "SDLTextFieldName.h"

SDLTextFieldName *SDLTextFieldName_mainField1 = nil;
SDLTextFieldName *SDLTextFieldName_mainField2 = nil;
SDLTextFieldName *SDLTextFieldName_mainField3 = nil;
SDLTextFieldName *SDLTextFieldName_mainField4 = nil;
SDLTextFieldName *SDLTextFieldName_statusBar = nil;
SDLTextFieldName *SDLTextFieldName_mediaClock = nil;
SDLTextFieldName *SDLTextFieldName_mediaTrack = nil;
SDLTextFieldName *SDLTextFieldName_alertText1 = nil;
SDLTextFieldName *SDLTextFieldName_alertText2 = nil;
SDLTextFieldName *SDLTextFieldName_alertText3 = nil;
SDLTextFieldName *SDLTextFieldName_scrollableMessageBody = nil;
SDLTextFieldName *SDLTextFieldName_initialInteractionText = nil;
SDLTextFieldName *SDLTextFieldName_navigationText1 = nil;
SDLTextFieldName *SDLTextFieldName_navigationText2 = nil;
SDLTextFieldName *SDLTextFieldName_ETA = nil;
SDLTextFieldName *SDLTextFieldName_totalDistance = nil;
SDLTextFieldName *SDLTextFieldName_audioPassThruDisplayText1 = nil;
SDLTextFieldName *SDLTextFieldName_audioPassThruDisplayText2 = nil;
SDLTextFieldName *SDLTextFieldName_sliderHeader = nil;
SDLTextFieldName *SDLTextFieldName_sliderFooter = nil;
SDLTextFieldName *SDLTextFieldName_menuName = nil;
SDLTextFieldName *SDLTextFieldName_secondaryText = nil;
SDLTextFieldName *SDLTextFieldName_tertiaryText = nil;
SDLTextFieldName *SDLTextFieldName_menuTitle = nil;
SDLTextFieldName *SDLTextFieldName_locationName = nil;
SDLTextFieldName *SDLTextFieldName_locationDescription = nil;
SDLTextFieldName *SDLTextFieldName_addressLines = nil;
SDLTextFieldName *SDLTextFieldName_phoneNumber = nil;

NSArray *SDLTextFieldName_values = nil;

@implementation SDLTextFieldName

+ (SDLTextFieldName *)valueOf:(NSString *)value {
    for (SDLTextFieldName *item in SDLTextFieldName.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLTextFieldName_values == nil) {
        SDLTextFieldName_values = @[
            SDLTextFieldName.mainField1,
            SDLTextFieldName.mainField2,
            SDLTextFieldName.mainField3,
            SDLTextFieldName.mainField4,
            SDLTextFieldName.statusBar,
            SDLTextFieldName.mediaClock,
            SDLTextFieldName.mediaTrack,
            SDLTextFieldName.alertText1,
            SDLTextFieldName.alertText2,
            SDLTextFieldName.alertText3,
            SDLTextFieldName.scrollableMessageBody,
            SDLTextFieldName.initialInteractionText,
            SDLTextFieldName.navigationText1,
            SDLTextFieldName.navigationText2,
            SDLTextFieldName.ETA,
            SDLTextFieldName.totalDistance,
            SDLTextFieldName.audioPassThruDisplayText1,
            SDLTextFieldName.audioPassThruDisplayText2,
            SDLTextFieldName.sliderHeader,
            SDLTextFieldName.sliderFooter,
            SDLTextFieldName.menuName,
            SDLTextFieldName.secondaryText,
            SDLTextFieldName.tertiaryText,
            SDLTextFieldName.menuTitle,
            SDLTextFieldName.locationName,
            SDLTextFieldName.locationDescription,
            SDLTextFieldName.addressLines,
            SDLTextFieldName.phoneNumber,
        ];
    }
    return SDLTextFieldName_values;
}

+ (SDLTextFieldName *)mainField1 {
    if (SDLTextFieldName_mainField1 == nil) {
        SDLTextFieldName_mainField1 = [[SDLTextFieldName alloc] initWithValue:@"mainField1"];
    }
    return SDLTextFieldName_mainField1;
}

+ (SDLTextFieldName *)mainField2 {
    if (SDLTextFieldName_mainField2 == nil) {
        SDLTextFieldName_mainField2 = [[SDLTextFieldName alloc] initWithValue:@"mainField2"];
    }
    return SDLTextFieldName_mainField2;
}

+ (SDLTextFieldName *)mainField3 {
    if (SDLTextFieldName_mainField3 == nil) {
        SDLTextFieldName_mainField3 = [[SDLTextFieldName alloc] initWithValue:@"mainField3"];
    }
    return SDLTextFieldName_mainField3;
}

+ (SDLTextFieldName *)mainField4 {
    if (SDLTextFieldName_mainField4 == nil) {
        SDLTextFieldName_mainField4 = [[SDLTextFieldName alloc] initWithValue:@"mainField4"];
    }
    return SDLTextFieldName_mainField4;
}

+ (SDLTextFieldName *)statusBar {
    if (SDLTextFieldName_statusBar == nil) {
        SDLTextFieldName_statusBar = [[SDLTextFieldName alloc] initWithValue:@"statusBar"];
    }
    return SDLTextFieldName_statusBar;
}

+ (SDLTextFieldName *)mediaClock {
    if (SDLTextFieldName_mediaClock == nil) {
        SDLTextFieldName_mediaClock = [[SDLTextFieldName alloc] initWithValue:@"mediaClock"];
    }
    return SDLTextFieldName_mediaClock;
}

+ (SDLTextFieldName *)mediaTrack {
    if (SDLTextFieldName_mediaTrack == nil) {
        SDLTextFieldName_mediaTrack = [[SDLTextFieldName alloc] initWithValue:@"mediaTrack"];
    }
    return SDLTextFieldName_mediaTrack;
}

+ (SDLTextFieldName *)alertText1 {
    if (SDLTextFieldName_alertText1 == nil) {
        SDLTextFieldName_alertText1 = [[SDLTextFieldName alloc] initWithValue:@"alertText1"];
    }
    return SDLTextFieldName_alertText1;
}

+ (SDLTextFieldName *)alertText2 {
    if (SDLTextFieldName_alertText2 == nil) {
        SDLTextFieldName_alertText2 = [[SDLTextFieldName alloc] initWithValue:@"alertText2"];
    }
    return SDLTextFieldName_alertText2;
}

+ (SDLTextFieldName *)alertText3 {
    if (SDLTextFieldName_alertText3 == nil) {
        SDLTextFieldName_alertText3 = [[SDLTextFieldName alloc] initWithValue:@"alertText3"];
    }
    return SDLTextFieldName_alertText3;
}

+ (SDLTextFieldName *)scrollableMessageBody {
    if (SDLTextFieldName_scrollableMessageBody == nil) {
        SDLTextFieldName_scrollableMessageBody = [[SDLTextFieldName alloc] initWithValue:@"scrollableMessageBody"];
    }
    return SDLTextFieldName_scrollableMessageBody;
}

+ (SDLTextFieldName *)initialInteractionText {
    if (SDLTextFieldName_initialInteractionText == nil) {
        SDLTextFieldName_initialInteractionText = [[SDLTextFieldName alloc] initWithValue:@"initialInteractionText"];
    }
    return SDLTextFieldName_initialInteractionText;
}

+ (SDLTextFieldName *)navigationText1 {
    if (SDLTextFieldName_navigationText1 == nil) {
        SDLTextFieldName_navigationText1 = [[SDLTextFieldName alloc] initWithValue:@"navigationText1"];
    }
    return SDLTextFieldName_navigationText1;
}

+ (SDLTextFieldName *)navigationText2 {
    if (SDLTextFieldName_navigationText2 == nil) {
        SDLTextFieldName_navigationText2 = [[SDLTextFieldName alloc] initWithValue:@"navigationText2"];
    }
    return SDLTextFieldName_navigationText2;
}

+ (SDLTextFieldName *)ETA {
    if (SDLTextFieldName_ETA == nil) {
        SDLTextFieldName_ETA = [[SDLTextFieldName alloc] initWithValue:@"ETA"];
    }
    return SDLTextFieldName_ETA;
}

+ (SDLTextFieldName *)totalDistance {
    if (SDLTextFieldName_totalDistance == nil) {
        SDLTextFieldName_totalDistance = [[SDLTextFieldName alloc] initWithValue:@"totalDistance"];
    }
    return SDLTextFieldName_totalDistance;
}

+ (SDLTextFieldName *)audioPassThruDisplayText1 {
    if (SDLTextFieldName_audioPassThruDisplayText1 == nil) {
        SDLTextFieldName_audioPassThruDisplayText1 = [[SDLTextFieldName alloc] initWithValue:@"audioPassThruDisplayText1"];
    }
    return SDLTextFieldName_audioPassThruDisplayText1;
}

+ (SDLTextFieldName *)audioPassThruDisplayText2 {
    if (SDLTextFieldName_audioPassThruDisplayText2 == nil) {
        SDLTextFieldName_audioPassThruDisplayText2 = [[SDLTextFieldName alloc] initWithValue:@"audioPassThruDisplayText2"];
    }
    return SDLTextFieldName_audioPassThruDisplayText2;
}

+ (SDLTextFieldName *)sliderHeader {
    if (SDLTextFieldName_sliderHeader == nil) {
        SDLTextFieldName_sliderHeader = [[SDLTextFieldName alloc] initWithValue:@"sliderHeader"];
    }
    return SDLTextFieldName_sliderHeader;
}

+ (SDLTextFieldName *)sliderFooter {
    if (SDLTextFieldName_sliderFooter == nil) {
        SDLTextFieldName_sliderFooter = [[SDLTextFieldName alloc] initWithValue:@"sliderFooter"];
    }
    return SDLTextFieldName_sliderFooter;
}

+ (SDLTextFieldName *)menuName {
    if (SDLTextFieldName_menuName == nil) {
        SDLTextFieldName_menuName = [[SDLTextFieldName alloc] initWithValue:@"menuName"];
    }
    return SDLTextFieldName_menuName;
}

+ (SDLTextFieldName *)secondaryText {
    if (SDLTextFieldName_secondaryText == nil) {
        SDLTextFieldName_secondaryText = [[SDLTextFieldName alloc] initWithValue:@"secondaryText"];
    }
    return SDLTextFieldName_secondaryText;
}

+ (SDLTextFieldName *)tertiaryText {
    if (SDLTextFieldName_tertiaryText == nil) {
        SDLTextFieldName_tertiaryText = [[SDLTextFieldName alloc] initWithValue:@"tertiaryText"];
    }
    return SDLTextFieldName_tertiaryText;
}

+ (SDLTextFieldName *)menuTitle {
    if (SDLTextFieldName_menuTitle == nil) {
        SDLTextFieldName_menuTitle = [[SDLTextFieldName alloc] initWithValue:@"menuTitle"];
    }
    return SDLTextFieldName_menuTitle;
}

+ (SDLTextFieldName *)locationName {
    if (SDLTextFieldName_locationName == nil) {
        SDLTextFieldName_locationName = [[SDLTextFieldName alloc] initWithValue:@"locationName"];
    }
    return SDLTextFieldName_locationName;
}

+ (SDLTextFieldName *)locationDescription {
    if (SDLTextFieldName_locationDescription == nil) {
        SDLTextFieldName_locationDescription = [[SDLTextFieldName alloc] initWithValue:@"locationDescription"];
    }
    return SDLTextFieldName_locationDescription;
}

+ (SDLTextFieldName *)addressLines {
    if (SDLTextFieldName_addressLines == nil) {
        SDLTextFieldName_addressLines = [[SDLTextFieldName alloc] initWithValue:@"addressLines"];
    }
    return SDLTextFieldName_addressLines;
}

+ (SDLTextFieldName *)phoneNumber {
    if (SDLTextFieldName_phoneNumber == nil) {
        SDLTextFieldName_phoneNumber = [[SDLTextFieldName alloc] initWithValue:@"phoneNumber"];
    }
    return SDLTextFieldName_phoneNumber;
}

@end
