package bogen.math;

import kha.FastFloat;

// Random number generator
class Random
{

// Max integer
private static inline var MAX_INT = 0x7fffffff;
	
// Seed
private var seed: FastFloat;

// Constructor
public inline function new(?seed: Int)
{	
	if (seed == null) this.seed = Std.int(1 + Math.random() * (MAX_INT - 2));
	else this.seed = seed;
}

// Returns a random positive integer
public inline function int(): Int
{
	var result = Std.int((seed * 48271) % MAX_INT);
	seed = result;
	return result;
}

// Returns a float number betewen [0, 1[
public inline function float(): FastFloat
{
	return int() / MAX_INT;
}

// Returns an integer between [min, max]
public inline function intRange(min: Int, max: Int): Int
{
	return Math.floor(min + float() * (max - min + 1));
}

// Returns a float number between [min, max]
public inline function floatRange(min: FastFloat, max: FastFloat): FastFloat
{
	return min + float() * (max - min);
}

// Returns "true" given the chance
public inline function bool(chance: FastFloat = .5): Bool
{
	return float() < chance;
}

// Return "1" given the chance
public inline function sign(chance: FastFloat = .5): Int
{
	return bool(chance)? 1: -1;
}

// Returns the index of a random probability
public function probability(list: Array<FastFloat>): Int
{
	var chance: FastFloat = 0;
	for (item in list) chance += item;
	
	var result = floatRange(0, chance);
	chance = 0;
	
	for (i in 0...list.length)
	{
		chance += list[i];
		if (result < chance) return i;
	}
	return list.length - 1;
}

// Returns a random element
public function choose<T>(array: Array<T>)
{
	return array[intRange(0, array.length - 1)];
}

}
