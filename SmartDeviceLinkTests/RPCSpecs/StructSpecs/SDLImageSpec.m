//
//  SDLImageSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLImage.h"
#import "SDLImageType.h"
#import "SDLNames.h"


QuickSpecBegin(SDLImageSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLImage* testStruct = [[SDLImage alloc] init];
        
        testStruct.value = @"value";
        testStruct.imageType = SDLImageTypeStatic;
        
        expect(testStruct.value).to(equal(@"value"));
        expect(testStruct.imageType).to(equal(SDLImageTypeStatic));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameValue:@"value",
                                       SDLNameImageType:SDLImageTypeStatic} mutableCopy];
        SDLImage* testStruct = [[SDLImage alloc] initWithDictionary:dict];
        
        expect(testStruct.value).to(equal(@"value"));
        expect(testStruct.imageType).to(equal(SDLImageTypeStatic));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLImage* testStruct = [[SDLImage alloc] init];
        
        expect(testStruct.value).to(beNil());
        expect(testStruct.imageType).to(beNil());
    });
});

QuickSpecEnd
