package modchart.modifiers;
import flixel.FlxSprite;
import ui.*;
import modchart.*;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.FlxG;
import math.*;
import objects.Note;

class BounceModifier extends NoteModifier {
    override function getName()return 'bounce';

    override function getPos(time:Float, visualDiff:Float, timeDiff:Float, beat:Float, pos:Vector3, data:Int, player:Int, obj:FlxSprite)
    {
        if(getValue(player) == 0)return pos;
        
        var offset = getSubmodValue("bounceOffset", player) * 100;
        var bounce:Float = Math.abs(FlxMath.fastSin( ( (visualDiff + (1 * (offset) ) ) / ( 60 + (getSubmodValue("bouncePeriod",player)*60) ) ) ) );

        pos.x += getValue(player) * Note.swagWidth * 0.5 * bounce;

        return pos;
    }

  override function getSubmods(){
    return ["bouncePeriod", "bounceOffset"];
  }

}