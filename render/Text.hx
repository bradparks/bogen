package bogen.render;

import bogen.simulation.BaseSimulation;
import bogen.types.Vec;
import bogen.simulation.TimeStep;
import kha.Color;
import kha.FastFloat;
import kha.Font;

class Text extends BaseSimulation
{

// Pre rendered fonts
@:require(debug)
private static var preRendered: Array<{ font: Font, size: Int }>;

// Text itself
public var text(default, null): String;
private var processedText: Array<Array<String>>;

// Font information
public var font: Font;
public var size: Int;
public var color: Color;

// Text position
public var position: Vec;

// Line height in pixels and percent
private var defaultLineHeight: FastFloat;
private var percentLineHeight: FastFloat;
private var paragraphHeight: FastFloat;

// Velocidade do sprite
public var speed: Vec;

// Box
public var box: Vec;

// Pre renders a font with the specified sizes
public static inline function initFont(font: Font, sizes: Array<Int>)
{
	#if debug
	preRendered = [];
	#end
	
	for (size in sizes)
	{
		#if debug
			preRendered.push({ font: font, size: size });
		#else
			font.width(size, "t");
		#end
	}
}

// Constructor
public function new
(
	text: String, font: Font, size: Int, color: Color,
	positionX: FastFloat, positionY: FastFloat
)
{
	#if debug
	var isPreRendered = false;
	
	for (pre in preRendered)
	{
		if (pre.font == font && pre.size == size)
		{
			isPreRendered = true;
			break;
		}
	}
	
	if (!isPreRendered)
	{
		trace('Warning: Font size $size not in pre-rendered fonts.');
		preRendered.push({ font: font, size: size });
	}
	#end
	
	this.text = text;
	processedText = splitString(text);
	
	this.font = font;
	this.size = size;
	this.color = color;
	
	position = new Vec(positionX, positionY);
	
	defaultLineHeight = font.height(size);
	percentLineHeight = 1.2;
	paragraphHeight = 1.8;
	
	box = boxSize();
}

// Text size
private function boxSize()
{
	var result = new Vec
	(
		0,
		(processedText.length - 1)
		* defaultLineHeight
		* (paragraphHeight - percentLineHeight)
	);
	
	for (paragraph in processedText)
	{
		result.y +=
			paragraph.length * defaultLineHeight * percentLineHeight;
		
		for (line in paragraph)
		{
			var size = font.width(size, line);
			if (size > result.x) result.x = size;
		}
	}
	
	return result;
}

// Draw
override public function onDraw(canvas: Canvas, timeStep: TimeStep)
{
	var g = canvas.graphic;
	
	g.fontSize = size;
	
	var oldColor = g.color;
	g.color = color;
	
	var y = position.y;
	
	for (paragraph in processedText)
	{
		for (line in paragraph)
		{
			g.drawString(line, position.x, y);
			y += defaultLineHeight * percentLineHeight;
		}
		
		y += defaultLineHeight * (paragraphHeight - percentLineHeight);
	}
	
	g.color = oldColor;
	
	canvas.drawDebugRectangle(position.x, position.y, box.x, box.y, 1);
}

// Centralized text
public static function central
(
	text: String, font: Font, size: Int, color: Color,
	centerX: FastFloat, centerY: FastFloat
)
{
	var result = new Text(text, font, size, color, 0, 0);
	
	result.position.x = centerX - result.box.x / 2;
	result.position.y = centerY - result.box.y / 2;
	
	return result;
}

// How many lines the text has
public function countLines()
{
	var lines = 0;
	for (paragraph in processedText) lines += paragraph.length;
	return lines;
}

// Splits a string at into an Array<Array<String>> at \n and \n\n
public static function splitString(s: String)
{
	var result = [];
	
	for (p in s.split("\n\n"))
	{
		var paragraph = [];
		for (l in p.split("\n")) paragraph.push(l);
		result.push(paragraph);
	}
	
	return result;
}

}
