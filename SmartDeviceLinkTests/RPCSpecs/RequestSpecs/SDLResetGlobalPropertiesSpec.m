//
//  SDLResetGlobalPropertiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLResetGlobalProperties.h"
#import "SDLGlobalProperty.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"

QuickSpecBegin(SDLResetGlobalPropertiesSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLResetGlobalProperties* testRequest = [[SDLResetGlobalProperties alloc] init];
        
        testRequest.properties = [@[SDLGlobalPropertyMenuName, SDLGlobalPropertyVoiceRecognitionHelpTitle] copy];
        
        expect(testRequest.properties).to(equal([@[SDLGlobalPropertyMenuName, SDLGlobalPropertyVoiceRecognitionHelpTitle] copy]));
    });
    
    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameRequest:
                                           @{SDLRPCParameterNameParameters:
                                                 @{SDLRPCParameterNameProperties:[@[SDLGlobalPropertyMenuName, SDLGlobalPropertyVoiceRecognitionHelpTitle] copy]},
                                             SDLRPCParameterNameOperationName:SDLRPCFunctionNameResetGlobalProperties}} mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLResetGlobalProperties* testRequest = [[SDLResetGlobalProperties alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        
        expect(testRequest.properties).to(equal([@[SDLGlobalPropertyMenuName, SDLGlobalPropertyVoiceRecognitionHelpTitle] copy]));
    });
    
    it(@"Should return nil if not set", ^ {
        SDLResetGlobalProperties* testRequest = [[SDLResetGlobalProperties alloc] init];
        
        expect(testRequest.properties).to(beNil());
    });
});

QuickSpecEnd
