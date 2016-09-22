package bogen.input;

// Pointer state in a input
@:enum abstract PointerState(Int)
{
	public var NONE = 0;
	public var JUST_PRESSED = 1;
	public var JUST_RELEASED = 2;
	public var MOVING = 3;
}
