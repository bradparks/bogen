package bogen.types;

import bogen.render.DebugSprite;
import bogen.simulation.BaseSimulation;
import bogen.simulation.Simulation;
import kha.FastFloat;

class Collider
{

// Box
public var box: Rect;

// Called when colliding. Should return true if the collision was processed
public var onCollide: Void->Bool;

// Collider will trigger when its health reach zero
public var health: Int;

// Cria
public function new(x: FastFloat, y: FastFloat, w: FastFloat, h: FastFloat)
{
	box = new Rect(x, y, w, h);
	onCollide = null;
	
	health = 1;
}

// Check vertical collision
public inline function collideY(otherY: FastFloat, otherH: FastFloat)
{
	return box.y <= otherY + otherH && box.y + box.height >= otherY;
}

// Debug sprite
public function addDebugSprite(simulation: Simulation)
{
	#if (debug && bogen_debug_rect)
	simulation.add(DebugSprite.fromRect(box));
	#end
}

// Retonra uma colisão quadrada no ponto central e tamanho informado
public static inline function centerSquared
	(centeX: FastFloat, centerY: FastFloat, size: FastFloat)
		return new Collider(centeX - size / 2, centerY - size / 2, size, size);

// Create a callback to remove the collider on collision
public inline function callbackRemove
	(simulation: Simulation, child: BaseSimulation)
{
	onCollide = function()
	{
		health--;
		if (health == 0)
		{
			simulation.remove(child);
			return true;
		}
		return false;
	};
}

// Representation
public inline function toString()
{
	return 'Collider(${ box.x }, ${ box.y }, ${ box.width }, ${ box.height })';
}

}
