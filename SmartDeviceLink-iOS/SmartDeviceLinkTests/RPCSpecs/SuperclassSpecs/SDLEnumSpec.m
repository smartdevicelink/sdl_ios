//
//  SDLEnumSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Jacob Keeler on 2/12/15.
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEnum.h"

QuickSpecBegin(SDLEnumSpec)

describe(@"InitWithValue Tests",  ^ {
    it(@"Should initialize correctly", ^ {
        SDLEnum* enumValue = [[SDLEnum alloc] initWithValue:@"Enum"];
        
        expect(enumValue).toNot(beNil());
        
        expect(enumValue.value).to(equal(@"Enum"));
    });
});

QuickSpecEnd