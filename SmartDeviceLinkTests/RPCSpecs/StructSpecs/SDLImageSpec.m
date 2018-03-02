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

describe(@"Getter/Setter Tests", ^{
    context(@"When creating", ^{
        __block SDLImage *testSDLImage = nil;
        __block NSString *expectedValue;
        __block SDLImageType expectedImageType;

        beforeEach(^{
            testSDLImage = nil;
            expectedValue = nil;
            expectedImageType = nil;
        });

        it(@"Should set and get correctly", ^{
            NSString *value = @"value";
            SDLImageType imageType = SDLImageTypeDynamic;

            testSDLImage = [[SDLImage alloc] init];
            testSDLImage.value = value;
            testSDLImage.imageType = imageType;

            expectedValue = value;
            expectedImageType = imageType;
        });

        it(@"Should get correctly when initialized as a dictionary", ^{
            NSString *value = @"value";
            SDLImageType imageType = SDLImageTypeStatic;

            NSMutableDictionary* dict = [@{SDLNameValue:value,
                                           SDLNameImageType:imageType} mutableCopy];
            testSDLImage = [[SDLImage alloc] initWithDictionary:dict];

            expectedValue = value;
            expectedImageType = imageType;
        });

        it(@"Should get correctly when initialized with a name only", ^{
            NSString *name = @"value";
            testSDLImage = [[SDLImage alloc] initWithName:name];

            expectedValue = name;
            expectedImageType = SDLImageTypeDynamic;
        });

        it(@"Should get correctly when initialized with static image value", ^{
            UInt16 staticImageValue = 2568;
            testSDLImage = [[SDLImage alloc] initWithStaticImageValue:staticImageValue];

            expectedValue = @"2568";
            expectedImageType = SDLImageTypeStatic;
        });

        afterEach(^{
            expect(testSDLImage.value).to(equal(expectedValue));
            expect(testSDLImage.imageType).to(equal(expectedImageType));
        });
    });

    it(@"Should return nil if not set", ^{
        SDLImage *testSDLImage = [[SDLImage alloc] init];
        expect(testSDLImage.value).to(beNil());
        expect(testSDLImage.imageType).to(beNil());
    });
});

QuickSpecEnd
