//
//  ChartboostBannerCustomEvent.m
//  MoPubSDK
//
//  Copyright (c) 2019 MoPub. All rights reserved.
//

#import "ChartboostBannerCustomEvent.h"
#if __has_include("MoPub.h")
    #import "MPLogging.h"
#endif
#import <Chartboost/Chartboost.h>
#import <Chartboost/CHBBanner.h>

@interface ChartboostBannerCustomEvent () <CHBBannerDelegate>

@property (nonatomic) CHBBanner *banner;
@property (nonatomic, copy) NSString *appID;

@end

@implementation ChartboostBannerCustomEvent

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    self.appID = [info objectForKey:@"appId"];
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], self.appID);
    
    NSString *location = [info objectForKey:@"location"];
    location = [location length] != 0 ? location: CBLocationDefault;
    if (self.banner && (!CGSizeEqualToSize(self.banner.size, size) || ![self.banner.location isEqualToString:location])) {
        NSError *error = [NSError errorWithCode:MOPUBErrorAdapterFailedToLoadAd localizedDescription:@"Chartboost adapter failed to load ad: size or location in new request doesn't match the existing banner values."];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.appID);
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
        return;
    }
    
    if (!self.banner) {
        self.banner = [[CHBBanner alloc] initWithSize:size location:location delegate:self];
        self.banner.automaticallyRefreshesContent = NO;
    }
    [self.banner showFromViewController:[self.delegate viewControllerForPresentingModalView]];
}

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    return NO;
}

// MARK: - CHBBannerDelegate

- (void)didCacheAd:(CHBCacheEvent *)event error:(nullable CHBCacheError *)error
{
    if (error) {
        NSError *error = [self errorWithCacheError:error];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], self.appID);
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
    } else {
        MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], self.appID);
        [self.delegate bannerCustomEvent:self didLoadAd:self.banner];
    }
}

- (void)willShowAd:(CHBShowEvent *)event error:(nullable CHBShowError *)error
{
    if (error) {
        NSError *error = [self errorWithShowError:error];
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error], self.appID);
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
    } else {
        MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], self.appID);
    }
}

- (void)didShowAd:(CHBShowEvent *)event error:(nullable CHBShowError *)error
{
    if (error) {
        NSError *error = [self errorWithShowError:error];
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error], self.appID);
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
    } else {
        MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], self.appID);
        [self.delegate trackImpression];
    }
}

- (void)didClickAd:(CHBClickEvent *)event error:(nullable CHBClickError *)error
{
    if (error) {
        NSError *error = [self errorWithClickError:error];
        MPLogAdEvent([MPLogEvent error:error message:nil], self.appID);
    } else {
        MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], self.appID);
        [self.delegate bannerCustomEventWillBeginAction:self];
        [self.delegate trackClick];
    }
}

- (void)didFinishHandlingClick:(CHBClickEvent *)event error:(nullable CHBClickError *)error
{
    if (error) {
        NSError *error = [self errorWithClickHandlingError:error];
        MPLogAdEvent([MPLogEvent error:error message:nil], self.appID);
    }
    [self.delegate bannerCustomEventDidFinishAction:self];
}

// MARK: - Helpers

- (NSError *)errorWithCacheError:(CHBCacheError *)error
{
    NSString *description = [NSString stringWithFormat:@"Chartboost adapter failed to load ad with error %d", error.code];
    NSError *error = [NSError errorWithCode:MOPUBErrorAdapterFailedToLoadAd localizedDescription:description];
    return error;
}

- (NSError *)errorWithShowError:(CHBShowError *)error
{
    NSString *description = [NSString stringWithFormat:@"Chartboost adapter failed to show ad with error %d", error.code];
    NSError *error = [NSError errorWithCode:MOPUBErrorAdapterFailedToLoadAd localizedDescription:description];
    return error;
}

- (NSError *)errorWithClickError:(CHBShowError *)error
{
    NSString *description = [NSString stringWithFormat:@"Chartboost adapter failed to click ad with error %d", error.code];
    NSError *error = [NSError errorWithCode:MOPUBErrorUnknown localizedDescription:description];
    return error;
}

- (NSError *)errorWithClickHandlingError:(CHBShowError *)error
{
    NSString *description = [NSString stringWithFormat:@"Chartboost adapter did finish handling click with error %d", error.code];
    NSError *error = [NSError errorWithCode:MOPUBErrorUnknown localizedDescription:description];
    return error;
}

@end