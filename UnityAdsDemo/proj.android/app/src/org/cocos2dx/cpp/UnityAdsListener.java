package org.cocos2dx.cpp;

import com.unity3d.ads.UnityAds;
import com.unity3d.ads.IUnityAdsListener;
import com.unity3d.services.banners.IUnityBannerListener;
import android.util.Log;

import android.view.View;
import android.view.ViewGroup;
import static org.cocos2dx.cpp.UnityAdsJNI.activity;

public class UnityAdsListener implements IUnityAdsListener, IUnityBannerListener {

    static boolean BannerIsShown = false;
    static View bannerView;

    //IUnityAdsListener
    @Override
    public void onUnityAdsReady(final String placementId) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] onUnityAdsReady for placement: " + placementId);
    }

    @Override
    public void onUnityAdsStart(String placementId) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] onUnityAdsStart for placement: " + placementId);
    }

    @Override
    public void onUnityAdsFinish(String placementId, UnityAds.FinishState result) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] onUnityAdsFinish with FinishState: " + result.name() + " for placement: " + placementId);
        UnityAdsJNI.reward(placementId);
    }

    @Override
    public void onUnityAdsError(UnityAds.UnityAdsError error, String message) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] onUnityAdsError with message: " + message);
    }

    //IUnityBannerListener
    @Override
    public void onUnityBannerLoaded(String placementId, View view) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] onUnityBannerLoaded for placement: " + placementId);
        bannerView = view;
        activity.addContentView(bannerView,new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT));
//Or
//        ((ViewGroup)(UnityMonetizationJNI.activity.getWindow().getDecorView().getRootView())).addView(view);
    }

    @Override
    public void onUnityBannerUnloaded(String placementId) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] onUnityBannerUnloaded for placement: " + placementId);
        bannerView = null;
    }

    @Override
    public void onUnityBannerShow(String placementId) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] onUnityBannerShow for placement: " + placementId);
        BannerIsShown = true;
    }

    @Override
    public void onUnityBannerClick(String placementId) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] onUnityBannerClick for placement: " + placementId);
    }

    @Override
    public void onUnityBannerHide(String placementId) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] onUnityBannerHide for placement: " + placementId);
        BannerIsShown = false;
    }

    @Override
    public void onUnityBannerError(String placementId) {
        Log.d("Unity cocos2dx Sample","[UnityAds Demo] onUnityBannerError for placement: " + placementId);
    }
}
