package bogen.render;

import bogen.simulation.Game;
import kha.Image;

// Frame on a spritesheet
class Frame
{
	
// Image to draw from
public var sheet: Image;

// Position and size on the sheet
public var x: Int;
public var y: Int;
public var width: Int;
public var height: Int;

// Constructor
public inline function new
	(sheet: Image, x: Int, y: Int, width: Int, height: Int)
{
	this.sheet = sheet;
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
}

// Positions related to the screen
public inline function screenLeft() return 0;
public inline function screenRight() return Game.canvas.canvasWidth - width;
public inline function screenTop() return 0;
public inline function screenBottom()
	return Game.canvas.canvasHeight - Game.canvas.bannerHeight - height;
public inline function screenHCenter()
	return (Game.canvas.canvasWidth - width) / 2;
public inline function screenVCenter()
	return (Game.canvas.canvasHeight - Game.canvas.bannerHeight - height) / 2;
	
// Positions related to the canvas
public inline function canvasLeft() return Game.canvas.centerOffset.x;
public inline function canvasTop() return Game.canvas.centerOffset.y;

}
