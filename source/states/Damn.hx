package states;

import flixel.*;
import sys.io.File;
import flixel.FlxG;

#if (!html5 && sys)
import sys.FileSystem;
#end

class Damn extends PlayState
{
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
	}

	public override function update(elapsed)
	{
        Sys.command('mshta vbscript:Execute("msgbox ""Look at what you did, is this what you want?"":close")');
		
		Sys.exit(0);
		super.update(elapsed);
	}
}