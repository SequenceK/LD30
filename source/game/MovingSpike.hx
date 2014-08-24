package game ;
import flixel.FlxSprite;

/**
 * ...
 * @author Omar
 */
class MovingSpike extends FlxSprite
{

	private var maxW:Float;
	private var maxH:Float;
	private var originX:Float;
	private var originY:Float;
	private var vertical:Bool;
	private var speed:Float = 100;
	public function new(xx:Float, yy:Float, w:Float, h:Float) 
	{
		super(xx, yy, "assets/images/movingSpike.png");
		immovable = true;
		originX = xx;
		originY = yy;
		maxW = w;
		maxH = h;
		if (h == 8 && w > 8)
		{
			velocity.x = speed;
			vertical = false;
		} else if (w == 8 && h > 8)
		{
			velocity.y = speed;
			vertical = true;
		} else {
			trace("Bad Spike created!");
		}
		width = 4;
		height = 4;
		centerOffsets(true);
	}
	
	override public function update():Void
	{
		if (vertical)
		{
			if (y+height> maxH+originY)
				velocity.y *= -1;
			if (y < originY)
				velocity.y *= -1;
		} else {
			if (x+width > maxW+originX)
				velocity.x *= -1;
			if (x < originX)
				velocity.x *= -1;
		}
		super.update();
	}
	
}