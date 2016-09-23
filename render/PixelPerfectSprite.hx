package bogen.render;

import bogen.transform.Transform;
import kha.graphics2.ImageScaleQuality;

class PixelPerfectSprite extends Sprite
{

// Draw
override public function onDraw(camera: Camera, _)
{
	camera.graphic.imageScaleQuality = ImageScaleQuality.Low;
	camera.draw(frame, transform);
	camera.graphic.imageScaleQuality = ImageScaleQuality.High;
}

}
