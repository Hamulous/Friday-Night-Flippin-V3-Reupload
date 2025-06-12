package states.stages;

import states.stages.objects.*;
import objects.Character;
import cutscenes.DialogueBoxPsych;
import states.charactermenus.CharMenuStory;

#if !flash
import openfl.filters.ShaderFilter;
import shaders.BloomShader;
#end

class Philly extends BaseStage
{
	var phillyWindow:BGSprite;
	var phillyStreet:BGSprite;
	var phillyTrain:PhillyTrain;
	var goonleft:BackGroundGoons;
	var goonright:BackGroundGoons;
	var goonBackleft:BackGroundGoons;
	var goonBackright:BackGroundGoons;
	var phillyWires:BGSprite;
	var dialogueSong:String;
	var dialoguePrefix:String = '';
	var bloom:BloomShader;

	override function create()
	{
		if(!ClientPrefs.data.lowQuality) {
			var bg:BGSprite = new BGSprite('philly/Town_Sky', -200, -300, 0.1, 0.1);
			add(bg);
		}

		var city:BGSprite = new BGSprite('philly/Town_Buildings', -80, 50, 0.3, 0.3);
		city.setGraphicSize(Std.int(city.width * 1));
		city.updateHitbox();
		add(city);

		phillyTrain = new PhillyTrain(2000, 360);
		add(phillyTrain);

		phillyStreet = new BGSprite('philly/Town_Ground', -500, 100);
		phillyStreet.setGraphicSize(Std.int(phillyStreet.width * 1.3));
		add(phillyStreet);

		//goons 
		goonleft = new BackGroundGoons(-500, 100, 1);
		goonleft.setGraphicSize(Std.int(goonleft.width * 1.1));
		goonleft.updateHitbox();
		add(goonleft);

		goonBackright = new BackGroundGoons(745, 550, 2);
		goonBackright.setGraphicSize(Std.int(goonBackright.width * 1.3));
		goonBackright.updateHitbox();
		add(goonBackright);

		phillyWires = new BGSprite('philly/Town_Wires', 0, 200, 0.8, 0.8);
		phillyWires.setGraphicSize(Std.int(phillyWires.width * 1));
		add(phillyWires);

		goonright = new BackGroundGoons(1050, 245, 0);
		goonright.setGraphicSize(Std.int(goonright.width * 1.1));
		goonright.updateHitbox();
		add(goonright);

		goonBackleft = new BackGroundGoons(100, 550, 3);
		goonBackleft.setGraphicSize(Std.int(goonBackleft.width * 1.3));
		goonBackleft.updateHitbox();
		add(goonBackleft);

		switch (CharMenuStory.bfmode)
		{
			case 'sen-beta' | 'sen-beta-w3':
				dialoguePrefix = '-beta';
			case 'sen-alpha' | 'sen-alpha-w3':
				dialoguePrefix = '-alpha';
			default:
				dialoguePrefix = '';
		}

		switch (songName.toLowerCase())
		{
			default:
				dialogueSong = 'week3';
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
		if (bloom != null) {
			bloom.data.intensity.value = [bloom.shaderintensity];
			bloom.data.blurSize.value = [bloom.shaderblurSize];
		} 
	}

	// For events
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "BG Goons Anim Type":
				if(goonBackleft != null) goonBackleft.swapDanceType(false);
				if(goonBackright != null) goonBackright.swapDanceType(false);
				if(goonleft != null) goonleft.swapDanceType(false);
				if(goonright != null) goonright.swapDanceType(false);
		}
	}

	override function phillyShoot(shootType:Int)
	{
		switch (shootType)
		{
			case 0: goonBackleft.shootAnim();
			case 1: goonBackright.shootAnim();
			case 2: goonleft.shootAnim();
			case 3: goonright.shootAnim();
		}
	}

	override function beatHit()
	{
		goonBackleft.dance();
		goonBackright.dance();
		goonleft.dance();
		goonright.dance();
		phillyTrain.beatHit(curBeat);
	}

	function dialogueStart()
	{
		if(Paths.fileExists('data/' + songName + '/dialogue' + dialoguePrefix + '.json', TEXT)) {
			game.startDialogue(DialogueBoxPsych.parseDialogue(Paths.json(songName + '/dialogue' + dialoguePrefix)), dialogueSong, dialogueSong == 'week3' ? 0.1 : 1);
			return;
		} else {
			trace('Dialogue is null or not properly formatted');
			startCountdown();
			return;
		}
	}
}