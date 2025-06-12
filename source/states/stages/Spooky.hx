package states.stages;

import cutscenes.DialogueBoxPsych;
import states.charactermenus.CharMenuStory;

#if !flash
import openfl.filters.ShaderFilter;
import shaders.BloomShader;
#end

class Spooky extends BaseStage
{
	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;

	var dialogueSong:String;
	var dialoguePrefix:String = '';

	var bloom:BloomShader;

	override function create()
	{
		halloweenBG = new BGSprite('House', -450, -150, ['halloweem bg0', 'halloweem bg lightning strike']); //Sorry low end pcs
		add(halloweenBG);
	
		//PRECACHE SOUNDS
		precacheSound('thunder_1');
		precacheSound('thunder_2');

		switch (CharMenuStory.bfmode)
		{
			case 'sen-beta':
				dialoguePrefix = '-beta';
			case 'sen-alpha':
				dialoguePrefix = '-alpha';
			default:
				dialoguePrefix = '';
		}

		switch (songName.toLowerCase())
		{
			default:
				dialogueSong = 'week2';
		}

		if(isStoryMode && !seenCutscene)
		{
			setStartCallback(dialogueStart);
		}

		bloom = new BloomShader();
		camGame.setFilters([new ShaderFilter(bloom)]);
	}
	override function createPost()
	{
		halloweenWhite = new BGSprite(null, -800, -400, 0, 0);
		halloweenWhite.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.WHITE);
		halloweenWhite.alpha = 0;
		halloweenWhite.blend = ADD;
		add(halloweenWhite);
	}

	override function update(elapsed:Float)
	{
		if (bloom != null) {
			bloom.data.intensity.value = [bloom.shaderintensity];
			bloom.data.blurSize.value = [bloom.shaderblurSize];
		} 
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	override function beatHit()
	{
		if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if(!ClientPrefs.data.lowQuality) halloweenBG.animation.play('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if(boyfriend.animOffsets.exists('scared')) {
			boyfriend.playAnim('scared', true);
		}

		if(dad.animOffsets.exists('scared')) {
			dad.playAnim('scared', true);
		}

		if(gf != null && gf.animOffsets.exists('scared')) {
			gf.playAnim('scared', true);
		}

		if(ClientPrefs.data.camZooms) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;

			if(!game.camZooming) { //Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
				FlxTween.tween(camHUD, {zoom: 1}, 0.5);
			}
		}

		if(ClientPrefs.data.flashing) {
			halloweenWhite.alpha = 0.4;
			FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
			FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
		}
	}

	function dialogueStart()
	{
		if(Paths.fileExists('data/' + songName + '/dialogue' + dialoguePrefix + '.json', TEXT)) {
			game.startDialogue(DialogueBoxPsych.parseDialogue(Paths.json(songName + '/dialogue' + dialoguePrefix)), dialogueSong);
			return;
		} else {
			trace('Dialogue is null or not properly formatted');
			startCountdown();
			return;
		}
	}
}