//
//  SDLImageTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLImageType.h"

QuickSpecBegin(SDLImageTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLImageTypeStatic).to(equal(@"STATIC"));
        expect(SDLImageTypeDynamic).to(equal(@"DYNAMIC"));
    });
});

QuickSpecEnd
