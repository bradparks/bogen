package bogen.render;

import bogen.simulation.BaseSimulation;
import bogen.types.Rect;
import kha.Color;
import kha.graphics2.ImageScaleQuality;

// FIMXE: Refactor calculations
class Slice9 extends BaseSimulation
{

// Background color
public var backgroundColor: Color;

// Frames on the top
public var tl: Frame;
public var t: Frame;
public var tr: Frame;

// Frames on the middle
public var l: Frame;
public var r: Frame;
	
// Frames on the bottom
public var bl: Frame;
public var b: Frame;
public var br: Frame;

// Rectangles
public var rect: Rect;
public var rectFill: Rect;

// Constructor
public function new
(
	backgroundColor: Color,
	tl: Frame, t: Frame, tr: Frame,
	l: Frame, r: Frame,
	bl: Frame, b: Frame, br: Frame,
	rect: Rect
)
{
	this.backgroundColor = backgroundColor;
	
	this.tl = tl;
	this.t = t;
	this.tr = tr;
	
	this.l = l;
	this.r = r;
	
	this.bl = bl;
	this.b = b;
	this.br = br;
	
	this.rect = rect.copy();
	rectFill = new Rect
	(
		rect.x + l.width,
		rect.y + t.height,
		rect.width - l.width - r.width,
		rect.height - t.height - b.height
	);
}

// Draw
override public function onDraw(canvas: Canvas, _)
{
	// Background
	canvas.drawFill
	(
		rectFill.x, rectFill.y,
		rectFill.width, rectFill.height,
		backgroundColor
	);
	
	// Avoid blurriness at the image's edges
	canvas.graphic.imageScaleQuality = ImageScaleQuality.Low;
	
	// Top
	canvas.drawResized
	(
		t,
		rectFill.x, rect.y,
		rectFill.width, t.height
	);
	
	// Bottom
	canvas.drawResized
	(
		b,
		rectFill.x, rectFill.y + rectFill.height,
		rectFill.width, b.height
	);
	
	//// Left
	canvas.drawResized
	(
		l,
		rect.x, rectFill.y,
		l.width, rectFill.height
	);
	
	// Right
	canvas.drawResized
	(
		r,
		rectFill.x + rectFill.width, rectFill.y,
		r.width, rectFill.height
	);
	
	// Back to high quality
	canvas.graphic.imageScaleQuality = ImageScaleQuality.High;
	
	// Corners
	canvas.draw(tl, rect.x, rect.y);
	canvas.draw(tr, rectFill.x + rectFill.width, rect.y);
	canvas.draw(bl, rect.x, rectFill.y + rectFill.height);
	canvas.draw(br, rectFill.x + rectFill.width, rectFill.y + rectFill.height);
}

}
