package states.stages;

import states.stages.objects.*;
import objects.Character;
import cutscenes.DialogueBoxPsych;
import states.charactermenus.CharMenuStory;
import flixel.addons.display.FlxBackdrop;

#if !flash
import openfl.filters.ShaderFilter;
import shaders.BloomShader;
#end

class Stage extends BaseStage
{
	//Flippin stage stuff 
	var stageBack:FlxSprite;
	var stageBackAlt:FlxSprite;
	var stageFront:FlxSprite;
	var stageFrontAlt:FlxSprite;
	var darkFlash:FlxSprite;
	var ADDSHIT:String = '';

	var stageAudience:FlxSprite;
	var light1:FlxSprite;
	var light2:FlxSprite;
	var lightChange:FlxSprite;
	var dadbattleFog:DadBattleFog;
	var dialogueSong:String;
	var dialoguePrefix:String = '';
	var backdrop:FlxBackdrop;

	//shaders
	var bloom:BloomShader;
	var bloomADD:Float = 0;

	override function create()
	{
		stageBack = new FlxSprite(-600, -200).loadGraphic(Paths.image("stageback"));
		stageBack.antialiasing = true;
		stageBack.scrollFactor.set(0.9, 0.9);
		stageBack.active = false;
		add(stageBack);

		stageBackAlt = new FlxSprite(-600, -200).loadGraphic(Paths.image("stageback_PU"));
		stageBackAlt.antialiasing = true;
		stageBackAlt.scrollFactor.set(0.9, 0.9);
		stageBackAlt.active = false;
		stageBackAlt.visible = false;
		add(stageBackAlt);

		stageFront = new FlxSprite(-650, 600).loadGraphic(Paths.image("stagefront"));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		add(stageFront);

		stageFrontAlt = new FlxSprite(-650, 600).loadGraphic(Paths.image("stagefront_PU"));
		stageFrontAlt.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFrontAlt.updateHitbox();
		stageFrontAlt.antialiasing = true;
		stageFrontAlt.scrollFactor.set(0.9, 0.9);
		stageFrontAlt.active = false;
		stageFrontAlt.visible = false;
		add(stageFrontAlt);

		light1 = new FlxSprite(-125, -100).loadGraphic(Paths.image('stage_light-other'));
		light1.setGraphicSize(Std.int(light1.width * 1.1));
		light1.updateHitbox();
		light1.scrollFactor.set(0.9, 0.9);
		add(light1);

		light2 = new FlxSprite(1225, -100).loadGraphic(Paths.image('stage_light-broken'));
		light2.setGraphicSize(Std.int(light2.width * 1.1));
		light2.updateHitbox();
		light2.scrollFactor.set(0.9, 0.9);
		add(light2);

		var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image("stagecurtains"));
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		stageCurtains.antialiasing = true;
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.active = false;
		add(stageCurtains);

		if (songName == 'decay')
		{
			backdrop = new FlxBackdrop(Paths.image('coolBackDrop'), XY);
			backdrop.alpha = 0.00001;
			backdrop.scale.set(1.5, 1.5);
			backdrop.updateHitbox();
			backdrop.scrollFactor.set(0, 0.07);
			add(backdrop);
		}

		bloom = new BloomShader();
		camGame.setFilters([new ShaderFilter(bloom)]);
		
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
			case 'tutorial':
				dialogueSong = 'week0';
			case 'spokeebo' | 'decay' | 'pumpd-up':
				dialogueSong = 'week1';
			default:
				dialogueSong = 'week1';
				trace('Most Likely Null, Dumbass');
		}

		if(isStoryMode && !seenCutscene)
		{
			setStartCallback(dialogueStart);
		}

		trace(songName);
	}

	override function createPost()
	{
		if (songName == 'Pumpd up(legacy)' || songName == 'pumpd-up')
		{
			stageAudience = new FlxSprite(-400, 660);
			stageAudience.frames = Paths.getSparrowAtlas("pu_crowd");
			stageAudience.animation.addByPrefix('bounce', "crowd bounce", 24, false);
			stageAudience.animation.addByIndices('bounce', 'crowd bounce', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			stageAudience.animation.addByPrefix('bounce STAGE', "crowd bounce hype", 24, false);
			stageAudience.antialiasing = true;
			stageAudience.scrollFactor.set(0.9, 0.9);
			stageAudience.setGraphicSize(Std.int(stageAudience.width * 1));
			stageAudience.updateHitbox();

			lightChange = new FlxSprite(-320, -300).loadGraphic(Paths.image("spotlight"));
			lightChange.antialiasing = true;
			lightChange.scrollFactor.set(1, 1);
			lightChange.setGraphicSize(Std.int(lightChange.width * 1.9));
			lightChange.updateHitbox();
			lightChange.alpha = 0.00001;

			darkFlash = new BGSprite(null, -FlxG.width, -FlxG.height, 0, 0);
			darkFlash.makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.BLACK);
			darkFlash.alpha = 0.00001;
	
			add(lightChange);
			add(stageAudience);
			add(darkFlash);
		}
	}

	override function update(elapsed:Float)
	{
		if (backdrop != null)
		{
			backdrop.x += 2;
			backdrop.y += 2;
		}

		if (bloom != null) {
			bloom.data.intensity.value = [bloom.shaderintensity+ bloomADD];
			bloom.data.blurSize.value = [bloom.shaderblurSize];
		} 

		bloomADD = FlxMath.lerp(bloomADD, 0, 0.02);
		if (bloomADD < 0.1)
			bloomADD = 0;
	}

	override function eventPushed(event:objects.Note.EventNote)
	{
		switch(event.event)
		{
			case "Dadbattle Spotlight":
				dadbattleFog = new DadBattleFog();
				dadbattleFog.visible = false;
				add(dadbattleFog);
		}
	}

	override function beatHit()
	{
		if (stageAudience != null)
			stageAudience.animation.play('bounce'+ADDSHIT, true);
	}

	override function sectionHit()
	{
		if (game.coolDecayShit)
		{
			if (bloom != null) {
				bloomADD = 1;
				trace(bloomADD);
			} 
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "Decay Triggers":
				if(flValue1 == null) flValue1 = 0;
				var val:Int = Math.round(flValue1);

				switch(val)
				{
					case 0:
						game.coolDecayShit = true;
						FlxTween.tween(backdrop, {alpha: 0.4125}, 0.5, {ease: FlxEase.circOut});
					case 1:
						game.coolDecayShit = false;
						FlxTween.tween(backdrop, {alpha: 0}, 0.5, {ease: FlxEase.circOut});
				}
			case "Trigger bg lights":
				stageBack.visible = false;
				stageBackAlt.visible = true;
				stageFront.visible = false;
				stageFrontAlt.visible = true;
				darkFlash.alpha = 1;
				ADDSHIT = ' STAGE';
				FlxTween.tween(darkFlash, {alpha: 0}, 0.4, {ease: FlxEase.quadInOut});

				FlxTween.tween(lightChange, {alpha: 1}, 0.4, {ease: FlxEase.quadInOut});
			case "Dadbattle Spotlight":
				if(flValue1 == null) flValue1 = 0;
				var val:Int = Math.round(flValue1);

				switch(val)
				{
					case 1, 2, 3: //enable and target dad
						if(val == 1) //enable
						{
							dadbattleFog.visible = true;
							defaultCamZoom += 0.12;
						}
						FlxTween.tween(dadbattleFog, {alpha: 0.7}, 1.5, {ease: FlxEase.quadInOut});

					default:
						defaultCamZoom -= 0.12;
						FlxTween.tween(dadbattleFog, {alpha: 0}, 0.7, {onComplete: function(twn:FlxTween) dadbattleFog.visible = false});
				}
		}
	}

	function dialogueStart()
	{
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