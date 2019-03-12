//
//  SDLDeleteFileSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeleteFile.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLDeleteFileSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLDeleteFile* testRequest = [[SDLDeleteFile alloc] init];
        
		testRequest.syncFileName = @"synchro";

		expect(testRequest.syncFileName).to(equal(@"synchro"));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary<NSString *, id> *dict = [@{SDLRPCParameterNameRequest:
                                                           @{SDLRPCParameterNameParameters:
                                                                 @{SDLRPCParameterNameSyncFileName:@"synchro"},
                                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameDeleteFile}} mutableCopy];
        SDLDeleteFile* testRequest = [[SDLDeleteFile alloc] initWithDictionary:dict];
        
        expect(testRequest.syncFileName).to(equal(@"synchro"));
    });

    it(@"Should return nil if not set", ^ {
        SDLDeleteFile* testRequest = [[SDLDeleteFile alloc] init];
        
		expect(testRequest.syncFileName).to(beNil());
	});
});

QuickSpecEnd
