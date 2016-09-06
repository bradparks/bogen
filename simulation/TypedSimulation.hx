package bogen.simulation;

import bogen.input.Input;
import bogen.render.Canvas;

/* Typed simulation with children.
 * Propagates onUpdate and onDraw handles. onInput should be propagated
 * explicitly by calling trickleDownInput or trickleDownHandled. */
@:generic
class TypedSimulation<T: BaseSimulation> extends BaseSimulation
{

// Children
public var children: Array<T>;

// Constructor
public function new() children = [];

// Add a child
public inline function add(child: T)
	if (child != null) children.push(child);

// Removes a child
public inline function remove(child: T) children.remove(child);

// Remove all children
public inline function removeAll() children = [];

// Apply input to all children.
public inline function trickleDownInput(input: Input)
	for (child in children) child.onInput(input);
	
/* Apply input to all children until one handles it.
 * Starts from the back because those are drawn at the front. */
public function trickleDownHandled(input: Input)
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
{
	if (timeStep.elapsed < 0) return;
	for (child in children) child.onUpdate(timeStep);
}

// Draw all children
override public function onDraw(canvas: Canvas, timeStep: TimeStep): Void
	for (child in children) child.onDraw(canvas, timeStep);

}
