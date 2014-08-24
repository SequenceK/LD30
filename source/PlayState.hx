package;

import flixel.*;
import flixel.addons.effects.FlxTrail;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.*;
import flixel.tile.*;
import flixel.ui.*;
import flixel.util.*;
import flixel.effects.particles.FlxEmitterExt;
import game.Guy;
import game.Player;

//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!
//BAD CODE DISCLAIMER!!!!!!!!!!!!!!!!!


class PlayState extends FlxState
{

	
	 public var player:Player;
	 public var level:Level;
	 public var backLayer:FlxGroup;
	 public var possesedObj:Guy;
	 public var justPossesed:Bool = false;
	 private var trail:FlxTrail;
	 private var safeCheck:Int = 0;
	 private var win:Bool = false;
	 private var guyCheckText:FlxText;
	 private var youWin:FlxText;
	 private var levelNo:Int = 1;
	
	public function new(?lvl:Int = 1)
	{
		super();
		levelNo = lvl;
	}
	 
	override public function create():Void
	{
		//FlxG.sound.playMusic("song", 0.3, true);
		FlxG.mouse.useSystemCursor = true;
		bgColor = 0xFF1E3328;
		level = new Level("assets/data/" + levelNo + ".tmx");
		backLayer = new FlxGroup();
		guyCheckText = new FlxText(1, 1, 0, "Guys saved: " + safeCheck);
		guyCheckText.borderColor = 0x000000;
		guyCheckText.borderSize = 1;
		guyCheckText.borderStyle = FlxText.BORDER_SHADOW;
		guyCheckText.scrollFactor.x = 0;
		guyCheckText.scrollFactor.y = 0;
		youWin = new FlxText(FlxG.width/2, FlxG.height/2, 0, "YOU WIN! Press SPACE!", 16);
		youWin.borderColor = 0x000000;
		youWin.borderSize = 4;
		youWin.borderStyle = FlxText.BORDER_SHADOW;
		youWin.scrollFactor.x = 0;
		youWin.scrollFactor.y = 0;
		youWin.x = FlxG.width / 2 - youWin.width / 2;
		youWin.y = FlxG.height / 2 - youWin.height / 2;

		
		add(level.BGMaps);
		add(level.collisionMap);
		add(level.spikes);
		add(level.safeTiles);
		add(backLayer);
		add(level.spikesObjs);
		level.loadObjects(this);
		trail = new FlxTrail(player, null, 20, 5, 0.2, 0.04);
		add(trail);
		add(guyCheckText);
		
		
		super.create();
	}
	override public function destroy():Void
	{
		super.destroy();
	}
	override public function update():Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			if (win && levelNo != 6)
					FlxG.switchState(new PlayState(levelNo + 1));
			else if (levelNo == 6)
				FlxG.switchState(new PlayState());
			else if (levelNo == 5)
				FlxG.switchState(new PlayState());
		}
		if (FlxG.keys.justPressed.H)
		{
			if (levelNo == 5)
			{
				FlxG.switchState(new PlayState(levelNo + 1));
			}
		}
		justPossesed = false;
		if (player.possesed)
		{
			level.collideWithLevel(player);
			FlxG.collide(level.spikes, player, playerSpiked);
			FlxG.collide(level.spikesObjs, player, playerSpiked);
			FlxG.collide(level.safeTiles, player);
		}
		level.collideWithLevel(level.guys);
		FlxG.overlap(player, level.guys, possestion);
		
		FlxG.collide(level.spikes, level.guys, guySpiked);
		FlxG.collide(level.spikesObjs, level.guys, guySpiked);
		FlxG.collide(level.safeTiles, level.guys, setSafe);
		if (FlxG.keys.justPressed.E)
		{
			if (player.possestion && !justPossesed)
			{
				possesedObj.revive();
				possesedObj.x = player.x;
				possesedObj.y = player.y;
				player.reset(possesedObj.x, possesedObj.y);
				player.possesed = false;
				player.possestion = false;
			} else if (!player.possesed && possesedObj != null)
			{
				if (!possesedObj.safe)
				{
					possesedObj.kill();
					//trace(possesedObj.exists);
					player.x = possesedObj.x;
					player.y = possesedObj.y;
					justPossesed  = true;
					player.possesed = true;
				}
			}
		}
		level.guys.forEachOfType(Guy, checkSafe);
		if (safeCheck >= level.guys.length && !win)
		{
			FlxG.camera.shake(0.05, 1);
			add(youWin);
			win = true;
		}
		guyCheckText.text = "Guys saved: " + safeCheck + "/" + level.guys.length;
		safeCheck = 0;
		super.update();
	}
	
	public function setSafe(s:FlxObject, g:Guy)
	{
		g.safe = true;
	}
	
	public function checkSafe(g:Guy)
	{
		if (g.safe)
		{
			safeCheck++;
		}	
	}
	
	public function playerSpiked(s:FlxObject, p:Player)
	{
		if (player.possestion)
		{
			possesedObj.revive();
			var emitter:FlxEmitterExt = new FlxEmitterExt(player.x, player.y, 20);
			emitter.makeParticles("assets/images/particle.png", 20, 4, false, 0, false);
			emitter.start(true, 0,0,0, 1);
			add(emitter);
			FlxG.sound.play("dead");
			player.reset(player.x, player.y);
			possesedObj.x = possesedObj.originX;
			possesedObj.y = possesedObj.originY;
			player.possesed = false;
			player.possestion = false;
		}
	}
	
	public function guySpiked(s:FlxObject, g:Guy)
	{
			var emitter:FlxEmitterExt = new FlxEmitterExt(g.x, g.y, 20);
			emitter.makeParticles("assets/images/particle.png", 20, 4, false, 0, false);
			emitter.start(true, 0,0,0, 1);
			add(emitter);
			FlxG.sound.play("dead");
			g.x = g.originX;
			g.y = g.originY;
	}
	
	public function possestion(p:Player, o:Guy):Void
	{
		if (FlxG.keys.justPressed.E)
		{
			if (p.possesed)
			{
				return;
			} else {
				possesedObj = o;
				o.kill();
				//trace(possesedObj.exists);
				p.x = possesedObj.x;
				p.y = possesedObj.y;
				justPossesed  = true;
				p.possesed = true;
			}
		}
	}
	
}