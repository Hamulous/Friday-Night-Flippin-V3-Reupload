package;

import flixel.FlxState;
import states.TitleState;
import backend.Highscore;
import states.VideoPlayerState;

class Init extends FlxState
{
	public override function new()
	{
		super();
	}

	public override function create()
	{
		super.create();

        FlxG.mouse.visible = false;

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		FlxG.keys.preventDefaultKeys = [TAB];

		FlxG.worldBounds.set(0,0);

		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;

		FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;

        FlxG.save.bind('funkin', CoolUtil.getSavePath());
		ClientPrefs.loadPrefs();
		Highscore.load();
		ClientPrefs.loadDefaultKeys();

		Paths.excludeAsset('assets/shared/images/Glass_Boom.png');
		CoolUtil.precacheImage('Glass_Boom', 'shared');

		FlxG.switchState(Type.createInstance(VideoPlayerState, ['klaskiiTitle', 'titlestate', 1, false]));
	}
}