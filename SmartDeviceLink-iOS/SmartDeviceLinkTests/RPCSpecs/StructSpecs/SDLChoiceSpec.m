//
//  SDLChoiceSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLChoice.h"
#import "SDLImage.h"
#import "SDLNames.h"


QuickSpecBegin(SDLChoiceSpec)

__block SDLImage* image = [[SDLImage alloc] init];
__block SDLImage* secondaryImage = [[SDLImage alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLChoice* testStruct = [[SDLChoice alloc] init];
        
        testStruct.choiceID = @3;
        testStruct.menuName = @"Hello";
        testStruct.vrCommands = [@[@"1", @"2"] mutableCopy];
        testStruct.image = image;
        testStruct.secondaryText = @"Arbitrary";
        testStruct.tertiaryText = @"qwerty";
        testStruct.secondaryImage = secondaryImage;
        
        expect(testStruct.choiceID).to(equal(@3));
        expect(testStruct.menuName).to(equal(@"Hello"));
        expect(testStruct.vrCommands).to(equal([@[@"1", @"2"] mutableCopy]));
        expect(testStruct.image).to(equal(image));
        expect(testStruct.secondaryText).to(equal(@"Arbitrary"));
        expect(testStruct.tertiaryText).to(equal(@"qwerty"));
        expect(testStruct.secondaryImage).to(equal(secondaryImage));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{NAMES_choiceID:@3,
                                       NAMES_menuName:@"Hello",
                                       NAMES_vrCommands:[@[@"1", @"2"] mutableCopy],
                                       NAMES_image:image,
                                       NAMES_secondaryText:@"Arbitrary",
                                       NAMES_tertiaryText:@"qwerty",
                                       NAMES_secondaryImage:secondaryImage} mutableCopy];
        SDLChoice* testStruct = [[SDLChoice alloc] initWithDictionary:dict];
        
        expect(testStruct.choiceID).to(equal(@3));
        expect(testStruct.menuName).to(equal(@"Hello"));
        expect(testStruct.vrCommands).to(equal([@[@"1", @"2"] mutableCopy]));
        expect(testStruct.image).to(equal(image));
        expect(testStruct.secondaryText).to(equal(@"Arbitrary"));
        expect(testStruct.tertiaryText).to(equal(@"qwerty"));
        expect(testStruct.secondaryImage).to(equal(secondaryImage));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLChoice* testStruct = [[SDLChoice alloc] init];
        
        expect(testStruct.choiceID).to(beNil());
        expect(testStruct.menuName).to(beNil());
        expect(testStruct.vrCommands).to(beNil());
        expect(testStruct.image).to(beNil());
        expect(testStruct.secondaryText).to(beNil());
        expect(testStruct.tertiaryText).to(beNil());
        expect(testStruct.secondaryImage).to(beNil());
    });
});

QuickSpecEnd