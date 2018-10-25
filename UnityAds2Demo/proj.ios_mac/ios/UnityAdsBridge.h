//
//  UnityAdsBridge.h
//  UnityAds2Demo
//
//  Created by Solomon Li on 7/15/16.
//
//

#import <Foundation/Foundation.h>
//#import <UnityAds/UnityAds.h>
#import <UnityAds/UMONShowAdPlacementContent.h>
#import <UnityAds/UnityMonetization.h>
#import <UnityAds/UADSBanner.h>



@interface UnityAdsBridge : UIViewController<UnityMonetizationDelegate, UnityAdsBannerDelegate, UMONShowAdDelegate>

+ (UnityAdsBridge* ) viewController;

@property(strong, nonatomic) UIView *bannerView;


@end
