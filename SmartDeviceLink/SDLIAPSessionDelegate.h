//
//  SDLIAPSessionDelegate.h
//

#import <Foundation/Foundation.h>
@class SDLIAPSession;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLIAPSessionDelegate

- (void)onSessionInitializationCompleteForSession:(SDLIAPSession *)session;
- (void)onSessionStreamsEnded:(SDLIAPSession *)session;

@end

NS_ASSUME_NONNULL_END
