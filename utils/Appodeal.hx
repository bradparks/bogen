package bogen.utils;

#if (sys_android && !bogen_no_ads)

import kha.Scheduler;

// Show ads with Appodeal
class Appodeal
{

// Banner height
public static var bannerHeight(default, null): Float;

// Interstitial time
private static var isterstitialInterval: Float;
private static var lastInterstitialTime: Float;

// Initialize. This function cannot be inlined
public static function init(appKey: String, interstitialTime: Int)
{
	var activity = Device.activity();
	
	Appodeal.isterstitialInterval = interstitialTime;
	lastInterstitialTime = Scheduler.realTime();
	
	untyped __java__
	("
		com.appodeal.ads.Appodeal.setAutoCacheNativeIcons(false);
		com.appodeal.ads.Appodeal.setAutoCacheNativeMedia(false);
		
		com.appodeal.ads.Appodeal.setAutoCache
		(
			com.appodeal.ads.Appodeal.SKIPPABLE_VIDEO
			| com.appodeal.ads.Appodeal.REWARDED_VIDEO
			| com.appodeal.ads.Appodeal.NON_SKIPPABLE_VIDEO
			| com.appodeal.ads.Appodeal.NATIVE,
			false
		);
		
		com.appodeal.ads.Appodeal.disableLocationPermissionCheck();
		com.appodeal.ads.Appodeal.disableWriteExternalStoragePermissionCheck();
		com.appodeal.ads.Appodeal.setLogging(false);
		
		com.appodeal.ads.Appodeal.initialize
		(
			activity, appKey,
			com.appodeal.ads.Appodeal.INTERSTITIAL
			| com.appodeal.ads.Appodeal.BANNER
		);
	");
}

// Show a banner at the top
public static inline function showBanner()
{
	var activity = Device.activity();
	
	untyped __java__
	("
		com.appodeal.ads.Appodeal.show
			(activity, com.appodeal.ads.Appodeal.BANNER_BOTTOM);
	");
}

// Show an interstitial ad
public static inline function showInterstitial()
{
	var elapsed = Scheduler.realTime() - lastInterstitialTime;
	if (elapsed < isterstitialInterval) return;
	
	lastInterstitialTime = Scheduler.realTime();

	var activity = Device.activity();
	
	untyped __java__
	("
		com.appodeal.ads.Appodeal.show
			(activity, com.appodeal.ads.Appodeal.INTERSTITIAL);
	");
}

}

#else

class Appodeal
{

public static inline function init(appKey: String, interstitialTime: Int)
	{ /*EMPTY*/ }
public static inline function showBanner()
	{ /*EMPTY*/ }
public static inline function showInterstitial()
	{ /*EMPTY*/ }
}

#end
