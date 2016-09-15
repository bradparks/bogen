package bogen.simulation;

import bogen.input.Input;
import bogen.render.Canvas;

/* Typed simulation with children */
@:generic
class TypedSimulation<T: BaseSimulation> extends BaseSimulation
{

// Children
public var children: Array<T>;

// Constructor
public function new() children = [];

// Add a child
public inline function add(child: T) children.push(child);

// Removes a child
public inline function remove(child: T)
{
	children = children.copy();
	children.remove(child);
}

// Remove all children
public inline function removeAll() children = [];
	
/* Apply input to all children until one handles it.
 * Starts from the back because those are drawn at the front. */
override public function onInput(input: Input)
{
	var i = children.length - 1;
	while (i >= 0)
	{
		children[i].onInput(input);
		if (input.stopPropagation) return;
		i--;
	}
}

// Update all children
override public function onUpdate(timeStep: TimeStep): Void
	for (child in children) child.onUpdate(timeStep);

// Draw all children
override public function onDraw(canvas: Canvas, timeStep: TimeStep): Void
	for (child in children) child.onDraw(canvas, timeStep);

}
