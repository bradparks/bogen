package bogen.simulation;

import bogen.render.Canvas;

// Updates only on onDraw. Useful for objects that are purely visual
@:generic
class RenderSimulation<T: BaseSimulation> extends TypedSimulation<T>
{

// Does nothing, will update on onDraw
override public function onUpdate(timeStep: TimeStep): Void
{
	//EMPTY
}

// Draw and updates
override public function onDraw(canvas: Canvas, timeStep: TimeStep): Void
{
	for (child in children)
	{
		child.onUpdate(timeStep);
		child.onDraw(canvas, timeStep);
	}
}

}
