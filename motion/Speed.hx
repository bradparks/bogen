package bogen.motion;

import bogen.component.Component;
import bogen.math.Vec;
import bogen.simulation.TimeStep;
import bogen.transform.Transform;

// Linear moviment
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

// Update. Applies the angular velocity
override public function onUpdate(timeStep: TimeStep)
{
	transform.position.addScalarInPlace
	(
		speed.x * timeStep.elapsed,
		speed.y * timeStep.elapsed
	);
}

}
