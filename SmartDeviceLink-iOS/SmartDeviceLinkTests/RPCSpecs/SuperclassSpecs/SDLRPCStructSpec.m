//
//  SDLRPCStruct.m
//  SmartDeviceLink-iOS


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCStruct.h"

QuickSpecBegin(SDLRPCStructSpec)

describe(@"SerializeAsDictionary Tests", ^ {
    it(@"Should serialize correctly", ^ {
        NSMutableDictionary* dict = [@{@"Key":@"Value", @"Answer":@42, @"Struct":[[SDLRPCStruct alloc] initWithDictionary:[@{@"Array":@[@1, @1, @1, @1]} mutableCopy]]} mutableCopy];
        SDLRPCStruct* testStruct = [[SDLRPCStruct alloc] initWithDictionary:dict];
        
        expect([testStruct serializeAsDictionary:2]).to(equal([@{@"Key":@"Value", @"Answer":@42, @"Struct":@{@"Array":@[@1, @1, @1, @1]}} mutableCopy]));
    });
});

QuickSpecEnd