package org.cocos2dx.cpp;

import com.unity3d.services.UnityServices;
import com.unity3d.services.monetization.IUnityMonetizationListener;
import com.unity3d.services.monetization.UnityMonetization;
import com.unity3d.services.monetization.placementcontent.core.PlacementContent;
import com.unity3d.services.core.log.DeviceLog;

public class UnityMonetizationListener implements IUnityMonetizationListener {
    @Override
    public void onPlacementContentReady(String placementId, PlacementContent placementContent) {

        DeviceLog.debug("[UnityMonetization Demo] onPlacementContentReady for placement: " + placementId);
    }

    @Override
    public void onPlacementContentStateChange(String placementId, PlacementContent placementContent, UnityMonetization.PlacementContentState placementContentState, UnityMonetization.PlacementContentState placementContentState1) {

        DeviceLog.debug("[UnityMonetization Demo] onPlacementContentStateChange for placement: " + placementId + " placementContentState: " + placementContentState.toString());
    }

    @Override
    public void onUnityServicesError(UnityServices.UnityServicesError unityServicesError, String s) {

        DeviceLog.debug("[UnityMonetization Demo] onUnityServicesError : " + unityServicesError.toString() + " Error Message: " + s);
    }
}
