package bogen.render;
import bogen.input.Input;
import bogen.types.Vec;
import kha.Color;
import kha.FastFloat;
import kha.Font;

class ButtonText extends Button
{
	
// Text to draw over the button
public var text: String;

// Font
public var font: Font;
public var fontSize: Int;

// Position to draw the text
public var normalPosition: Vec;
public var pressedPosition: Vec;

// Text color
public var normalColor: Color;
public var pressedColor: Color;

// O botão está abilitado?
private var enabled: Bool;
	
// Constructor
@SuppressWarnings("checkstyle:ParameterNumber")
public function new
(
	x: FastFloat, y: FastFloat, enabled: Bool,
	normal: Frame, pressed: Frame,
	text: String, font: Font, fontSize: Int,
	normalOffset: Vec, pressedOffset: Vec,
	normalColor: Color, pressedColor: Color,
	onPress: Void->Void,	
	border = .0
)
{
	super(x, y, enabled? normal: pressed, pressed, onPress, border);
	
	this.enabled = enabled;
	
	this.text = text;
	this.font = font;
	this.fontSize = fontSize;
	
	normalPosition = new Vec
	(
		x + normalOffset.x + (normal.width - font.width(fontSize, text)) / 2,
		y + normalOffset.y + (normal.height - font.height(fontSize)) / 2
	);
	pressedPosition = normalPosition.add(pressedOffset);
	
	this.normalColor = normalColor;
	this.pressedColor = pressedColor;
	
	if (!enabled)
	{
		normalPosition = pressedPosition;
		normalColor = pressedColor;
		normal = pressed;
	}
}

// Controle
override public function onInput(input:Input)
	if (enabled) super.onInput(input);

// Draw
override public function onDraw(canvas: Canvas, _)
{
	super.onDraw(canvas, _);
	
	var color;
	var position;
	
	if (holding)
	{
		color = pressedColor;
		position = pressedPosition;
	}
	else
	{
		color = normalColor;
		position = normalPosition;
	}
	
	var graphic = canvas.graphic;
	
	graphic.font = font;
	var oldColor = graphic.color;
	
	graphic.fontSize = fontSize;
	graphic.color = color;
	
	graphic.drawString(text, position.x, position.y);
	
	graphic.color = oldColor;
}

}
