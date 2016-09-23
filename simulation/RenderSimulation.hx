package bogen.simulation;

import bogen.component.Component;
import bogen.render.Camera;

// Updates only on onDraw. Useful for objects that are purely visual
@:generic class RenderSimulation<T: Component> extends TypedSimulation<T>
{

// Does nothing, will update on onDraw
override public function onUpdate(timeStep: TimeStep): Void
{
	// Empty
}

// Draw and updates
override public function onDraw(camera: Camera, timeStep: TimeStep): Void
{
	for (child in children)
	{
		child.onUpdate(timeStep);
		child.onDraw(camera, timeStep);
	}
}

}
