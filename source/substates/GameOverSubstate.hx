package substates;

import backend.WeekData;

import objects.Character;
import flixel.FlxObject;
import flixel.FlxSubState;

import states.StoryMenuState;
import states.FreeplayState;
import states.charactermenus.CharMenuStory;
import states.Damn;

class GameOverSubstate extends MusicBeatSubstate
{
	public var boyfriend:Character;
	var camFollow:FlxObject;
	var moveCamera:Bool = false;
	var playingDeathSound:Bool = false;

	var stageSuffix:String = "";
	var thorns:FlxSprite;

	public static var characterName:String = 'bf-dead';
	public static var deathSoundName:String = 'fnf_loss_sfx';
	public static var loopSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';

	public static var instance:GameOverSubstate;

	override function create()
	{
		instance = this;
		super.create();
	}

	public function new(x:Float, y:Float, camX:Float, camY:Float, customGameOverField:Int = 0)
	{
		super();

		trace(CharMenuStory.bfmode);
		trace(customGameOverField);
		switch (customGameOverField)
		{
			case 3:
				characterName = 'sen-puppy';
				deathSoundName = 'fnf_loss_sfx';
				loopSoundName = 'gameOver';
				endSoundName = 'gameOverEnd';
			case 2:
				if (CharMenuStory.bfmode == 'sen' || CharMenuStory.bfmode == 'sen-wind')
				{
					characterName = 'senfuckingscythe';
					deathSoundName = 'fnf_loss_sfx';
					loopSoundName = 'gameOver';
					endSoundName = 'gameOverEnd';
				} else {
					characterName = CharMenuStory.bfmode;
					deathSoundName = 'fnf_loss_sfx';
					loopSoundName = 'gameOver';
					endSoundName = 'gameOverEnd';
				}
			case 1:
				if (CharMenuStory.bfmode == 'sen' || CharMenuStory.bfmode == 'sen-w3')
				{
					deathSoundName = 'senfuckingshot';
					loopSoundName = 'gameovershot';
					endSoundName = 'gameovershotending';
					characterName = 'senfuckingshot';
				} else {
					characterName = CharMenuStory.bfmode;
					deathSoundName = 'fnf_loss_sfx';
					loopSoundName = 'gameOver';
					endSoundName = 'gameOverEnd';
				}
			case 0:
				switch (CharMenuStory.bfmode)
				{
					case 'sen-wind' | 'sen' | 'sen-w3':
						characterName = 'sen';
					case 'beta-wind' | 'beta' | 'beta-w3':
						characterName = 'beta';
					case 'alpha-wind' | 'alpha' | 'alpha-w3':
						characterName = 'alpha';
					default:
						characterName = CharMenuStory.bfmode;
				}
				deathSoundName = 'fnf_loss_sfx';
				loopSoundName = 'gameOver';
				endSoundName = 'gameOverEnd';
		}
		trace(characterName);

		Conductor.songPosition = 0;
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('DEATH/normal'));
		bg.antialiasing = true;
		bg.scrollFactor.set();
		bg.screenCenter();
		bg.alpha = 0;
		thorns = new FlxSprite().loadGraphic(Paths.image('DEATH/thorns'));
		thorns.antialiasing = true;
		thorns.scale.set(1.2, 1.1);
		thorns.scrollFactor.set();
		thorns.screenCenter();
		thorns.alpha = 0;
		add(thorns);
		add(bg);

		boyfriend = new Character(x, y, characterName, true);
		boyfriend.x += boyfriend.positionArray[0];
		boyfriend.y += boyfriend.positionArray[1];
		add(boyfriend);

		FlxG.sound.play(Paths.sound(deathSoundName));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		boyfriend.playAnim('firstDeath');
		FlxG.camera.flash(FlxColor.WHITE, 0.8);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x + boyfriend.cameraPosition[0], boyfriend.getGraphicMidpoint().y + boyfriend.cameraPosition[1]);
		FlxG.camera.focusOn(new FlxPoint(FlxG.camera.scroll.x + (FlxG.camera.width / 2), FlxG.camera.scroll.y + (FlxG.camera.height / 2)));
		add(camFollow);
		FlxTween.tween(camFollow, {x: boyfriend.getGraphicMidpoint().x, y: boyfriend.getGraphicMidpoint().y}, 3, {ease: FlxEase.quintOut, onComplete: function(twn:FlxTween)
		{
			FlxTween.tween(bg, {alpha: 1}, 0.2, {ease: FlxEase.quintOut});
		}});
	}

	public var startedDeath:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.sound.music.time > 18988 && loopSoundName != 'gameovershot')
		{
			if (thorns.alpha != 0.18)
			thorns.alpha += 0.02;
		}
		else
		{
			if (thorns.alpha != 0)
			thorns.alpha -= 0.02;
		}

		if (FlxG.sound.music.time > 19288 * 3)
		{
			var black:FlxSprite = new FlxSprite().makeGraphic(1280 * 2, 1280 * 2, FlxColor.BLACK);
			black.scrollFactor.set();
			black.screenCenter();
			black.alpha = 0;
			add(black);
			FlxTween.tween(black,{alpha: 1},4 ,{ease: FlxEase.expoInOut});

			FlxG.sound.music.fadeOut(5.5,0);

			new FlxTimer().start(5, function(tmr:FlxTimer)
			{
				FlxG.switchState(new Damn());
			});
		}

		if (controls.ACCEPT)
		{
			endBullshit();
		}

		if (controls.BACK)
		{
			#if desktop DiscordClient.resetClientID(); #end
			FlxG.sound.music.stop();
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			PlayState.chartingMode = false;

			Mods.loadTopMod();
			if (PlayState.isStoryMode)
				MusicBeatState.switchState(new StoryMenuState());
			else
				MusicBeatState.switchState(new FreeplayState());

			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		
		if (boyfriend.animation.curAnim != null)
		{
			if (boyfriend.animation.curAnim.name == 'firstDeath' && boyfriend.animation.curAnim.finished && startedDeath)
				boyfriend.playAnim('deathLoop');

			if(boyfriend.animation.curAnim.name == 'firstDeath')
			{
				if(boyfriend.animation.curAnim.curFrame >= 12 && !moveCamera)
				{
					FlxG.camera.follow(camFollow, LOCKON, 0.01);
					moveCamera = true;
				}

				if (boyfriend.animation.curAnim.finished && !playingDeathSound)
				{
					startedDeath = true;
					if (PlayState.SONG.stage == 'tank')
					{
						playingDeathSound = true;
						coolStartDeath(0.2);
						
						var exclude:Array<Int> = [];
						//if(!ClientPrefs.cursing) exclude = [1, 3, 8, 13, 17, 21];

						FlxG.sound.play(Paths.sound('jeffGameover/jeffGameover-' + FlxG.random.int(1, 25, exclude)), 1, false, null, true, function() {
							if(!isEnding)
							{
								FlxG.sound.music.fadeIn(0.2, 1, 4);
							}
						});
					}
					else coolStartDeath();
				}
			}
		}
		
		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
	}

	var isEnding:Bool = false;

	function coolStartDeath(?volume:Float = 1):Void
	{
		FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
	}

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			boyfriend.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music(endSoundName));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					MusicBeatState.resetState();
				});
			});
		}
	}

	override function destroy()
	{
		instance = null;
		super.destroy();
	}
}
