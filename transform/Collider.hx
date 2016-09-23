package bogen.transform;

import bogen.render.RectSprite;
import bogen.simulation.Simulation;
import bogen.transform.Transform;

class Collider
{

// Transform
public var transform: Transform;

// Called when colliding. Should return true if the collision was processed
public var onCollide: Void->Bool;

// Collider will trigger when its health reach zero
public var health: Int;

// Cria
public function new
	(transform: Transform, ?onCollide: Void->Bool, health: Int = 1)
{
	this.transform = transform;
	this.onCollide = onCollide;
	this.health = health;
}

// Debug sprite
public function addDebugSprite(simulation: Simulation)
{
	#if (debug && bogen_debug_rect)
	simulation.add(new RectSprite(transform, 2));
	#end
}

}
