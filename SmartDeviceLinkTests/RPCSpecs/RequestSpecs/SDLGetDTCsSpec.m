//
//  SDLGetDTCsSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLGetDTCs.h"
#import "SDLNames.h"

QuickSpecBegin(SDLGetDTCsSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGetDTCs* testRequest = [[SDLGetDTCs alloc] init];
        
		testRequest.ecuName = @4321;
		testRequest.dtcMask = @22;

		expect(testRequest.ecuName).to(equal(@4321));
		expect(testRequest.dtcMask).to(equal(@22));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLNameRequest:
                                                           @{SDLNameParameters:
                                                                 @{SDLNameECUName:@4321,
                                                                   SDLNameDTCMask:@22},
                                                             SDLNameOperationName:SDLNameEndAudioPassThru}} mutableCopy];
        SDLGetDTCs* testRequest = [[SDLGetDTCs alloc] initWithDictionary:dict];
        
        expect(testRequest.ecuName).to(equal(@4321));
        expect(testRequest.dtcMask).to(equal(@22));
    });

    it(@"Should return nil if not set", ^ {
        SDLGetDTCs* testRequest = [[SDLGetDTCs alloc] init];
        
		expect(testRequest.ecuName).to(beNil());
		expect(testRequest.dtcMask).to(beNil());
	});
});

QuickSpecEnd
