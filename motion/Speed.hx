package bogen.motion;

import bogen.component.Component;
import bogen.math.Vec;
import bogen.simulation.TimeStep;
import bogen.transform.Transform;

// Linear movement
class Speed extends Component
{
	
// Transform to move
public var transform: Transform;

// Speed
public var speed: Vec;

// Constructor
public function new(transform: Transform, speed: Vec)
{
	this.transform = transform;
	this.speed = speed;
}

// Applies the speed
override public function onUpdate(timeStep: TimeStep)
{
	transform.position.addScalarInPlace
	(
		speed.x * timeStep.elapsed,
		speed.y * timeStep.elapsed
	);
}

}
