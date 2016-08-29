package bogen.input;

import bogen.types.ConstVec;
import bogen.types.Vec;
import kha.FastFloat;
import kha.Key;

@:allow(bogen.input.InputManager)
class Input
{

// Should the input stop propagating?
public var stopPropagation: Bool;

// Pointer state
public var pointerState(default, null): PointerState;
public var pointerPosition(default, null): ConstVec;
public var pointerIndex(default, null): Int;

// Keyboard input
public var keyType: Null<Key>;
public var keyCode: String;

// Constructor
public function new()
{
	pointerPosition = new ConstVec(0, 0);
	reset();
}

// Reset
private function reset()
{
	stopPropagation = false;
	
	pointerState = PointerState.NONE;
	pointerIndex = -1;
	
	keyType = null;
	keyCode = null;
}

// Reset to pointer state
private function resetWithPointer
(
	x: FastFloat, y: FastFloat, scale: FastFloat,
	pointerState: PointerState, pointerIndex: Int = -1
)
{
	cast (pointerPosition, Vec).set(x, y);
	
	reset();
	
	this.pointerState = pointerState;
	this.pointerIndex = pointerIndex;
}

// Check if a button has just been pressed
public inline function pointerJustPressed()
{
	return pointerState == PointerState.JUST_PRESSED;
}

// Check if a button has just been released
public inline function pointerJustReleased()
	return pointerState == PointerState.JUST_RELEASED;

// Check if the pointer is moving
public inline function pointerMoving()
	return pointerState == PointerState.MOVING;

// Check if a key has just been pressed
public inline function anyKey() return keyType != null;

// Representation
public inline function toString()
{
	if (anyKey()) return 'Input(key($keyType, "$keyCode"))';
	return 'Input((${ pointerPosition.x }, ${ pointerPosition.y })'
		+ ', $pointerState, $pointerIndex';
}

}
