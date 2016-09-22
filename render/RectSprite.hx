package bogen.render;

import bogen.component.Component;
import bogen.transform.Transform;

class RectSprite extends Component
{

// Transform
public var transform: Transform;

// Stroke size
public var strokeSize: Float;

// Constructor
public function new(transform: Transform, strokeSize: Float)
{
	this.transform = transform;
	this.strokeSize = strokeSize;
}

// Draw
override public function onDraw(camera: Camera, _)
	camera.drawRect(transform, strokeSize);

}
