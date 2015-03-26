//
//  SDLHexUtilitySpec.m
//  SmartDeviceLink-iOS

#import <UIKit/UIKit.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHexUtility.h"


QuickSpecBegin(SDLHexUtilitySpec)

describe(@"getting a hex string", ^{
    context(@"from a byte array", ^{
        it(@"correctly returns a hex string", ^{
            UInt8 byteArray[] = {0x00, 0x0F, 0xFF, 0x13};
            NSString *hexString = [SDLHexUtility getHexString:byteArray length:4];
            
            expect(hexString).to(equal(@"000FFF13"));
        });
    });
    
    context(@"From a data object", ^{
        it(@"correctly returns a hex string", ^{
            UInt8 byteArray[] = {0x00, 0x0F, 0xFF, 0x13};
            NSData *byteData = [NSData dataWithBytes:byteArray length:4];
            NSString *hexString = [SDLHexUtility getHexString:byteData];
            
            expect(hexString).to(equal(@"000FFF13"));
        });
    });
});

QuickSpecEnd
