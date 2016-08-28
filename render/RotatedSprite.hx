package bogen.render;

import bogen.motion.Rotation;
import bogen.simulation.TimeStep;
import kha.FastFloat;

class RotatedSprite extends Sprite
{
	
// Rotation
public var rotation: Rotation;

// Constructor
public function new
	(frame: Frame, positionX: FastFloat, positionY: FastFloat)
{
	super(frame, positionX, positionY);
	rotation = new Rotation(frame.width / 2, frame.height / 2, 0, 0);
}

// Update
override public function onUpdate(timeStep: TimeStep)
{
	position.addInPlaceScaled(speed, timeStep.elapsed);
	rotation.applyAngularVelocity(timeStep.elapsed);
}

// Draw
override public function onDraw(canvas: Canvas, timeStep: TimeStep)
{
	canvas.drawRotatedAtPoint
	(
		frame,
		position.x, position.y,
		frame.width * scale.x, frame.height * scale.y,
		rotation.pivot.x * scale.x, rotation.pivot.y * scale.y,
		rotation.angle
	);
}

}
