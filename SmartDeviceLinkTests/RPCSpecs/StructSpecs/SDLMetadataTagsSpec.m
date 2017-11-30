//
//  SDLMetadataTagsSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/3/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMetadataTags.h"
#import "SDLNames.h"
#import "SDLMetadataType.h"

QuickSpecBegin(SDLMetadataTagsSpec)

describe(@"Initialization tests", ^{
    it(@"Should get correctly when initialized with Arrays", ^ {
        NSArray<SDLMetadataType> *formatArray = @[SDLMetadataTypeMediaArtist, SDLMetadataTypeMediaTitle];
        SDLMetadataTags* testStruct = [[SDLMetadataTags alloc] initWithTextFieldTypes:formatArray mainField2:formatArray mainField3:formatArray mainField4:formatArray];

        expect(testStruct.mainField1).to(equal(formatArray));
        expect(testStruct.mainField2).to(equal(formatArray));
        expect(testStruct.mainField3).to(equal(formatArray));
        expect(testStruct.mainField4).to(equal(formatArray));
    });

    it(@"Should return nil if not set", ^ {
        SDLMetadataTags *testStruct = [[SDLMetadataTags alloc] init];

        expect(testStruct.mainField1).to(beNil());
        expect(testStruct.mainField2).to(beNil());
        expect(testStruct.mainField3).to(beNil());
        expect(testStruct.mainField4).to(beNil());
    });
});

QuickSpecEnd
