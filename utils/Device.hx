package bogen.utils;
import bogen.l10n.Language;

// Information about the device
class Device
{

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

}
