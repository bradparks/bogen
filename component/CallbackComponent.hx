package bogen.component;

import bogen.input.Input;
import bogen.render.Camera;
import bogen.simulation.TimeStep;

// Component with callback handles
class CallbackComponent extends Component
{

// Functions to replace default behaviour
public var onUpdateFunction: TimeStep->Void;
public var onInputFunction: Input->Void;
public var onDrawFunction: Camera->TimeStep->Void;

// Constructor
public function new
(
	onUpadteFunction: TimeStep->Void,
	onInputFunction: Input->Void,
	onDrawFunction: Camera->TimeStep->Void
)
{
	this.onUpdateFunction = onUpadteFunction;
	this.onInputFunction = onInputFunction;
	this.onDrawFunction = onDrawFunction;
}

// Call supplied functions
override public function onUpdate(timeStep: TimeStep)
	if (onUpdateFunction != null) onUpdateFunction(timeStep);

override public function onInput(input: Input) 
	if (onInputFunction != null) onInputFunction(input);

override public function onDraw(camera: Camera, timeStep: TimeStep)
	if (onDrawFunction != null) onDrawFunction(camera, timeStep);

}
