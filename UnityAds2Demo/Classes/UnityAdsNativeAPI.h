//
// Created by Callie on 2019/2/20.
//

#ifndef UNITY_MONETIZATION_UNITYADSNATIVEAPI_H
#define UNITY_MONETIZATION_UNITYADSNATIVEAPI_H


#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#include <c++/v1/string>
#include "platform/android/jni/JniHelper.h"
#endif

/* implement these functions with sdk api of different platforms */
#ifdef __cplusplus
extern "C" {
#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
JNIEXPORT void JNICALL Java_org_cocos2dx_cpp_UnityMonetizationJNI_reward (JNIEnv *, jobject, jstring s);
static char* jstringTostring(JNIEnv* env, jstring jstr);
static std::string jstringToStdstring(JNIEnv* env, jstring jstr);

// Unity Ads required methods
extern void UnityAdsInit(const char* parameter, bool testMode);
extern bool UnityAdsIsReady (const char* parameter);
extern void UnityAdsShow (const char* parameter);
extern void UnityAdsShowBanner(const char *parameter);
extern void UnityAdsHideBanner(const char *parameter);
extern bool UnityAdsBannerShown(const char *parameter);

// Unity Ads assist methods
extern bool UnityAdsGetDebugMode();
extern std::string UnityAdsGetPlacementState(const char* parameter);
extern std::string UnityAdsGetVersion();
extern bool UnityAdsIsInitialized();
extern bool UnityAdsIsSupported();
extern void UnityAdsSetDebugMode(bool debugMode);

#endif

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)

// Unity Ads required methods
        void UnityAdsInit (const char *parameter, bool testMode);
        bool UnityAdsIsReady (const char *parameter);
        void UnityAdsShow (const char *parameter);
    void UnityAdsShowBanner(const char *parameter);
    void UnityAdsHideBanner(const char *parameter);
    bool UnityAdsBannerShown(const char *parameter);

        // Unity Ads assist methods
        bool UnityAdsGetDebugMode();
        std::string UnityAdsGetPlacementState(const char* parameter);
        std::string UnityAdsGetVersion();
        bool UnityAdsIsInitialized();
        bool UnityAdsIsSupported();
        void UnityAdsSetDebugMode(bool debugMode);
#endif

#ifdef __cplusplus
}
#endif



#endif //PROJ_ANDROID_UNITYADSNATIVEAPI_H
