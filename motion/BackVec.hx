package bogen.motion;

import bogen.simulation.Simulation;
import bogen.types.Vec;
import kha.FastFloat;

class BackVec extends MotionVec
{

public var overshoot: FastFloat;

// Constructor
public function new
(
	point: Vec,
	initialX: FastFloat, initialY: FastFloat,
	finalX: FastFloat, finalY: FastFloat,
	animationTime: FastFloat, delay: FastFloat,
	parent: Simulation
)
{
	super
	(
		point,
		initialX, initialY, finalX, finalY,
		animationTime, delay, parent
	);
	
	overshoot = 1.70158;
}

// Tween function
override public function tween(t: FastFloat)
{
	if (t == 0) return 0.0;
	if (t == 1) return 1.0;
	
	return t * t * ((overshoot + 1) * t - overshoot);
}

}
