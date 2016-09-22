package bogen.component;

// Timer. Dispatch a callback when finished
class Timer extends Component
{

// Remaining time
private var remaining: Float;

// Called on finish
public var onFinish: Void->Void;

// Constructor
public function new(remaining: Float, onFinish: Void->Void)
{
	this.remaining = remaining;
	this.onFinish = onFinish;
}

// Update
override public function onUpdate(timeStep: TimeStep) 
{
	remaining -= timeStep.elapsed;
	if (remaining <= 0 && onFinish != null)
	{
		remaining = 0;
		onFinish();
		onFinish = null;
	}
}

}
