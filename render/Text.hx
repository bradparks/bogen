package bogen.render;

import bogen.component.Component;
import bogen.math.Size;
import bogen.transform.PivotType;
import bogen.transform.Transform;
import kha.Font;

// Draw a multiline text string
class Text extends Component
{

// Text's height
private var textHeight: Float;
	
// Text to draw
public var text: Array<Array<String>>;

// Font
public var font: Font;
public var fontSize: Int;

// Transform
public var transform: Transform;

// Spacing
public var leading: Float;
public var spaceAfter: Float;

// Constructor
public function new
(
	text: Array<Array<String>>, font: Font, fontSize: Int,
	leading: Float, spaceAfter: Float,
	transform: Transform
)
{
	this.text = text;
	
	this.font = font;
	this.fontSize = fontSize;
	
	this.transform = transform;
	
	textHeight = font.height(fontSize);
	
	this.leading = leading;
	this.spaceAfter = spaceAfter;
}

// Draw
override public function onDraw(camera: Camera, _)
{
	camera.setupDraw(transform);
	
	var graphic = camera.graphic;
	
	graphic.font = font;
	graphic.fontSize = fontSize;
	
	var x = transform.left();
	var y = transform.top();
	
	for (paragraph in text)
	{
		for (line in paragraph)
		{
			graphic.drawString(line, x, y);
			y += textHeight + leading;
		}
		
		y += spaceAfter - leading;
	}
	
	transform.drawDebug(camera);
	
	camera.cleanupDraw(transform);
}

// Copy
public function copy()
	return
		new Text(text, font, fontSize, leading, spaceAfter, transform.copy());

// Splits a string into an Array<Array<String>> at \n and \n\n
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

// Get the text size
public static function getSize
(
	text: Array<Array<String>>,
	font: Font, fontSize: Int, leading: Float, spaceAfter: Float
)
{
	var result = new Size(0, (text.length - 1) * spaceAfter);
	var textHeight = font.height(fontSize);
	
	for (paragraph in text)
	{
		result.height +=
			paragraph.length * textHeight
			+ (paragraph.length - 1) * leading;
		for (line in paragraph)
		{
			var size = font.width(fontSize, line);
			if (size > result.width) result.width = size;
		}
	}
	
	return result;
}

// Create a new text as child of a transform
@SuppressWarnings("checkstyle:ParameterNumber")
public static function create
(
	string: String, font: Font, fontSize: Int, x: Float, y: Float,
	?parentTransform: Transform,
	leading: Float = 0, spaceAfter: Float = 0,
	parentPivotX = PivotType.START, parentPivotY = PivotType.START,
	pivotX = PivotType.START, pivotY = PivotType.START
)
{
	if (parentTransform == null) parentTransform = Camera.main.transform;
	
	var text = splitString(string);
	var size = getSize(text, font, fontSize, leading, spaceAfter);
	
	var transform = parentTransform.child
	(
		x, y, size.width, size.height,
		parentPivotX, parentPivotY, 0,
		pivotX, pivotY
	);
	
	return new Text(text, font, fontSize, leading, spaceAfter, transform);
}

}
