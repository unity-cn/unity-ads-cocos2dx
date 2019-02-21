package org.cocos2dx.cpp;

import android.app.Activity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;

import com.unity3d.ads.UnityAds;

import com.unity3d.services.UnityServices;
import com.unity3d.services.banners.IUnityBannerListener;
import com.unity3d.services.banners.UnityBanners;
import com.unity3d.services.banners.view.BannerPosition;
import com.unity3d.services.core.log.DeviceLog;

import com.unity3d.services.monetization.IUnityMonetizationListener;
import com.unity3d.services.monetization.UnityMonetization;
import com.unity3d.services.monetization.placementcontent.ads.IShowAdListener;
import com.unity3d.services.monetization.placementcontent.ads.ShowAdListenerAdapter;
import com.unity3d.services.monetization.placementcontent.ads.ShowAdPlacementContent;
import com.unity3d.services.monetization.placementcontent.core.PlacementContent;

public class UnityMonetizationJNI {
    public static Activity activity;

    public static IUnityMonetizationListener unityMonetizationListener;
    public static IUnityBannerListener unityBannerListener;
    public static boolean bannerShown;
    private static View bannerView;

    public static native void reward(String placementId);

    // Need update: pass in test mode and game id
    public static void UnityAdsInitialize(String gameId, boolean testMode){
        DeviceLog.debug("[UnityMonetization Demo] UnityAdsInitialize");
        if(gameId == null || gameId.isEmpty()){
            DeviceLog.debug("[UnityMonetization Demo] UnityAdsInitialize failed, no gameId specified");
            return;
        }
        unityBannerListener = new UnityBannerListener();
        UnityBanners.setBannerListener(unityBannerListener);
        UnityMonetization.initialize(activity, gameId, unityMonetizationListener, testMode);
    }

    public static boolean UnityAdsIsReady(String placementId) {
        boolean isReady = UnityMonetization.isReady(placementId);
        DeviceLog.debug(String.format("[UnityMonetization Demo] UnityAdsIsReady for placement: %s readyState: %s",  placementId, isReady));
        return isReady;
    }

    public static void UnityAdsShow(String placementId) {
        DeviceLog.debug("[UnityMonetization Demo] UnityAdsShow");

        PlacementContent placementContent = UnityMonetization.getPlacementContent(placementId);
        if(placementContent instanceof ShowAdPlacementContent){
            ((ShowAdPlacementContent)placementContent).show(activity, new ShowAdListenerAdapter() {
                @Override
                public void onAdStarted(String placementId) {
                    DeviceLog.debug("[UnityMonetization Demo] onAdStarted for placement: " + placementId);
                }

                @Override
                public void onAdFinished(String placementId, UnityAds.FinishState withState) {
                    DeviceLog.debug(String.format("[UnityMonetization Demo] onAdFinished for placement: %s, withState: %s", placementId, withState));
                    reward(placementId);
                }
            });
        }
    }

    public static void UnityAdsShowBanner(String placementId) {
        if(bannerShown) return;
        UnityBanners.setBannerPosition(BannerPosition.BOTTOM_CENTER);
        UnityBanners.loadBanner(activity, placementId);
    }

    public static void UnityAdsHideBanner(){
        if(!bannerShown) return;
        UnityBanners.destroy();
    }

    public static boolean UnityAdsBannerShown(String placementId){
        return bannerShown;
    }

    // Other methods, excluded methods that are unreasonable to expose to cpp layer

    public static boolean UnityAdsGetDebugMode(){
        DeviceLog.debug("[UnityMonetization Demo] UnityAdsGetDebugMode");
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


    private static class UnityBannerListener implements IUnityBannerListener {
        @Override
        public void onUnityBannerLoaded(String placementId, View view) {

            DeviceLog.debug("[UnityMonetization Demo] onUnityBannerLoaded for placement: " + placementId);
            bannerView = view;
            ((ViewGroup)(UnityMonetizationJNI.activity.getWindow().getDecorView().getRootView())).addView(view);

        }

        @Override
        public void onUnityBannerUnloaded(String placementId) {
            DeviceLog.debug("[UnityMonetization Demo] onUnityBannerUnloaded for placement: " + placementId);
            bannerView =null;
        }

        @Override
        public void onUnityBannerShow(String placementId) {
            DeviceLog.debug("[UnityMonetization Demo] onUnityBannerShow for placement: " + placementId);
            UnityMonetizationJNI.bannerShown = true;
        }

        @Override
        public void onUnityBannerClick(String placementId) {
            DeviceLog.debug("[UnityMonetization Demo] onUnityBannerClick for placement: " + placementId);

        }

        @Override
        public void onUnityBannerHide(String placementId) {
            DeviceLog.debug("[UnityMonetization Demo] onUnityBannerHide for placement: " + placementId);
            UnityMonetizationJNI.bannerShown = false;
        }

        @Override
        public void onUnityBannerError(String placementId) {
            DeviceLog.debug("[UnityMonetization Demo] onUnityBannerError for placement: " + placementId);

        }
    }

}

