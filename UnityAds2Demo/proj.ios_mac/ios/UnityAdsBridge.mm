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

@implementation UnityAdsBridge

+ (UIViewController* ) viewController {
    
    UIApplication* app = [UIApplication sharedApplication];
    AppController* controller = (AppController*)[app delegate];
    UIViewController* rootController = [controller.window rootViewController];
    return rootController;
}

#pragma mark -
#pragma mark UnityAdsDelegate

//- (void)unityAdsReady:(NSString *)placementId {
//    NSLog(@"[UnityAds delegate] unityAdsReady with placementId=%@", placementId);
//}
//
//- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
//    NSLog(@"[UnityAds delegate] unityAdsDidError with message=%@ , and error=%ld", message, error);
//}
//

- (void)unityAdsDidStart:(NSString *)placementId{
NSLog(@"[UnityAds delegate] placementContentReady with placementId=%@", placementId);
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

- (void)placementContentReady:(nonnull NSString *)placementId placementContent:(nonnull UMONPlacementContent *)decision {
    NSLog(@"[UnityAds delegate] placementContentReady with placementId=%@", placementId);
}

- (void)placementContentStateDidChange:(nonnull NSString *)placementId placementContent:(nonnull UMONPlacementContent *)placementContent previousState:(UnityMonetizationPlacementContentState)previousState newState:(UnityMonetizationPlacementContentState)newState {
    NSLog(@"[UnityAds delegate] placementContentStateDidChange with placementId=%@", placementId);
}

- (void)unityAdsBannerDidClick:(nonnull NSString *)placementId {
    NSLog(@"[UnityAds delegate] unityAdsBannerDidClick with placementId=%@", placementId);
}

- (void)unityAdsBannerDidError:(nonnull NSString *)message {
    
    NSLog(@"[UnityAds delegate] unityAdsBannerDidError with message=%@", message);
}

- (void)unityAdsBannerDidHide:(nonnull NSString *)placementId {
    
    NSLog(@"[UnityAds delegate] unityAdsBannerDidHide with placementId=%@", placementId);
}

- (void)unityAdsBannerDidLoad:(nonnull NSString *)placementId view:(nonnull UIView *)view {
    
    NSLog(@"[UnityAds delegate] unityAdsBannerDidLoad with placementId=%@", placementId);
}

- (void)unityAdsBannerDidShow:(nonnull NSString *)placementId {
    
    NSLog(@"[UnityAds delegate] unityAdsBannerDidShow with placementId=%@", placementId);
}

- (void)unityAdsBannerDidUnload:(nonnull NSString *)placementId {
    
    NSLog(@"[UnityAds delegate] unityAdsBannerDidUnload with placementId=%@", placementId);
}

- (void)unityServicesDidError:(UnityServicesError)error withMessage:(nonnull NSString *)message {
    
    NSLog(@"[UnityAds delegate] unityServicesDidError with error=%ld message=%@", error, message);
}

@end



#pragma mark -
#pragma mark Unity Ads Native API Implementation

void UnityAdsInit (const char *gameIdParameter, bool testMode) {
    
    NSLog(@"[UnityAds] UnityAdsInit");
    
    UnityAdsBridge* bridge = [UnityAdsBridge new];
    NSString* gameId = [NSString stringWithFormat:@"%s", gameIdParameter];
    [UnityMonetization initialize:gameId delegate:bridge testMode:testMode];
}

bool UnityAdsIsReady (const char *parameter){
    NSString* placementId = [NSString stringWithFormat:@"%s", parameter];
    NSLog(@"[UnityAds] UnityAdsIsReady for placement=%@", placementId);
    return [UnityMonetization isReady:placementId];
}

void UnityAdsShow (const char *parameter){
    NSString* placementId = [NSString stringWithFormat:@"%s", parameter];
    UMONPlacementContent* placementContent = [UnityMonetization getPlacementContent:placementId];
    if ([placementContent isKindOfClass:[UMONShowAdPlacementContent class]]) {
        [(UMONShowAdPlacementContent *)placementContent show:[UnityAdsBridge viewController] withDelegate:[UnityAdsBridge viewController]];
    }
}

bool UnityAdsGetDebugMode() {
    NSLog(@"[UnityServices] UnityAdsGetDebugMode");
    return [UnityServices getDebugMode];
}

std::string UnityAdsGetPlacementState(const char* parameter) {
    NSLog(@"[UnityAds] UnityAdsGetPlacementState");
    NSString* placementId = [NSString stringWithFormat:@"%s", parameter];
    UMONPlacementContent *placementContent = [UnityMonetization getPlacementContent:placementId];
    
    UnityMonetizationPlacementContentState state = [placementContent state];
    switch(state){
        case kPlacementContentStateReady:
            return "kUnityAdsPlacementStateReady";
        case kPlacementContentStateNoFill:
            return "kUnityAdsPlacementStateNoFill";
        case kPlacementContentStateWaiting:
            return "kUnityAdsPlacementStateWaiting";
        case kPlacementContentStateDisabled:
            return "kUnityAdsPlacementStateDisabled";
        case kPlacementContentStateNotAvailable:
            return "kUnityAdsPlacementStateNotAvailable";
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
