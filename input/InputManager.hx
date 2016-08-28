package bogen.input;

import bogen.render.Canvas;
import bogen.simulation.Game;
import kha.Color;
import kha.FastFloat;
import kha.Key;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.Surface;

class InputManager
{
	
// Input to be handled
private static var input: Input;

// Canvas scale. Used to correct pointer's position
private static var scale: FastFloat;

// Is the back button being held?
@:require(sys_android)
private static var isBackButtonPressed: Bool;

// Initialize
@:allow(bogen.simulation.Game)
private static function init(scale: FastFloat)
{
	InputManager.scale = scale;
	
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
	input.resetWithPointer(x, y, scale, PointerState.JUST_PRESSED, index);
	Game.scene.onInput(input);
}

// Called by kha on mouse or touch up
private static function upListener(index: Int, x: Int, y: Int)
{
	input.resetWithPointer(x, y, scale, PointerState.JUST_RELEASED, index);
	Game.scene.onInput(input);
}

#if sys_android

// Called by kha on touch drag
private static function touchDragListener(index: Int, x: Int, y: Int)
{
	input.resetWithPointer(x, y, scale, PointerState.MOVING, index);
	Game.scene.onInput(input);
}

#else

// Called by kha on mouse move
private static function mouseMoveListener(x: Int, y: Int, _, _)
{
	input.resetWithPointer(x, y, scale, PointerState.MOVING);
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
	
	input.keyType = key;
	input.keyCode = code;
	
	Game.scene.onInput(input);
}

#if sys_android
// Called by Kha when a key is released
private static function onKeyReleased(key: Key, code: String)
	if (key == Key.BACK) isBackButtonPressed = false;
#end

// Draw the pointer on screen
public static inline function drawPointer(canvas: Canvas)
{
	#if (debug && bogen_pointer_position)
	var oldColor = canvas.graphic.color;
	canvas.graphic.color = Color.Red;
	canvas.graphic.drawRect
	(
		input.pointerPosition.x, input.pointerPosition.y,
		5, 5, 1 / canvas.scale
	);
	canvas.graphic.color = oldColor;
	#end
}

}
