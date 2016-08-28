package bogen.render;

import bogen.simulation.BaseSimulation;
import bogen.types.Vec;
import bogen.simulation.TimeStep;
import kha.FastFloat;

class Sprite extends BaseSimulation
{

// Frame to draw
public var frame: Frame;

// Position and speed
public var position: Vec;
public var speed: Vec;

// Vertical and horizontal scale
public var scale: Vec;

// Constructor
public function new(frame: Frame, positionX: FastFloat, positionY: FastFloat)
{
	this.frame = frame;
	position = new Vec(positionX, positionY);
	speed = Vec.empty();
	scale = new Vec(1, 1);
}

// Update
override public function onUpdate(timeStep: TimeStep)
{
	super.onUpdate(timeStep);
	position.addInPlaceScaled(speed, timeStep.elapsed);
}

// Draw
override public function onDraw(canvas: Canvas, timeStep: TimeStep)
{
	canvas.drawResized
	(
		frame,
		position.x, position.y,
		frame.width * scale.x, frame.height * scale.y
	);
	
	canvas.drawDebugRectangle
		(position.x, position.y, frame.width, frame.height);
	
	super.onDraw(canvas, timeStep);
}

}
