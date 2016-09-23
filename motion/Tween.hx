package bogen.motion;

class Tween
{

// Linear
public static function linear(t: Float) return t;

// Quad
public static function quadIn(t: Float) return t * t;
public static function quadOut(t: Float) return - t * (t - 2);

// Cubic
public static function cubicIn(t: Float) return t * t * t;
public static function cubicOut(t: Float) return (t = t - 1) * t * t + 1;

// Bounce
public static function bounceIn(t: Float)
{
	if (t < (1 / 2.75)) return (7.5625 * t * t);
	if (t < (2 / 2.75)) return (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75);
	if (t < (2.5 / 2.75)) return (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375);
	return (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375);
}

// Back
public static function backIn(overshoot: Float, t: Float)
{
	if (t == 0) return 0.0;
	if (t == 1) return 1.0;
	
	return t * t * ((overshoot + 1) * t - overshoot);
}

}
