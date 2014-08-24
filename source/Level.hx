
package;

import flixel.text.FlxText;
import game.Guy;
import game.MovingSpike;
import game.Player;
import openfl.Assets;
import haxe.io.Path;
import haxe.xml.Parser;
import flixel.*;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;
import openfl.filters.GlowFilter;
import flixel.effects.FlxSpriteFilter;

//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!

class Level extends TiledMap
{

	public var BGMaps:FlxGroup;
	public var collisionMap:FlxTilemap;
	public var spikes:FlxTilemap;
	public var spikesObjs:FlxGroup;
	public var safeTiles:FlxTilemap;
	public var guys:FlxGroup;
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		
		BGMaps = new FlxGroup();
		spikesObjs = new FlxGroup();
		collisionMap = new FlxTilemap();
		spikes = new FlxTilemap();
		safeTiles = new FlxTilemap();
		guys = new FlxGroup();
		//trace(fullWidth);
		
		//FlxG.worldBounds.set(0, 0, fullWidth, fullHeight);
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		// Load Tile Maps
		for (tileLayer in layers)
		{	
			//trace(tileLayer.csvData);
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = tileLayer.width;
			tilemap.heightInTiles = tileLayer.height;
			tilemap.loadMap(tileLayer.tileArray, "assets/images/tiles.png", 8, 8, 0, 1, 1, 1);
			if (tileLayer.name == "collide")
			{
				collisionMap = tilemap;
			} else if (tileLayer.name == "spikes") {
				spikes = tilemap;
			} else if (tileLayer.name == "safe") {
				safeTiles = tilemap;
			} else {
				BGMaps.add(tilemap);
			}
		}
	}
	
	
	public function loadObjects(state:PlayState)
	{
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				loadObject(o, group, state);
			}
		}
	}
	
	private function loadObject(o:TiledObject, g:TiledObjectGroup, state:PlayState)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		//trace(x + " " + y);
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
		
		switch (o.type.toLowerCase())
		{
			case "spawn":
				var player = new Player(x, y);
				FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
				state.player = player;
				state.add(player);
			
			case "light":
				var light = new FlxSprite(x, y, "assets/images/light.png");
				#if !js
				var filter = new FlxSpriteFilter(light, 32, 32);
				var glow = new GlowFilter(0xFF0065F9, 0.5, 30, 6, 4);
				filter.addFilter(glow);
				#end
				state.backLayer.add(light);
			case "guy":
				var guy = new Guy(x, y);
				guy.maxVelocity.x = 160;
				guy.maxVelocity.y = 400;
				guy.acceleration.y = 400;
				guy.drag.x = guy.maxVelocity.x * 4;
				guys.add(guy);
				state.add(guy);
			case "text":
				var text:FlxText = new FlxText(x, y, o.width, o.name);
				text.borderColor = 0x000000;
				text.borderSize = 2;
				text.borderStyle = FlxText.BORDER_SHADOW;
				state.backLayer.add(text);
			case "movingspike":
				var spike:MovingSpike = new MovingSpike(x, y, o.width, o.height);
				spikesObjs.add(spike);
				
/*			case "floor":
				var floor = new FlxObject(x, y, o.width, o.height);
				state.floor = floor;
				
			case "coin":
				var tileset = g.map.getGidOwner(o.gid);
				var coin = new FlxSprite(x, y, c_PATH_LEVEL_TILESHEETS + tileset.imageSource);
				state.coins.add(coin);
				
			case "exit":
				// Create the level exit
				var exit = new FlxSprite(x, y);
				exit.makeGraphic(32, 32, 0xff3f3f3f);
				exit.exists = false;
				state.exit = exit;
				state.add(exit);*/
		}
	}
	
	public function collideWithLevel(obj, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
				return FlxG.overlap(collisionMap, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);
	}
}