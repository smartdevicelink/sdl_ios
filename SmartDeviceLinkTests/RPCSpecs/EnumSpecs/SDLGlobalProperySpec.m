//
//  SDLGlobalPropertySpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGlobalProperty.h"

QuickSpecBegin(SDLGlobalPropertySpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLGlobalProperty HELPPROMPT].value).to(equal(@"HELPPROMPT"));
        expect([SDLGlobalProperty TIMEOUTPROMPT].value).to(equal(@"TIMEOUTPROMPT"));
        expect([SDLGlobalProperty VRHELPTITLE].value).to(equal(@"VRHELPTITLE"));
        expect([SDLGlobalProperty VRHELPITEMS].value).to(equal(@"VRHELPITEMS"));
        expect([SDLGlobalProperty MENUNAME].value).to(equal(@"MENUNAME"));
        expect([SDLGlobalProperty MENUICON].value).to(equal(@"MENUICON"));
        expect([SDLGlobalProperty KEYBOARDPROPERTIES].value).to(equal(@"KEYBOARDPROPERTIES"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLGlobalProperty valueOf:@"HELPPROMPT"]).to(equal([SDLGlobalProperty HELPPROMPT]));
        expect([SDLGlobalProperty valueOf:@"TIMEOUTPROMPT"]).to(equal([SDLGlobalProperty TIMEOUTPROMPT]));
        expect([SDLGlobalProperty valueOf:@"VRHELPTITLE"]).to(equal([SDLGlobalProperty VRHELPTITLE]));
        expect([SDLGlobalProperty valueOf:@"VRHELPITEMS"]).to(equal([SDLGlobalProperty VRHELPITEMS]));
        expect([SDLGlobalProperty valueOf:@"MENUNAME"]).to(equal([SDLGlobalProperty MENUNAME]));
        expect([SDLGlobalProperty valueOf:@"MENUICON"]).to(equal([SDLGlobalProperty MENUICON]));
        expect([SDLGlobalProperty valueOf:@"KEYBOARDPROPERTIES"]).to(equal([SDLGlobalProperty KEYBOARDPROPERTIES]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLGlobalProperty valueOf:nil]).to(beNil());
        expect([SDLGlobalProperty valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLGlobalProperty values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLGlobalProperty HELPPROMPT],
                        [SDLGlobalProperty TIMEOUTPROMPT],
                        [SDLGlobalProperty VRHELPTITLE],
                        [SDLGlobalProperty VRHELPITEMS],
                        [SDLGlobalProperty MENUNAME],
                        [SDLGlobalProperty MENUICON],
                        [SDLGlobalProperty KEYBOARDPROPERTIES]] copy];
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
