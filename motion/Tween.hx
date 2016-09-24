package bogen.motion;

import bogen.component.Component;
import bogen.simulation.Simulation;
import bogen.simulation.TimeStep;

class Tween extends Component
{

// Callback to change a value
public var onChange: Float->Void;

// Initial and final values
private var initialValue: Float;
private var finalValue: Float;

// Difference betweem final and inital
private var difference: Float;

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
	initialValue: Float, finalValue: Float,
	easing: Easing, onChange: Float->Void,
	animationTime: Float, delay: Float = 0,
	?parent: Simulation, ?onFinish: Void->Void
)
{
	this.initialValue = initialValue;
	this.finalValue = finalValue;
	this.easing = easing;
	this.onChange = onChange;
	this.animationTime = animationTime;
	this.parent = parent;
	this.onFinish = onFinish;
	
	time = -delay;
	difference = finalValue - initialValue;
	
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
			onChange(finalValue);
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
	onChange(initialValue + ease * difference);
}
	
}
