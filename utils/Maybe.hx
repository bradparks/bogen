package bogen.utils;

import haxe.ds.Option;

@:notNull abstract Maybe<T>(Option<T>)
{
	
public static inline function none<T>(): Maybe<T> return cast Option.None;
public static inline function some<T>(value: Null<T>) return new Maybe(value);
public static inline function unsafeSome<T>(value: T)
	return cast Option.Some(value);
	
public inline function new(value: Null<T>)
	this = value == null? Option.None: Option.Some(value);

// Get the value or a default
public inline function or(value: T): T
{
	return switch (this)
	{
		case Option.Some(result): result;
		default: value;
	}
}

// Get the value or null
public inline function orNull(): Null<T>
{
	return switch (this)
	{
		case Option.Some(value): value;
		default: null;
	}
}

}
