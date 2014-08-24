package game;

import flixel.effects.FlxSpriteFilter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.input.keyboard.FlxKeyList;
import flixel.*;
import flixel.util.FlxPoint;
import openfl.filters.GlowFilter;

//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
class Player extends FlxSprite
{
	public var possesed = false;
	public var possestion = false;
	public var filter:FlxSpriteFilter;
	#if !js
	public var glow:GlowFilter;
	#end
	public var SPEED:Float = 800;
	public function new(xx:Float, yy:Float) 
	{
		super(xx, yy);
		this.loadGraphic("assets/images/player.png");
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		maxVelocity.x = 100;
		maxVelocity.y = 100;
		//acceleration.y = 400;
		drag.x = maxVelocity.x * 8;
		drag.y = maxVelocity.y * 8;
		
	}
	
	
	override public function update():Void
	{
		if (possesed)
		{
			maxVelocity.x = 100;
			maxVelocity.y = 100;
			drag.x = maxVelocity.x * 8;
		drag.y = maxVelocity.y * 8;
			width = 6;
			height = 14;
			centerOffsets(false);
		} else {
			maxVelocity.x = 200;
			maxVelocity.y = 200;
			drag.x = maxVelocity.x * 8;
			drag.y = maxVelocity.y * 8;
			width = 18;
			height = 26;
			centerOffsets(false);
		}
		if (x > FlxG.worldBounds.width)
			x = FlxG.worldBounds.width;
		if (x < FlxG.worldBounds.x)
			x = FlxG.worldBounds.x;
		if (y > FlxG.worldBounds.height)
			y = FlxG.worldBounds.height;
		if (y < FlxG.worldBounds.y)
			y = FlxG.worldBounds.y;
		
		acceleration = new FlxPoint(0, 0);
		if (FlxG.keys.pressed.A)
		{
			facing = FlxObject.LEFT;
			acceleration.x = -SPEED;
		}
		if (FlxG.keys.pressed.D)
		{
			facing = FlxObject.RIGHT;
			acceleration.x = SPEED;
		}
		if (FlxG.keys.pressed.W)
		{
			acceleration.y = -SPEED;
		}
		if (FlxG.keys.pressed.S)
		{
			acceleration.y = SPEED;
		}
		if (possesed && !possestion)
		{
			this.loadGraphic("assets/images/Pguy.png");
			#if !js
			filter = new FlxSpriteFilter(this, 4, 4);
			glow = new GlowFilter(0xFF93FF93, 0.5, 6, 6, 2);
			filter.addFilter(glow);
			width = 6;
			height = 14;
			centerOffsets(true);
			#end
			possestion = true;
		}
		
		super.update();
	}
	
	override public function reset(XX:Float, YY:Float):Void
	{
		this.loadGraphic("assets/images/player.png");
		#if !js
		filter = new FlxSpriteFilter(this, 4, 4);
		glow = new GlowFilter(0xFF93FF93, 0.5, 6, 6, 4);
		filter.addFilter(glow);
		#end
		super.reset(XX, YY);
	}
	
}