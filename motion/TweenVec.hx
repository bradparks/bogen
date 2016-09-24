package bogen.motion;

import bogen.component.Component;
import bogen.math.Vec;
import bogen.simulation.Simulation;
import bogen.simulation.TimeStep;

class TweenVec extends Component
{

// Vector to animate
public var vec: Vec;

// Initial and final vectors
private var initial: Vec;
private var final: Vec;

// Difference betweem final and inital
private var difference: Vec;

// Total animation time
private var animationTime: Float;

// When zero, starts animating. When > animationTime, finishes.
private var time: Float;

// Parent simulation, if provided will remove itself when finished
private var parent: Simulation;

// Called when the tween finishes
private var onFinish: Void->Void;

// Easing function
public var easing: Easing;

// Constructor
public function new
(
	vec: Vec, finalX: Float, finalY: Float, easing: Easing,
	animationTime: Float, delay: Float = 0,
	?parent: Simulation, ?onFinish: Void->Void
)
{
	this.vec = vec;

	initial = Vec.from(vec);
	final = new Vec(finalX, finalY);
	difference = final.sub(initial);
	
	this.easing = easing;
	this.animationTime = animationTime;
	this.parent = parent;
	this.onFinish = onFinish;
	
	time = -delay;
	
	#if (debug && bogen_no_animation)
		time = animationTime;
	#end
}

// Update
override public function onUpdate(timeStep: TimeStep)
{
	time += timeStep.elapsed;
	if (time < 0) return;
	else if (time > animationTime)
	{
		if (parent != null || onFinish != null)
		{
			vec.set(final.x, final.y);
			if (parent != null)
			{
				parent.remove(this);
				parent = null;
			}
			else
			{
				onFinish();
				onFinish = null;
			}
		}
		
		return;
	}
	
	var ease = easing(time / animationTime);
	
	vec.x = initial.x + (difference.x * ease);
	vec.y = initial.y + (difference.y * ease);
}

}
