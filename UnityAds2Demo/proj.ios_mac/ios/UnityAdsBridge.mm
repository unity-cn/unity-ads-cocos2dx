//
//  UnityAdsBridge.m
//  UnityAds2Demo
//
//  Created by Solomon Li on 7/15/16.
//
//

#import "UnityAdsNativeAPI.h"
#import "UnityAdsBridge.h"
#import "AppController.h"
#import "HelloWorldScene.h"
#import <UnityAds/UnityAds.h>

static BOOL bannerShown = NO;

@implementation UnityAdsBridge

+ (UIViewController* ) viewController {
    
    UIApplication* app = [UIApplication sharedApplication];
    AppController* controller = (AppController*)[app delegate];
    UIViewController* rootController = [controller.window rootViewController];
    return rootController;
}

#pragma mark -
#pragma mark UnityAdsDelegate

- (void)unityAdsDidStart:(NSString *)placementId{
    NSLog(@"[UnityMonetization delegate] unityAdsDidStart with placementId=%@", placementId);
}

- (void)unityAdsDidFinish:(NSString *)placementId
          withFinishState:(UnityAdsFinishState)state{
    
    NSLog(@"[UnityMonetization delegate] unityAdsDidFinish with placementId=%@ finishState=%ld", placementId, (long)state);
    
    if(state == kUnityAdsFinishStateCompleted) {
        auto scene = cocos2d::Director::getInstance()->getRunningScene()->getChildren().at(1);
        if (typeid(*scene) == typeid(HelloWorld)) {
            HelloWorld* gameScene = static_cast<HelloWorld*>(scene);
            const char *placementIdC = [placementId UTF8String];
            gameScene->rewardPlayer(placementIdC);
        }
    }
}

- (void)placementContentReady:(nonnull NSString *)placementId placementContent:(nonnull UMONPlacementContent *)decision {
    NSLog(@"[UnityMonetization delegate] placementContentReady with placementId=%@", placementId);
}

- (void)placementContentStateDidChange:(nonnull NSString *)placementId placementContent:(nonnull UMONPlacementContent *)placementContent previousState:(UnityMonetizationPlacementContentState)previousState newState:(UnityMonetizationPlacementContentState)newState {
    NSLog(@"[UnityMonetization delegate] placementContentStateDidChange with placementId=%@", placementId);
}

- (void)unityAdsBannerDidClick:(nonnull NSString *)placementId {
    NSLog(@"[UnityMonetization delegate] unityAdsBannerDidClick with placementId=%@", placementId);
}

- (void)unityAdsBannerDidError:(nonnull NSString *)message {
    
    NSLog(@"[UnityMonetization delegate] unityAdsBannerDidError with message=%@", message);
}

- (void)unityAdsBannerDidHide:(nonnull NSString *)placementId {
    
    NSLog(@"[UnityMonetization delegate] unityAdsBannerDidHide with placementId=%@", placementId);
    bannerShown = NO;
}

- (void)unityAdsBannerDidLoad:(nonnull NSString *)placementId view:(nonnull UIView *)view {
    
    NSLog(@"[UnityMonetization delegate] unityAdsBannerDidLoad with placementId=%@", placementId);
    self.bannerView = view;
    [[[UnityAdsBridge viewController] view] addSubview:self.bannerView];
}

- (void)unityAdsBannerDidShow:(nonnull NSString *)placementId {
    
    NSLog(@"[UnityMonetization delegate] unityAdsBannerDidShow with placementId=%@", placementId);
    bannerShown = YES;
}

- (void)unityAdsBannerDidUnload:(nonnull NSString *)placementId {
    
    NSLog(@"[UnityMonetization delegate] unityAdsBannerDidUnload with placementId=%@", placementId);
    bannerShown = NO;
    self.bannerView = nil;
}

- (void)unityServicesDidError:(UnityServicesError)error withMessage:(nonnull NSString *)message {
    
    NSLog(@"[UnityMonetization delegate] unityServicesDidError with error=%ld message=%@", error, message);
}

@end



#pragma mark -
#pragma mark Unity Ads Native API Implementation

void UnityAdsInit (const char *gameIdParameter, bool testMode) {
    
    NSLog(@"[UnityMonetization] UnityAdsInit");
    
    UnityAdsBridge* bridge = [UnityAdsBridge new];
    NSString* gameId = [NSString stringWithFormat:@"%s", gameIdParameter];
    [UnityAdsBanner setDelegate:bridge];
    [UnityMonetization initialize:gameId delegate:bridge testMode:testMode];
}

bool UnityAdsIsReady (const char *parameter){
    NSString* placementId = [NSString stringWithFormat:@"%s", parameter];
    bool isReady = [UnityMonetization isReady:placementId];
    NSLog(@"[UnityMonetization] UnityAdsIsReady for placement=%@ readyState=%@", placementId, isReady?@"True":@"False");
    return isReady;
}

void UnityAdsShow (const char *parameter){
    NSString* placementId = [NSString stringWithFormat:@"%s", parameter];
    UMONPlacementContent* placementContent = [UnityMonetization getPlacementContent:placementId];
    if ([placementContent isKindOfClass:[UMONShowAdPlacementContent class]]) {
        [(UMONShowAdPlacementContent *)placementContent show:[UnityAdsBridge viewController] withDelegate:[UnityAdsBridge viewController]];
    }
}


void UnityAdsShowBanner(const char *parameter){
    
    NSString* placementId = [NSString stringWithFormat:@"%s", parameter];
    [UnityAdsBanner loadBanner:placementId];
}

void UnityAdsHideBanner(const char *parameter){
    [UnityAdsBanner destroy];
}


bool UnityAdsBannerShown(const char *parameter){
    return bannerShown;
}

bool UnityAdsGetDebugMode() {
    NSLog(@"[UnityServices] UnityAdsGetDebugMode");
    return [UnityServices getDebugMode];
}

std::string UnityAdsGetPlacementState(const char* parameter) {
    NSLog(@"[UnityMonetization] UnityAdsGetPlacementState");
    NSString* placementId = [NSString stringWithFormat:@"%s", parameter];
    UMONPlacementContent *placementContent = [UnityMonetization getPlacementContent:placementId];
    
    UnityMonetizationPlacementContentState state = [placementContent state];
    switch(state){
        case kPlacementContentStateReady:
            return "kPlacementContentStateReady";
        case kPlacementContentStateNoFill:
            return "kPlacementContentStateNoFill";
        case kPlacementContentStateWaiting:
            return "kPlacementContentStateWaiting";
        case kPlacementContentStateDisabled:
            return "kPlacementContentStateDisabled";
        case kPlacementContentStateNotAvailable:
            return "kPlacementContentStateNotAvailable";
    }
}

std::string UnityAdsGetVersion() {
    NSLog(@"[UnityServices] UnityAdsGetVersion");
    std::string ret = std::string([[UnityServices getVersion] UTF8String]);
    return ret;
}

bool UnityAdsIsInitialized() {
    NSLog(@"[UnityServices] UnityAdsIsInitialized");
    return [UnityServices isInitialized];
}

bool UnityAdsIsSupported() {
    NSLog(@"[UnityServices] UnityAdsIsSupported");
    return [UnityServices isSupported];
}

void UnityAdsSetDebugMode(bool debugMode) {
    NSLog(@"[UnityServices] UnityAdsSetDebugMode");
    [UnityServices setDebugMode:debugMode];
}
