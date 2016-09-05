package bogen.render;

import bogen.motion.BounceVec;
import bogen.simulation.BaseSimulation;
import bogen.simulation.Game;
import bogen.simulation.RenderSimulation;
import bogen.types.Vec;
import kha.FastFloat;

class BounceSequence extends RenderSimulation<BaseSimulation>
{

// Position
private var position: Vec;
	
// Frames
public function new
(
	frames: Array<Frame>,
	x: Null<FastFloat>, y: FastFloat, startY: FastFloat,
	animationTime: FastFloat, startDelay: FastFloat, accDelay: FastFloat
)
{
	super();
	
	if (x == null)
	{
		var width = 0;
		for (frame in frames) width += frame.width;
		x = Game.canvas.hCenter(0, width);
	}
	
	position = new Vec(x, y);
	
	for (i in 0...frames.length)
	{
		var frame = frames[i];
		
		var sprite = new Sprite(frame, x, startY);
		add(sprite);
		
		BounceVec.simple
		(
			sprite.position,
			x, y,
			animationTime, startDelay + accDelay * i, this
		);
		
		x += frame.width;
	}
}

}
