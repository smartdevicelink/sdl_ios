//
//  SDLEnumSpec.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLEnum.h"

QuickSpecBegin(SDLEnumSpec)

describe(@"Value Tests",  ^ {
    it(@"Should get value correctly when initialized", ^ {
        SDLEnum* enumValue = [[SDLEnum alloc] initWithValue:@"Enum"];
        
        expect(enumValue).toNot(beNil());
        
        expect(enumValue.value).to(equal(@"Enum"));
    });
});

QuickSpecEnd