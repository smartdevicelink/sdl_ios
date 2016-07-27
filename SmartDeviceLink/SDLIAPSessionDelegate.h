//
//  SDLIAPSessionDelegate.h
//

#import <Foundation/Foundation.h>
@class SDLIAPSession;

@protocol SDLIAPSessionDelegate

- (void)onSessionInitializationCompleteForSession:(SDLIAPSession *)session;
- (void)onSessionStreamsEnded:(SDLIAPSession *)session;

@end
