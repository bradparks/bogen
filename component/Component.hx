package bogen.component;

import bogen.input.Input;
import bogen.render.Camera;
import bogen.simulation.TimeStep;

// Component with basic handles
class Component
{
	
// Called when the component should handle input
public function onInput(input: Input)
{
	// Empty
}

// Called when the component should update
public function onUpdate(timeStep: TimeStep): Void
{
	// Empty
}

// Called when the component should draw
public function onDraw(camera: Camera, timeStep: TimeStep): Void
{
	// Empty
}

}
