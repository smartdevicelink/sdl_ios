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
        __block NSNumber<SDLBool> *expectedIsTemplate;

        beforeEach(^{
            testSDLImage = nil;
            expectedValue = nil;
            expectedImageType = nil;
            expectedIsTemplate = @NO;
        });

        it(@"Should set and get correctly", ^{
            NSString *value = @"value";
            SDLImageType imageType = SDLImageTypeDynamic;

            testSDLImage = [[SDLImage alloc] init];
            testSDLImage.value = value;
            testSDLImage.imageType = imageType;
            testSDLImage.isTemplate = @YES;

            expectedValue = value;
            expectedImageType = imageType;
            expectedIsTemplate = @YES;
        });

        it(@"Should set and get correctly when initialized", ^{
            NSString *value = @"value";
            SDLImageType imageType = SDLImageTypeStatic;

            NSDictionary* dict = [@{SDLNameValue:value,
                                           SDLNameImageType:imageType,
                                           SDLNameImageTemplate:@YES
                                           } mutableCopy];
            testSDLImage = [[SDLImage alloc] initWithDictionary:dict];

            expectedValue = value;
            expectedImageType = imageType;
            expectedIsTemplate = @YES;
        });

        afterEach(^{
            expect(testSDLImage.value).to(equal(expectedValue));
            expect(testSDLImage.imageType).to(equal(expectedImageType));
            expect(testSDLImage.isTemplate).to(equal(expectedIsTemplate));
        });
    });

    it(@"Should return nil if not set", ^{
        SDLImage *testSDLImage = [[SDLImage alloc] init];
        expect(testSDLImage.value).to(beNil());
        expect(testSDLImage.imageType).to(beNil());
        expect(testSDLImage.isTemplate).to(beNil());
    });
});

describe(@"initializers", ^{
    __block SDLImage *testImage = nil;
    __block NSString *testValue = @"testImage";
    __block SDLImageType testImageType = SDLImageTypeDynamic;
    __block BOOL testIsTemplate = YES;

    beforeEach(^{
        testImage = nil;
    });

    context(@"init", ^{
        testImage = [[SDLImage alloc] init];

        expect(testImage).toNot(beNil());
        expect(testImage.value).to(beNil());
        expect(testImage.imageType).to(beNil());
        expect(testImage.isTemplate).to(beNil());
    });

    context(@"initWithName:ofType:", ^{
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testImage = [[SDLImage alloc] initWithName:testValue ofType:testImageType];

        expect(testImage).toNot(beNil());
        expect(testImage.value).to(equal(testValue));
        expect(testImage.imageType).to(equal(testImageType));
        expect(testImage.isTemplate).to(beFalse());
        #pragma clang diagnostic pop
    });

    context(@"initWithName:ofType:isTemplate", ^{
        testImage = [[SDLImage alloc] initWithName:testValue ofType:testImageType isTemplate:testIsTemplate];

        expect(testImage).toNot(beNil());
        expect(testImage.value).to(equal(testValue));
        expect(testImage.imageType).to(equal(testImageType));
        expect(testImage.isTemplate).to(equal(testIsTemplate));
    });

    context(@"initWithName:", ^{
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        testImage = [[SDLImage alloc] initWithName:testValue];

        expect(testImage).toNot(beNil());
        expect(testImage.value).to(equal(testValue));
        expect(testImage.imageType).to(equal(SDLImageTypeDynamic));
        expect(testImage.isTemplate).to(beFalse());
        #pragma clang diagnostic pop
    });

    context(@"initWithName:isTemplate", ^{
        testImage = [[SDLImage alloc] initWithName:testValue isTemplate:testIsTemplate];

        expect(testImage).toNot(beNil());
        expect(testImage.value).to(equal(testValue));
        expect(testImage.imageType).to(equal(SDLImageTypeDynamic));
        expect(testImage.isTemplate).to(equal(testIsTemplate));
    });

    context(@"initWithStaticImageValue:", ^{
        UInt16 staticImageValue = 12;
        testImage = [[SDLImage alloc] initWithStaticImageValue:staticImageValue];

        expect(testImage).toNot(beNil());
        expect(testImage.value).to(equal([NSString stringWithFormat:@"%hu", staticImageValue]));
        expect(testImage.imageType).to(equal(SDLImageTypeStatic));
        expect(testImage.isTemplate).to(beTrue());
    });

    context(@"initWithStaticIconName:", ^{
        SDLStaticIconName staticIconName = SDLStaticIconNameFavoriteStar;
        testImage = [[SDLImage alloc] initWithStaticIconName:staticIconName];

        expect(testImage).toNot(beNil());
        expect(testImage.value).to(equal(staticIconName));
        expect(testImage.imageType).to(equal(SDLImageTypeStatic));
        expect(testImage.isTemplate).to(beTrue());
    });
});

QuickSpecEnd
