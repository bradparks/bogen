package bogen.utils;

import bogen.l10n.Language;

#if sys_android
import com.ktxsoftware.kha.KhaActivity;
#end

// Information about the device

#if sys_android @:keep #end
class Device
{

// Current activity
#if sys_android
public static inline function activity() return KhaActivity.the();
#end

// Device's language
public static inline function language(): Language
{
	#if sys_android
		var language = java.util.Locale.getDefault().getLanguage();
	#elseif sys_flash
		var language = flash.system.Capabilities.language;
	#elseif sys_html5
		var language: String =
			untyped window.navigator.userLanguage || window.navigator.language;
		language = language.split("-")[0];
	#else
		var language = "en";
	#end
	
	if (language == "pt") return Language.PT;
	return Language.EN;
}

// Device's pixel independent conversion
public static function dipToPixels(dip: Int): Float
{
	#if sys_android
		return untyped __java__
		("
			android.util.TypedValue.applyDimension
			(
				android.util.TypedValue.COMPLEX_UNIT_DIP,
				dip,
				activity().getResources().getDisplayMetrics()
			)
		");
	#else
		return dip;
	#end
}

}
