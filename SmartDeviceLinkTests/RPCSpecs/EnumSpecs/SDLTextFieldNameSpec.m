//
//  SDLTextFieldNameSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTextFieldName.h"

QuickSpecBegin(SDLTextFieldNameSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLTextFieldName mainField1].value).to(equal(@"mainField1"));
        expect([SDLTextFieldName mainField2].value).to(equal(@"mainField2"));
        expect([SDLTextFieldName mainField3].value).to(equal(@"mainField3"));
        expect([SDLTextFieldName mainField4].value).to(equal(@"mainField4"));
        expect([SDLTextFieldName statusBar].value).to(equal(@"statusBar"));
        expect([SDLTextFieldName mediaClock].value).to(equal(@"mediaClock"));
        expect([SDLTextFieldName mediaTrack].value).to(equal(@"mediaTrack"));
        expect([SDLTextFieldName alertText1].value).to(equal(@"alertText1"));
        expect([SDLTextFieldName alertText2].value).to(equal(@"alertText2"));
        expect([SDLTextFieldName alertText3].value).to(equal(@"alertText3"));
        expect([SDLTextFieldName scrollableMessageBody].value).to(equal(@"scrollableMessageBody"));
        expect([SDLTextFieldName initialInteractionText].value).to(equal(@"initialInteractionText"));
        expect([SDLTextFieldName navigationText1].value).to(equal(@"navigationText1"));
        expect([SDLTextFieldName navigationText2].value).to(equal(@"navigationText2"));
        expect([SDLTextFieldName ETA].value).to(equal(@"ETA"));
        expect([SDLTextFieldName totalDistance].value).to(equal(@"totalDistance"));
        expect([SDLTextFieldName audioPassThruDisplayText1].value).to(equal(@"audioPassThruDisplayText1"));
        expect([SDLTextFieldName audioPassThruDisplayText2].value).to(equal(@"audioPassThruDisplayText2"));
        expect([SDLTextFieldName sliderHeader].value).to(equal(@"sliderHeader"));
        expect([SDLTextFieldName sliderFooter].value).to(equal(@"sliderFooter"));
        expect([SDLTextFieldName menuName].value).to(equal(@"menuName"));
        expect([SDLTextFieldName secondaryText].value).to(equal(@"secondaryText"));
        expect([SDLTextFieldName tertiaryText].value).to(equal(@"tertiaryText"));
        expect([SDLTextFieldName menuTitle].value).to(equal(@"menuTitle"));
        expect([SDLTextFieldName locationName].value).to(equal(@"locationName"));
        expect([SDLTextFieldName locationDescription].value).to(equal(@"locationDescription"));
        expect([SDLTextFieldName addressLines].value).to(equal(@"addressLines"));
        expect([SDLTextFieldName phoneNumber].value).to(equal(@"phoneNumber"));
    });
});

describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLTextFieldName valueOf:@"mainField1"]).to(equal([SDLTextFieldName mainField1]));
        expect([SDLTextFieldName valueOf:@"mainField2"]).to(equal([SDLTextFieldName mainField2]));
        expect([SDLTextFieldName valueOf:@"mainField3"]).to(equal([SDLTextFieldName mainField3]));
        expect([SDLTextFieldName valueOf:@"mainField4"]).to(equal([SDLTextFieldName mainField4]));
        expect([SDLTextFieldName valueOf:@"statusBar"]).to(equal([SDLTextFieldName statusBar]));
        expect([SDLTextFieldName valueOf:@"mediaClock"]).to(equal([SDLTextFieldName mediaClock]));
        expect([SDLTextFieldName valueOf:@"mediaTrack"]).to(equal([SDLTextFieldName mediaTrack]));
        expect([SDLTextFieldName valueOf:@"alertText1"]).to(equal([SDLTextFieldName alertText1]));
        expect([SDLTextFieldName valueOf:@"alertText2"]).to(equal([SDLTextFieldName alertText2]));
        expect([SDLTextFieldName valueOf:@"alertText3"]).to(equal([SDLTextFieldName alertText3]));
        expect([SDLTextFieldName valueOf:@"scrollableMessageBody"]).to(equal([SDLTextFieldName scrollableMessageBody]));
        expect([SDLTextFieldName valueOf:@"initialInteractionText"]).to(equal([SDLTextFieldName initialInteractionText]));
        expect([SDLTextFieldName valueOf:@"navigationText1"]).to(equal([SDLTextFieldName navigationText1]));
        expect([SDLTextFieldName valueOf:@"navigationText2"]).to(equal([SDLTextFieldName navigationText2]));
        expect([SDLTextFieldName valueOf:@"ETA"]).to(equal([SDLTextFieldName ETA]));
        expect([SDLTextFieldName valueOf:@"totalDistance"]).to(equal([SDLTextFieldName totalDistance]));
        expect([SDLTextFieldName valueOf:@"audioPassThruDisplayText1"]).to(equal([SDLTextFieldName audioPassThruDisplayText1]));
        expect([SDLTextFieldName valueOf:@"audioPassThruDisplayText2"]).to(equal([SDLTextFieldName audioPassThruDisplayText2]));
        expect([SDLTextFieldName valueOf:@"sliderHeader"]).to(equal([SDLTextFieldName sliderHeader]));
        expect([SDLTextFieldName valueOf:@"sliderFooter"]).to(equal([SDLTextFieldName sliderFooter]));
        expect([SDLTextFieldName valueOf:@"menuName"]).to(equal([SDLTextFieldName menuName]));
        expect([SDLTextFieldName valueOf:@"secondaryText"]).to(equal([SDLTextFieldName secondaryText]));
        expect([SDLTextFieldName valueOf:@"tertiaryText"]).to(equal([SDLTextFieldName tertiaryText]));
        expect([SDLTextFieldName valueOf:@"menuTitle"]).to(equal([SDLTextFieldName menuTitle]));
        expect([SDLTextFieldName valueOf:@"locationName"]).to(equal([SDLTextFieldName locationName]));
        expect([SDLTextFieldName valueOf:@"locationDescription"]).to(equal([SDLTextFieldName locationDescription]));
        expect([SDLTextFieldName valueOf:@"addressLines"]).to(equal([SDLTextFieldName addressLines]));
        expect([SDLTextFieldName valueOf:@"phoneNumber"]).to(equal([SDLTextFieldName phoneNumber]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLTextFieldName valueOf:nil]).to(beNil());
        expect([SDLTextFieldName valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});

describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLTextFieldName values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLTextFieldName mainField1],
                           [SDLTextFieldName mainField2],
                           [SDLTextFieldName mainField3],
                           [SDLTextFieldName mainField4],
                           [SDLTextFieldName statusBar],
                           [SDLTextFieldName mediaClock],
                           [SDLTextFieldName mediaTrack],
                           [SDLTextFieldName alertText1],
                           [SDLTextFieldName alertText2],
                           [SDLTextFieldName alertText3],
                           [SDLTextFieldName scrollableMessageBody],
                           [SDLTextFieldName initialInteractionText],
                           [SDLTextFieldName navigationText1],
                           [SDLTextFieldName navigationText2],
                           [SDLTextFieldName ETA],
                           [SDLTextFieldName totalDistance],
                           [SDLTextFieldName audioPassThruDisplayText1],
                           [SDLTextFieldName audioPassThruDisplayText2],
                           [SDLTextFieldName sliderHeader],
                           [SDLTextFieldName sliderFooter],
                           [SDLTextFieldName menuName],
                           [SDLTextFieldName secondaryText],
                           [SDLTextFieldName tertiaryText],
                           [SDLTextFieldName menuTitle],
                           [SDLTextFieldName locationName],
                           [SDLTextFieldName locationDescription],
                           [SDLTextFieldName addressLines],
                           [SDLTextFieldName phoneNumber]] copy];
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