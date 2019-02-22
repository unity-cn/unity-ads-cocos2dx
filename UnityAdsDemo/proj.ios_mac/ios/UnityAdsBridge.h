
#import <UnityAds/UnityAds.h>
#import <UnityAds/UADSBanner.h>

@interface UnityAdsBridge : UIViewController<UnityAdsDelegate, UnityAdsBannerDelegate>

+ (UIViewController* ) viewController;
@property(strong, nonatomic) UIView *bannerView;

@end
