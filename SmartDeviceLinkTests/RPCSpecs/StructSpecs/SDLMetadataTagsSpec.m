//
//  SDLMetadataTagsSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLMetadataTags.h"
#import "SDLMetadataType.h"

QuickSpecBegin(SDLMetadataTagsSpec)

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with a dictionary", ^ {
        NSArray<SDLMetadataType *> *formatArray = @[[SDLMetadataType MEDIA_ARTIST], [SDLMetadataType MEDIA_TITLE]];
        NSMutableDictionary* dict = [@{NAMES_mainField1: formatArray,
                                       NAMES_mainField2: formatArray,
                                       NAMES_mainField3: formatArray,
                                       NAMES_mainField4: formatArray} mutableCopy];

        SDLMetadataTags* testStruct = [[SDLMetadataTags alloc] initWithDictionary:dict];

        expect(testStruct.mainField1).to(equal(formatArray));
        expect(testStruct.mainField2).to(equal(formatArray));
        expect(testStruct.mainField3).to(equal(formatArray));
        expect(testStruct.mainField4).to(equal(formatArray));
    });

    it(@"Should return nil if not set", ^ {
        SDLMetadataTags* testStruct = [[SDLMetadataTags alloc] init];

        expect(testStruct.mainField1).to(beNil());
        expect(testStruct.mainField2).to(beNil());
        expect(testStruct.mainField3).to(beNil());
        expect(testStruct.mainField4).to(beNil());
    });

    it(@"Should get correctly when initialized with Arrays", ^ {
        NSArray<SDLMetadataType *> *formatArray = @[[SDLMetadataType MEDIA_ARTIST], [SDLMetadataType MEDIA_TITLE]];
        SDLMetadataTags* testStruct = [[SDLMetadataTags alloc] initWithTextFieldTypes:formatArray mainField2:formatArray mainField3:formatArray mainField4:formatArray];

        expect(testStruct.mainField1).to(equal(formatArray));
        expect(testStruct.mainField2).to(equal(formatArray));
        expect(testStruct.mainField3).to(equal(formatArray));
        expect(testStruct.mainField4).to(equal(formatArray));
    });
});

QuickSpecEnd
