package bogen.motion;

import bogen.component.Component;
import bogen.simulation.TimeStep;
import bogen.transform.Transform;

// Rotates a transform
class AngularVelocity extends Component
{
	
// Transform to rotate
public var transform: Transform;

// Angular velocity
public var velocity: Float;

// Constructor
public function new(transform: Transform, velocity: Float)
{
	this.transform = transform;
	this.velocity = velocity;
}

// Update. Applies the angular velocity
override public function onUpdate(timeStep: TimeStep)
	transform.angle += velocity * timeStep.elapsed;

}
