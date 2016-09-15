package bogen.simulation;
import bogen.input.Input;
import bogen.motion.MotionVec;
import bogen.motion.QuadOutVec;
import bogen.render.Canvas;
import bogen.types.Vec;
import kha.FastFloat;
import kha.Scheduler;

/* Drag a simulations horizontally across the screen.
 * It's a huge hack. Please don't try to understand it. */
class DragSimulation extends Simulation
{
	
// Distance to wait before start dragging
private static inline var DISTANCE_BEFORE_DRAGGING = 10;

// Offset array used to draw
private var offset: Vec;

// Tween to move back
private var moveBackAnimation: MotionVec;

// Translation vector
public var translation: Vec;

// Touch or mouse buttons dragging the simulation
public var draggers: Array
<{
	startTime: FastFloat,
	startPos: FastFloat,
	currentPos: FastFloat
}>;

// Child being displayed
public var currentChild(default, null): Int;

// Constructor
public function new(dx: FastFloat, dy: FastFloat)
{
	super();

	currentChild = 0;
	offset = new Vec(dx, dy);
	
	translation = new Vec(0, 0);
	draggers = [];
	moveBackAnimation = null;
}

// Input
@SuppressWarnings("checkstyle:MethodLength", "checkstyle:CyclomaticComplexity")
override public function onInput(input: Input)
{
	// Save the click
	if (input.pointerJustPressed())
	{
		var pos = input.pointerPosition.x + currentChild * offset.x;
		draggers[input.pointerIndex] =
		{
			startTime: Scheduler.time(),
			startPos: pos,
			currentPos: pos
		}
	}
		
	else if (input.pointerJustReleased())
	{
		var dragger = draggers[input.pointerIndex];
		draggers[input.pointerIndex] = null;
		
		/* If the translation says it's dragging, but the input says it's not,
		 * stop it. */
		if (isDragging() && !isDraggingInput())
		{
			// Position in percentage
			var pos = -translation.x / offset.x;
			
			// Smallest offset required to change a screen
			var minOffset = .15;
			
			// Offset dragged
			var draggedOffset = pos % 1.0;
			
			if (pos > currentChild)
			{
				/* If going forward and dragging more than the smallest
				 * offset, go to next children */
				if (draggedOffset > minOffset) pos = Std.int(pos) + 1;
			}
			else
			{
				// If going backwards and dragging more than the offset...
				if (draggedOffset < (1 - minOffset)) pos = Std.int(pos);
			}
			
			// Current child is the position in percentage
			currentChild = Math.round(pos);
			
			// Bounds check for sanity
			if (currentChild < 0) currentChild = 0;
			else if (currentChild > children.length - 1)
				currentChild = children.length - 1;
			
			// If not animating already
			if (moveBackAnimation == null)
			{	
				// Final position in pixels
				var finalPos = -currentChild * offset.x;
				
				// Time based on the speed dragged. Could be better implemented
				var time = 
					if (dragger == null) .001 * Math.abs(translation.x);
					else
					{
						var speed = (dragger.currentPos - dragger.startPos)
							/ (Scheduler.time() - dragger.startTime);
						
						1.25 * Math.abs((finalPos - translation.x) / speed);
					}
					
				// Don't wanna make it too quick
				if (time < .25) time = .25;
				
				// Crete the animation
				moveBackAnimation = new QuadOutVec
				(
					translation,
					translation.x, translation.y,
					finalPos, translation.y,
					time, 0, this
				);
			}
		}
	}
	
	// Move screen
	else if (input.pointerMoving())
	{
		var dragger:{ startPos: FastFloat, currentPos: FastFloat } = null;
		
		#if sys_android
			dragger = draggers[input.pointerIndex];
			if (dragger != null) dragger.currentPos = input.pointerPosition.x;
		#else
			for (i in 0...draggers.length)
			{
				var iterDragger = draggers[i];
				if (iterDragger == null) continue;
				
				iterDragger.currentPos = input.pointerPosition.x;
				
				if
				(
					dragger == null
					&& Math.abs(iterDragger.startPos - iterDragger.currentPos)
						> DISTANCE_BEFORE_DRAGGING
				) dragger = iterDragger;
			}
		#end
		
		if (dragger != null)
		{
			translation.x = dragger.currentPos - dragger.startPos;
			
			if (translation.x > 0) translation.x = 0;
			else if (translation.x < -(children.length - 1) * offset.x)
				translation.x = -(children.length - 1) * offset.x;
			
			if (moveBackAnimation != null)
			{
				remove(moveBackAnimation);
				moveBackAnimation = null;
			}
		}
	}
	
	// Process input by children
	var child = children[currentChild];
	if (child != null)
	{
		input.isDragging = isDragging();
		child.onInput(input);
		input.isDragging = false;
	}
}

// Check if it's dragging based on the translation vector
public inline function isDragging()
	return Math.abs(translation.x % offset.x) > .001;

// Check if it's dragging based on input state
private function isDraggingInput()
{
	for (dragger in draggers)
	{
		if
		(
			dragger != null
			&& Math.abs(dragger.startPos - dragger.currentPos)
				> DISTANCE_BEFORE_DRAGGING
		) return true;
	}
	
	return false;
}

// Draw
override public function onDraw(canvas: Canvas, timeStep: TimeStep)
{
	// Current position in percentage
	var index = -translation.x / offset.x;
	
	// Previous and next screen
	var previousIndex = Math.floor(index);
	var nextIndex = Math.ceil(index);
	
	// Bounds check
	if (previousIndex < 0) previousIndex = 0;
	
	// Get the children
	var previous = children[previousIndex];
	var next = children[nextIndex];
	
	// Translate for the "previous" child
	canvas.graphic.translate
		(((previousIndex * offset.x) + translation.x) * canvas.scale, 0);
	
	// Draw'em
	if (previous != null) previous.onDraw(canvas, timeStep);
	if (next != null && previousIndex != nextIndex)
	{
		canvas.graphic.translate(offset.x * canvas.scale, 0);
		next.onDraw(canvas, timeStep);
	}
}

}
