package bogen.render;

import bogen.component.Component;
import bogen.input.Input;
import bogen.transform.Transform;

// Button
class Button extends Component
{
	
// Components to draw
private var normal: Array<Component>;
private var pressed: Array<Component>;

// Touch or mouse buttons pressed over the button
private var pressedOver: Array<Bool>;

// Colliders's transform
public var transform(default, null): Transform;

// Pressed event
public var onPress: Void->Void;

// Is the button being held?
public var holding(default, null): Bool;

// Is the button enabled?
public var enabled: Bool;

// Constructor
public function new
(
	transform: Transform,
	normal: Array<Component>, pressed: Array<Component>,
	onPress: Void->Void
)
{
	this.transform = transform;
	
	this.normal = normal;
	this.pressed = pressed;
	
	pressedOver = [];
	holding = false;
	
	this.onPress = onPress;
	enabled = true;
}

// Input
@SuppressWarnings("checkstyle:CyclomaticComplexity")
override public function onInput(input: Input)
{
	if (!enabled) return;
	
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
		if (transform.collidePoint(x, y))
		{
			pressedOver[input.pointerIndex] = holding = true;
			input.stopPropagation = true;
		}
	}
	
	// If just released
	else if (input.pointerJustReleased())
	{
		pressedOver[input.pointerIndex] = false;
		
		if (transform.collidePoint(x, y))
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
		var collide = transform.collidePoint(x, y);
		
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
override public function onDraw(camera: Camera, _)
{
	for (simulation in (holding || !enabled? pressed: normal))
		simulation.onDraw(camera, _);
	transform.drawDebug(camera);
}

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

// Representation
public inline function toString()
	return
		'Button(${ transform.left() }, ${ transform.top() }, '
		+ '${ transform.width() }, ${ transform.height() })';

}
