
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

- (void)unityAdsReady:(NSString *)placementId {
    NSLog(@"[UnityAds delegate] unityAdsReady with placementId=%@", placementId);
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    NSLog(@"[UnityAds delegate] unityAdsDidError with message=%@ , and error=%ld", message, error);
}

- (void)unityAdsDidStart:(NSString *)placementId{
    
}

- (void)unityAdsDidFinish:(NSString *)placementId
          withFinishState:(UnityAdsFinishState)state{
    if(state == kUnityAdsFinishStateCompleted) {
        auto scene = cocos2d::Director::getInstance()->getRunningScene()->getChildren().at(1);
        if (typeid(*scene) == typeid(HelloWorld)) {
            HelloWorld* gameScene = static_cast<HelloWorld*>(scene);
            const char *placementIdC = [placementId UTF8String];
            gameScene->rewardPlayer(placementIdC);
        }
    }
}

#pragma mark -
#pragma mark UnityAdsBannerDelegate

- (void)unityAdsBannerDidClick:(nonnull NSString *)placementId {
    NSLog(@"[UnityAdsBanner delegate] unityAdsBannerDidClick with placementId=%@", placementId);
}

- (void)unityAdsBannerDidError:(nonnull NSString *)message {
    
    NSLog(@"[UnityAdsBanner delegate] unityAdsBannerDidError with message=%@", message);
}

- (void)unityAdsBannerDidHide:(nonnull NSString *)placementId {
    
    NSLog(@"[UnityAdsBanner delegate] unityAdsBannerDidHide with placementId=%@", placementId);
    bannerShown = NO;
}

- (void)unityAdsBannerDidLoad:(nonnull NSString *)placementId view:(nonnull UIView *)view {
    
    NSLog(@"[UnityAdsBanner delegate] unityAdsBannerDidLoad with placementId=%@", placementId);
    self.bannerView = view;
    [[[UnityAdsBridge viewController] view] addSubview:self.bannerView];
}

- (void)unityAdsBannerDidShow:(nonnull NSString *)placementId {
    
    NSLog(@"[UnityAdsBanner delegate] unityAdsBannerDidShow with placementId=%@", placementId);
    bannerShown = YES;
}

- (void)unityAdsBannerDidUnload:(nonnull NSString *)placementId {
    
    NSLog(@"[UnityAdsBanner delegate] unityAdsBannerDidUnload with placementId=%@", placementId);
    bannerShown = NO;
    self.bannerView = nil;
}

- (void)unityServicesDidError:(UnityServicesError)error withMessage:(nonnull NSString *)message {
    
    NSLog(@"[UnityAdsBanner delegate] unityServicesDidError with error=%ld message=%@", error, message);
}

@end

#pragma mark -
#pragma mark Unity Ads Native API Implementation

void UnityAdsInit (const char *gameIdParameter, bool testMode) {
    
    NSLog(@"[UnityAds] UnityAdsInit");
    
    UnityAdsBridge* bridge = [UnityAdsBridge new];
    NSString* gameId = [NSString stringWithFormat:@"%s", gameIdParameter];
    [UnityAdsBanner setDelegate:bridge];
    [UnityAds initialize:gameId delegate:bridge testMode:testMode];
}

bool UnityAdsIsReady (const char *parameter){
    NSString* placementId = [NSString stringWithFormat:@"%s", parameter];
    NSLog(@"[UnityAds] UnityAdsIsReady for placement=%@", placementId);
    return [UnityAds isReady:placementId];
}

void UnityAdsShow (const char *parameter){
    NSString* placementId = [NSString stringWithFormat:@"%s", parameter];
    [UnityAds show:[UnityAdsBridge viewController] placementId:placementId];
}

void UnityAdsShowBanner(const char *parameter){
    
    NSString* placementId = [NSString stringWithFormat:@"%s", parameter];
    [UnityAdsBanner loadBanner:placementId];
}

void UnityAdsHideBanner(){
    [UnityAdsBanner destroy];
}


bool UnityAdsBannerShown(){
    return bannerShown;
}

bool UnityAdsGetDebugMode() {
    NSLog(@"[UnityAds] UnityAdsGetDebugMode");
    return [UnityAds getDebugMode];
}

std::string UnityAdsGetPlacementState(const char* parameter) {
    NSLog(@"[UnityAds] UnityAdsGetPlacementState");
    UnityAdsPlacementState state = [UnityAds getPlacementState];
    switch(state){
        case kUnityAdsPlacementStateReady:
            return "kUnityAdsPlacementStateReady";
        case kUnityAdsPlacementStateNoFill:
            return "kUnityAdsPlacementStateNoFill";
        case kUnityAdsPlacementStateWaiting:
            return "kUnityAdsPlacementStateWaiting";
        case kUnityAdsPlacementStateDisabled:
            return "kUnityAdsPlacementStateDisabled";
        case kUnityAdsPlacementStateNotAvailable:
            return "kUnityAdsPlacementStateNotAvailable";
    }
}

std::string UnityAdsGetVersion() {
    NSLog(@"[UnityAds] UnityAdsGetVersion");
    std::string ret = std::string([[UnityAds getVersion] UTF8String]);
    return ret;
}

bool UnityAdsIsInitialized() {
    NSLog(@"[UnityAds] UnityAdsIsInitialized");
    return [UnityAds isInitialized];
}

bool UnityAdsIsSupported() {
    NSLog(@"[UnityAds] UnityAdsIsSupported");
    return [UnityAds isSupported];
}

void UnityAdsSetDebugMode(bool debugMode) {
    NSLog(@"[UnityAds] UnityAdsSetDebugMode");
    [UnityAds setDebugMode:debugMode];
}
