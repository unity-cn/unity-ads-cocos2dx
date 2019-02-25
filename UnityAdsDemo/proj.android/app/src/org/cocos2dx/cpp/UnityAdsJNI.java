package org.cocos2dx.cpp;

import android.app.Activity;
import com.unity3d.ads.UnityAds;
import com.unity3d.services.banners.*;
import com.unity3d.services.banners.view.BannerPosition;

import android.util.Log;

public class UnityAdsJNI {

    public static Activity activity;
    public static UnityAdsListener unityAdsListener;

    public static native void reward(String placementId);

    // Need update: pass in test mode and game id
    public static void UnityAdsInit(String gameId, boolean testMode){
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] UnityAdsInitialize");
        if(gameId == null || gameId.isEmpty()){
            Log.d("Unity cocos2dx Sample","[UnityAds Demo] UnityAdsInitialize failed, no gameId specified");
            return;
        }
        UnityBanners.setBannerListener(unityAdsListener);
        UnityAds.initialize(activity, gameId, unityAdsListener, testMode);
    }

    public static boolean UnityAdsIsReady(String placementId) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] UnityAdsIsReady");
        if(placementId == null || placementId.isEmpty()){
            return UnityAds.isReady();
        }
        return UnityAds.isReady(placementId);
    }

    public static void UnityAdsShow(String placementId) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] UnityAdsShow");
        if(placementId == null || placementId.isEmpty()) {
            UnityAds.show(activity);
        } else {
            UnityAds.show(activity, placementId);
        }
    }

    public static void UnityAdsShowBanner(String placementId) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] UnityAdsShowBanner");
        UnityBanners.setBannerPosition(BannerPosition.BOTTOM_CENTER);
        if(placementId == null || placementId.isEmpty()) {
            UnityBanners.loadBanner(activity);
        } else if(!UnityAdsIsReady(placementId))
        {
            Log.d("Unity cocos2dx Sample","[UnityAds Demo] Banner placement " + placementId + " is not ready.");
        } else {
            UnityBanners.loadBanner(activity, placementId);
        }
    }

    public static boolean UnityAdsHideBanner() {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] UnityAdsHideBanner");
        try {
            return BannerHide.hide();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean UnityAdsBannerShown() {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] UnityAdsBannerShown");
        return UnityAdsListener.BannerIsShown;
    }

    // Other methods, excluded methods that are unreasonable to expose to cpp layer

    public static boolean UnityAdsGetDebugMode(){
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] UnityAdsGetDebugMode");
        return UnityAds.getDebugMode();
    }

    public static String UnityAdsGetPlacementState(String placementId) {
        if(placementId == null || placementId.isEmpty()) {
            return UnityAds.getPlacementState().toString();
        }
        return UnityAds.getPlacementState(placementId).toString();
    }

    public static String UnityAdsGetVersion() {
        return UnityAds.getVersion();
    }

    public static boolean UnityAdsIsInitialized() {
        return UnityAds.isInitialized();
    }

    public static boolean UnityAdsIsSupported() {
        return UnityAds.isSupported();
    }

    public static void UnityAdsSetDebugMode(boolean debugMode) {
        UnityAds.setDebugMode(debugMode);
    }
}
