package bogen.input;

import bogen.render.Camera;
import bogen.transform.PivotType;
import bogen.transform.ScaleType;
import bogen.transform.Transform;
import bogen.utils.Maybe;
import kha.Key;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.Surface;

class InputManager
{
	
// Input to be handled
private static var input: Input;

// Is the back button being held?
@:require(sys_android)
private static var isBackButtonPressed: Bool;

// Initialize
@:allow(bogen.Game)
private static function init(transform: Transform)
{
	input = new Input();
	
	#if sys_android
		isBackButtonPressed = false;
		Surface.get().notify(downListener, upListener, touchDragListener);
	#else
		Mouse.get().notify(downListener, upListener, mouseMoveListener, null);
	#end
	
	Keyboard.get().notify
	(
		onKeyPressed,
		#if sys_android
			onKeyReleased
		#else
			null
		#end
	);
}

// Called by kha on mouse or touch down
private static function downListener(index: Int, x: Int, y: Int)
{
	input.resetWithScreenPointer(x, y, PointerState.JUST_PRESSED, index);
	Game.scene.onInput(input);
}

// Called by kha on mouse or touch up
private static function upListener(index: Int, x: Int, y: Int)
{
	input.resetWithScreenPointer(x, y, PointerState.JUST_RELEASED, index);
	Game.scene.onInput(input);
}

#if sys_android

// Called by kha on touch drag
private static function touchDragListener(index: Int, x: Int, y: Int)
{
	input.resetWithScreenPointer(x, y, PointerState.MOVING, index);
	Game.scene.onInput(input);
}

#else

// Called by kha on mouse move
private static function mouseMoveListener(x: Int, y: Int, _, _)
{
	input.resetWithScreenPointer(x, y, PointerState.MOVING);
	Game.scene.onInput(input);
}

#end

// Called by kha when a key is pressed
private static function onKeyPressed(key: Key, code: String)
{
	#if sys_android
		if (key == Key.BACK)
		{
			if (isBackButtonPressed) return;
			isBackButtonPressed = true;
		}
	#end

	input.reset();
	
	input.keyType = Maybe.some(key);
	input.keyCode = Maybe.some(code);
	
	Game.scene.onInput(input);
}

#if sys_android
// Called by Kha when a key is released
private static function onKeyReleased(key: Key, code: String)
	if (key == Key.BACK) isBackButtonPressed = false;
#end

// Draw the pointer on screen
public static inline function drawPointer(camera: Camera)
{
	#if (debug && bogen_pointer_position)
	var size = 7;
	
	var pointerTransform = camera.transform.child
	(
		input.pointerPosition.x - camera.transform.position.x,
		input.pointerPosition.y - camera.transform.position.y,
		size, size, PivotType.START, PivotType.START,
		0, PivotType.CENTER, PivotType.CENTER,
		ScaleType.NORMAL, ScaleType.NORMAL, 0xffff0000
	);
	camera.drawFill(pointerTransform);
	#end
}

}
