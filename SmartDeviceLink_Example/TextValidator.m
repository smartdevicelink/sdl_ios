//
//  TextValidator.m
//  SmartDeviceLink
//
//  Created by Nicole on 7/20/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "TextValidator.h"

@implementation TextValidator

static NSString *validCharacters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789. ";

+ (NSString *)validateText:(NSString *)text length:(UInt8)length {
    if (text.length == 0) { return text; }
    NSString *filteredText = [self sdlex_filterUnsupportedCharactersFromText:text];
    NSString *condensedText = [self sdlex_condenseWhitespace:filteredText];
    NSString *truncatedText = [self sdlex_truncateText:condensedText length:length];
    return truncatedText;
}

+ (NSString *)sdlex_filterUnsupportedCharactersFromText:(NSString *)text {
    NSCharacterSet *supportedCharacters = [NSCharacterSet characterSetWithCharactersInString:validCharacters];
    return [[text componentsSeparatedByCharactersInSet:supportedCharacters.invertedSet] componentsJoinedByString:@" "];
}

+ (NSString *)sdlex_truncateText:(NSString *)text length:(UInt8)length {
    return [text substringToIndex:MIN(length, text.length)];
}

+ (NSString *)sdlex_condenseWhitespace:(NSString *)text {
    NSArray<NSString *> *components = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSMutableArray<NSString *> *nonEmptyComponents = [NSMutableArray array];
    for (NSString *string in components) {
        if (string.length == 0) { continue; }
        [nonEmptyComponents addObject:string];
    }
    return [nonEmptyComponents componentsJoinedByString:@" "];
}

@end
