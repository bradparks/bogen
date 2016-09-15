package bogen.render;

import bogen.input.Input;
import bogen.simulation.BaseSimulation;
import bogen.simulation.Simulation;
import bogen.types.Rect;
import bogen.types.Vec;
import kha.FastFloat;

class Button extends BaseSimulation
{
	
// Drawing frames
private var normal: Frame;
private var pressed: Frame;

// Is the button being held?
public var holding(default, null): Bool;

// Position
private var position: Vec;

// Box
private var box: Rect;

// Pressed event
public var onPress: Void->Void;

// Touch or mouse buttons pressed over the box
private var pressedOver: Array<Bool>;

// Constructor
public function new
(
	x: FastFloat, y: FastFloat,
	normal: Frame, pressed: Frame,
	onPress: Void->Void, border = .0
)
{
	this.normal = normal;
	this.pressed = pressed;
	
	pressedOver = [];
	holding = false;
	
	position = new Vec(x, y);
	box = new Rect
	(
		x + border, y + border,
		normal.width - 2 * border, normal.height - 2 * border
	);	
	
	this.onPress = onPress;
}

// Input
@SuppressWarnings("checkstyle:CyclomaticComplexity")
override public function onInput(input: Input)
{
	var x = input.pointerPosition.x;
	var y = input.pointerPosition.y;
	
	// If it's dragging stop everything
	if (input.isDragging)
	{
		pressedOver = [];
		holding = false;
	}
	
	// If just pressed
	else if (input.pointerJustPressed())
	{
		if (box.collidePoint(x, y))
		{
			pressedOver[input.pointerIndex] = holding = true;
			input.stopPropagation = true;
		}
	}
	
	// If just released
	else if (input.pointerJustReleased())
	{
		pressedOver[input.pointerIndex] = false;
		
		if (box.collidePoint(x, y))
		{
			var wasHolding = holding;
			checkPressed();
			
			if (wasHolding && !holding && onPress != null) onPress();
			input.stopPropagation = true;
		}
		else holding = false;
	}
	
	// If moving
	else if (input.pointerMoving())
	{
		var collide = box.collidePoint(x, y);
		
		#if sys_android
		if (!collide)
		{
			pressedOver[input.pointerIndex] = false;
			checkPressed();
		}
		#else
		if (collide) checkPressed();
		else holding = false;
		#end
	}
}

// Draw
override public function onDraw(canvas: Canvas, _)
	canvas.draw(holding? pressed: normal, position.x, position.y);

// Check if the user is holding over the button
private function checkPressed()
{
	for (press in pressedOver)
	{
		if (press)
		{
			holding = true;
			return;
		}
	}
	
	holding = false;
}

// Debug sprite
public function addDebugSprite(simulation: Simulation)
	box.addDebugSprite(simulation);

// Representation
public inline function toString()
	return 'Button(${ box.x }, ${ box.y }, ${ box.width }, ${ box.height })';

}
