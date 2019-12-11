//
//  NSError+ChartboostErrors.h
//  MoPubSDK
//
//  Copyright © 2019 Chartboost. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Chartboost/CHBAdDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (ChartboostErrors)
+ (NSError *)errorWithCacheEvent:(CHBAdEvent *)event error:(CHBCacheError *)error;
+ (NSError *)errorWithShowEvent:(CHBShowEvent *)event error:(CHBShowError *)error;
+ (NSError *)errorWithClickEvent:(CHBClickEvent *)event error:(CHBClickError *)error;
+ (NSError *)errorWithDidFinishHandlingClickEvent:(CHBClickEvent *)event error:(CHBClickError *)error;
@end

NS_ASSUME_NONNULL_END
