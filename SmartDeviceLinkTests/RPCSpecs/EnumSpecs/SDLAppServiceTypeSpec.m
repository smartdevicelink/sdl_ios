//
//  SDLAppServiceTypeSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 1/30/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppServiceType.h"


QuickSpecBegin(SDLAppServiceTypeSpec)

describe(@"Individual Enum Value Tests", ^{
    it(@"Should match internal values", ^{
        expect(SDLAppServiceTypeMedia).to(equal(@"MEDIA"));
        expect(SDLAppServiceTypeWeather).to(equal(@"WEATHER"));
        expect(SDLAppServiceTypeNavigation).to(equal(@"NAVIGATION"));
    });
});

QuickSpecEnd

