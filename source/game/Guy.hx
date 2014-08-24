package game;

import flixel.*;

//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
class Guy extends FlxSprite
{
	public var safe:Bool = false;
	public var originX:Float;
	public var originY:Float;

	public function new(xx:Float, yy:Float) 
	{
		super(xx, yy);
		originX = x;
		originY = y;
		loadGraphic("assets/images/guy1.png");
	}
	
}