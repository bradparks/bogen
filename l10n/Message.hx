package bogen.l10n;

// Message in different languages
class Message 
{

// Language used by all messages
public static var language: Language;

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
public function toString()
{
	return switch (language) 
	{
		case Language.PT: pt
		default: en
	}
}

}
