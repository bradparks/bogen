package bogen.input;

import bogen.math.Vec;
import bogen.render.Camera;
import bogen.utils.Maybe;
import kha.Key;

@:allow(bogen.input.InputManager)
class Input
{

// Should the input stop propagating?
public var stopPropagation: Bool;

// Is the input being dragged?
public var isDragging: Bool;

// Pointer state
public var pointerState(default, null): PointerState;
public var pointerPosition(default, null): Vec;
public var pointerIndex(default, null): Int;

// Keyboard input
public var keyType: Maybe<Key>;
public var keyCode: Maybe<String>;

// Constructor
public function new()
{
	pointerPosition = new Vec(0, 0);
	reset();
}

// Reset
private function reset()
{
	stopPropagation = false;
	isDragging = false;
	
	pointerState = PointerState.NONE;
	pointerIndex = -1;
	
	keyType = Maybe.none();
	keyCode = Maybe.none();
}

// Reset to pointer state
private function resetWithScreenPointer
	(x: Float, y: Float, pointerState: PointerState, pointerIndex: Int = -1)
{
	var cameraPosition = Camera.main.transform.position;
	var cameraScale = Camera.main.transform.cameraScale;
	
	pointerPosition.set
	(
		x / cameraScale + cameraPosition.x,
		y / cameraScale + cameraPosition.y
	);
	
	reset();
	
	this.pointerState = pointerState;
	this.pointerIndex = pointerIndex;
}

// Check if a button has just been pressed
public inline function pointerJustPressed()
	return pointerState == PointerState.JUST_PRESSED;

// Check if a button has just been released
public inline function pointerJustReleased()
	return pointerState == PointerState.JUST_RELEASED;

// Check if the pointer is moving
public inline function pointerMoving()
	return pointerState == PointerState.MOVING;

// Check if a key has just been pressed
public inline function anyKey() return keyType.orNull() != null;

// Representation
public inline function toString()
{
	return
		if (anyKey())
			'Input(key(${ keyType.orNull() }, "${ keyCode.orNull() }"))';
		else 'Input((${ pointerPosition.x }, ${ pointerPosition.y })'
			+ ', $pointerState, $pointerIndex';
}

}
