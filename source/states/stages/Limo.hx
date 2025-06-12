package states.stages;

import states.stages.objects.*;
import states.charactermenus.CharMenuStory;
import cutscenes.DialogueBoxPsych;
import cutscenes.CutsceneHandler;

#if !flash
import openfl.filters.ShaderFilter;
import shaders.BloomShader;
#end

class Limo extends BaseStage
{
	var fastCar:BGSprite;
	var fastCarCanDrive:Bool = true;

	// event
	var bgLimo:BGSprite;
	var eyes:BGSprite;

	var dialogueSong:String;
	var dialoguePrefix:String = '';

	var bloom:BloomShader;

	var editMode:Bool = false;
	var editableSprite:FlxSprite;
	var lpo:Int = 700;

	override function create()
	{
		var skyBG:BGSprite = new BGSprite('limo/Background_Normal', -320, -100, 0.1, 0.1);
		add(skyBG);

		if(!ClientPrefs.data.lowQuality) {
			if (songName == 'incendio') {
				var skyStars:BGSprite = new BGSprite('limo/Background_Stars', -320, -100, 0.1, 0.1);
				add(skyStars);
			}
            
			if (songName == 'tattered-robes' || songName == 'stars') {
				bgLimo = new BGSprite('limo/bglimo_with_hench', -330, 115, 0.4, 0.4, ['limo+henches']);
				bgLimo.animation.addByIndices('danceLeft', 'limo+henches', [0, 1, 2, 3, 4, 5, 6, 7, 9, 10 , 11, 12, 13, 14], "", 24, false);
				bgLimo.animation.addByIndices('danceRight', 'limo+henches', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,], "", 24, false);
				add(bgLimo);
			}
		}

		if (songName == 'incendio') {
			eyes = new BGSprite('limo/Eyes', 100, -105, 0.4, 0.4, ['eyes bg']);
			eyes.animation.addByPrefix('eyes bg', 'eyes bg', 24, false);
			eyes.setGraphicSize(Std.int(eyes.width * 1.6));
			add(eyes);
		}

		//PRECACHE SOUND
		precacheSound('dancerdeath');
		setDefaultGF('lem-wind');
		
		fastCar = new BGSprite('limo/fastCarLol', -300, 160);
		fastCar.active = true;

		switch (CharMenuStory.bfmode)
		{
			case 'sen-beta' | 'sen-beta-wind':
				dialoguePrefix = '-beta';
			case 'sen-alpha' | 'sen-alpha-wind':
				dialoguePrefix = '-alpha';
			default:
				dialoguePrefix = '';
		}

		switch (songName.toLowerCase())
		{
			default:
				dialogueSong = 'week4';
		}

		if(isStoryMode && !seenCutscene)
		{
			setStartCallback(dialogueStart);
		}

		bloom = new BloomShader();
		camGame.setFilters([new ShaderFilter(bloom)]);
	}

	override function update(elapsed:Float)
	{
		if (editMode)
			{
				if (FlxG.keys.pressed.SHIFT)
					{
						editableSprite.x = FlxG.mouse.screenX;
						editableSprite.y = FlxG.mouse.screenY;
					}
				else if (FlxG.keys.justPressed.C)
					{
						trace(editableSprite);
						trace(lpo);
					}
				else if (FlxG.keys.justPressed.E)
					{
						if (FlxG.keys.pressed.ALT)
							lpo += 100;
						else
							lpo += 15;
						editableSprite.setGraphicSize(Std.int(lpo));
						editableSprite.updateHitbox();
					}
				else if (FlxG.keys.justPressed.Q)
					{
						if (FlxG.keys.pressed.ALT)
							lpo -= 100;
						else
							lpo -= 15;
						editableSprite.setGraphicSize(Std.int(lpo));
						editableSprite.updateHitbox();
					}
				else if (FlxG.keys.justPressed.L)
					{
						if (FlxG.keys.pressed.ALT)
							editableSprite.x += 50;
						else
							editableSprite.x += 1;
					}
				else if (FlxG.keys.justPressed.K)
						{
							if (FlxG.keys.pressed.ALT)
								editableSprite.y += 50;
							else
								editableSprite.y += 1;
						}
				else if (FlxG.keys.justPressed.J)
					{
						if (FlxG.keys.pressed.ALT)
							editableSprite.x -= 50;
						else
							editableSprite.x -= 1;
					}
				else if (FlxG.keys.justPressed.I)
					{
						if (FlxG.keys.pressed.ALT)
							editableSprite.y -= 50;
						else
							editableSprite.y -= 1;
					}
			}

		if (bloom != null) {
			bloom.data.intensity.value = [bloom.shaderintensity];
			bloom.data.blurSize.value = [bloom.shaderblurSize];
		} 
	}
	
	override function createPost()
	{
		resetFastCar();
		addBehindGF(fastCar);//Shitty layering but whatev it works LOL
		
		var limo:BGSprite = new BGSprite('limo/limoDrive', -120, 550, 1, 1, ['Limo stage'], true);
		addBehindDad(limo); //mfw I read the code and there are more of these, who knew?
	}

	override function beatHit()
	{
		if(!ClientPrefs.data.lowQuality) {

			if (songName == 'incendio') {
				if (curBeat % 2 == 0) {
					eyes.dance(true);
				}
			}
             
			if (songName == 'tattered-robes' || songName == 'stars') {
				if (curBeat % 2 == 0) // cultist henchmen and limo stuffs
					{
						bgLimo.animation.play('danceLeft');
					} else {
						bgLimo.animation.play('danceRight');
				}
			}
		}


		if (FlxG.random.bool(10) && fastCarCanDrive)
			fastCarDrive();
	}
	
	// Substates for pausing/resuming tweens and timers
	override function closeSubState()
	{
		if(paused)
		{
			if(carTimer != null) carTimer.active = true;
		}
	}

	override function openSubState(SubState:flixel.FlxSubState)
	{
		if(paused)
		{
			if(carTimer != null) carTimer.active = false;
		}
	}

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	var carTimer:FlxTimer;
	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
			carTimer = null;
		});
	}

	function dialogueStart()
	{
		if (songName == 'incendio') {
			game.queueCutscene = true;
		}

		if(Paths.fileExists('data/' + songName + '/dialogue' + dialoguePrefix + '.json', TEXT)) {
			game.startDialogue(DialogueBoxPsych.parseDialogue(Paths.json(songName + '/dialogue' + dialoguePrefix)), dialogueSong);
			trace('data/' + songName + '/dialogue' + dialoguePrefix + '.json');
			return;
		} else {
			trace('Dialogue is null or not properly formatted');
			startCountdown();
			return;
		}
	}
}