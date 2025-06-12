package backend;

import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import states.Fishing;

using StringTools;

class Fish extends FlxSprite
{
    var lastX:Float = 0;
    var canMove:Bool = true;
    var pnts:Int = 0;
    public var isCaught:Bool = false;
	public function new(x:Float, y:Float, ?type:String = 'default', ?those:Array<Int>, ?fps:Int = 10, ?looped:Bool = false)
        {
            super(x, y);
            this.animation.add("idle", those, fps, looped);
            this.animation.play('idle');
            if (type == 'default')
                pnts = 1;
            else if (type == 'clown')
                pnts = 5;
            else if (type == 'fat')
                pnts = -10;
        }

        override function update(elapsed:Float)
        {
            if (lastX != x)
                {
                    //this.animation.add("idle", those, fps, looped);
                    lastX = x;
                }
            if (FlxG.random.int(0,500) == 1 && canMove)
                {
                    canMove = false;
                    var xgen = FlxG.random.int(0,1100);
                    if (xgen < lastX)
                    this.flipX = true;
                    else if (xgen > lastX)
                    this.flipX = false;

                    FlxTween.tween(this, {x: xgen, y:FlxG.random.int(506,600)}, FlxG.random.int(1,5), {ease: FlxEase.quintOut,
                        onComplete: function(twn:FlxTween)
                        {
                            canMove = true;
                        }
                    });
                }

            if (overlaps(Fishing.pod))
                {
                    Fishing.score += pnts;
                    
                    if (!isCaught)
                        isCaught = true;

                    if(!ClientPrefs.data.fishCaught)
                    {
                        ClientPrefs.data.fishCaught = true;
                        ClientPrefs.saveSettings();
                        GameJoltAPI.getTrophy(166970, '#FEF200', 'You got a fish!', 'Catch a fish in the fish game');
                    }
                }
        }
}