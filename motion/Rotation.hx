package bogen.motion;

import bogen.types.Vec;
import kha.FastFloat;

// Object's rotation. Doesn't specify where to draw it.
class Rotation
{

// Frame's center of rotation
public var pivot: Vec;

// Angle
public var angle: FastFloat;

// Angular velocity
public var angularVelocity: FastFloat;

// Constructor
public function new
(
	pivotX: FastFloat, pivotY: FastFloat,
	angle: FastFloat,
	angularVelocity: FastFloat
)
{
	this.pivot = new Vec(pivotX, pivotY);
	this.angle = angle;
	this.angularVelocity = angularVelocity;
}

// Apply angular velocity
public inline function applyAngularVelocity(elapsed: FastFloat)
	angle += angularVelocity * elapsed;

}
