//
//  SDLSetCloudAppPropertiesResponseSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/26/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSetCloudAppPropertiesResponse.h"

QuickSpecBegin(SDLSetCloudAppPropertiesResponseSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^{
        SDLSetCloudAppPropertiesResponse *testResponse = [[SDLSetCloudAppPropertiesResponse alloc] init];
        
        expect(testResponse).toNot(beNil());
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLNameResponse:@{
                                       SDLNameParameters:@{},
                                       SDLNameOperationName:SDLNameSetCloudAppProperties}};
        SDLSetCloudAppPropertiesResponse *testResponse = [[SDLSetCloudAppPropertiesResponse alloc] initWithDictionary:dict];

        expect(testResponse).toNot(beNil());
        expect(testResponse.name).to(equal(SDLNameSetCloudAppProperties));
    });
});

QuickSpecEnd

