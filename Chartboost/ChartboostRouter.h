//
//  ChartboostRouter.h
//  MoPubSDK
//
//  Copyright (c) 2015 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLogging.h"
#import <Chartboost/Chartboost+Mediation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChartboostRouter : NSObject
+ (CHBMediation *)mediation;
+ (void)setLoggingLevel:(MPBLogLevel)loggingLevel;
+ (void)setDataUseConsentWithMopubConfiguration;
+ (void)startWithParameters:(NSDictionary *)parameters completion:(void(^)(BOOL))completion;
@end

NS_ASSUME_NONNULL_END
