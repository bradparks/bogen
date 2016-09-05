package bogen.l10n;

// Message in different languages
class Message 
{

// Language used by all messages
@:isVar public static var language(get, set): Language;
public static function get_language()
{
	#if (debug && bogen_force_pt)
		return Language.PT;
	#else
		return language;
	#end
}
public static function set_language(value: Language) return language = value;

// Messages. English is default
private var en: String;
private var pt: String;

// Constructor
public function new(en: String, pt: String)
{
	this.en = en;
	this.pt = pt;
}

// Return the string for a message
public function toText()
{
	#if (debug && bogen_force_pt)
		return pt;
	#else
		return language == Language.PT? pt: en;
	#end
}

}
