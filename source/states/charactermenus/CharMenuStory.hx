package states.charactermenus;

import flixel.effects.FlxFlicker;
import objects.HealthIcon;
import backend.Song;
import backend.WeekData;

import flixel.graphics.frames.FlxAtlasFrames;

typedef CharacterMenuStory = {
	var name:String;
	var characterName:String;
	//var portrait:String;
}

class CharMenuStory extends MusicBeatState
{
	var bfModePrefix:String = '';
	public static var bfmode:String = 'sen';
	var menuItems:Array<String> = ['BOYFRIEND', 'BOYFRIENDBETA', 'BOYFRIENDALPHA'];
	var curSelected:Int = 0;
	var txtDescription:FlxText;
	var idleCharacter:FlxSprite;
	var upArrow:FlxSprite;
	var downArrow:FlxSprite;
	var characterStyle:FlxSprite;
	var menuBG:FlxSprite;
	var senIcon:HealthIcon;
	var betaIcon:HealthIcon;
	var alphaIcon:HealthIcon;
	public static var isStoryMode:Bool = false;
	public var targetY:Float = 0;
	public static var characterShit:Array<CharacterMenuStory>;

	private var grpMenuShit:FlxTypedGroup<Alphabet>;
	private var grpMenuShiz:FlxTypedGroup<FlxSprite>;
	var alreadySelectedShit:Bool = false;
	// magnus sux

	var txtOptionTitle:FlxText;
	var thekeys:Array<String> = ['F','U','C','K','I','N','G','SPACE','K','I','T','T','Y','SHIFT','SHIFT','SHIFT','SHIFT','SHIFT','SHIFT','SHIFT','SHIFT'];

	override function create()
	{
		menuBG = new FlxSprite(0,-4).loadGraphic(Paths.image('CharSelect/char_select_bg'));
		menuBG.updateHitbox();
		menuBG.antialiasing = true;
		add(menuBG);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		grpMenuShiz = new FlxTypedGroup<FlxSprite>();
		add(grpMenuShiz);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true);
			songText.screenCenter(X);
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		txtDescription = new FlxText(FlxG.width * 0.075, menuBG.y + 200, 0, "", 32);
		txtDescription.alignment = CENTER;
		txtDescription.setFormat("assets/fonts/vcr.ttf", 32);
		txtDescription.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1.5, 1);
		txtDescription.color = FlxColor.WHITE;
		add(txtDescription);

		idleCharacter = new FlxSprite(0, -20);
		idleCharacter.frames = Paths.getSparrowAtlas('CharSelect/char_select_characters');
		idleCharacter.animation.addByPrefix('sen select idle', 'sen select idle', 24);
		idleCharacter.animation.addByPrefix('beta select idle', 'beta select idle', 24);
		idleCharacter.animation.addByPrefix('alpha select idle', 'alpha select idle', 24);
		idleCharacter.animation.addByPrefix('sen select HEY!!', 'sen select HEY!!', 24);
		idleCharacter.animation.addByPrefix('beta select HEY!!', 'beta select HEY!!', 24);
		idleCharacter.animation.addByPrefix('alpha select HEY!!', 'alpha select HEY!!', 24);
		
		idleCharacter.animation.play('sen select idle');
		idleCharacter.scale.set(0.7, 0.7);
		idleCharacter.updateHitbox();
		idleCharacter.screenCenter(XY);
		idleCharacter.antialiasing = true;
		
		add(idleCharacter);
		
		//idleCharacterBetter = new Boyfriend(0, 0, 'bf');

		upArrow = new FlxSprite(idleCharacter.x + 480 , idleCharacter.y + 100);
		upArrow.frames = Paths.getSparrowAtlas('CharSelect/char_select_ui_assets');
		upArrow.animation.addByPrefix('idle', "arrow up");
		upArrow.animation.addByPrefix('press', "arrow push up");
		upArrow.animation.play('idle');
		add(upArrow);

		downArrow = new FlxSprite(idleCharacter.x + 480 , idleCharacter.y + 300);
		downArrow.frames = Paths.getSparrowAtlas('CharSelect/char_select_ui_assets');
		downArrow.animation.addByPrefix('idle', 'arrow down');
		downArrow.animation.addByPrefix('press', "arrow push down", 24, false);
		downArrow.animation.play('idle');
		add(downArrow);

		characterStyle = new FlxSprite(idleCharacter.x + 380 , idleCharacter.y + 160);
		characterStyle.frames = Paths.getSparrowAtlas('CharSelect/char_select_ui_assets');
		characterStyle.animation.addByPrefix('CLASSIC', 'CLASSIC', 24, false);
		characterStyle.animation.addByPrefix('BETA', "BETA", 24, false);
		characterStyle.animation.addByPrefix('ALPHA', "ALPHA", 24, false);
		characterStyle.animation.play('CLASSIC');
		add(characterStyle);

		senIcon = new HealthIcon('sen');
		senIcon.x = 314;
		senIcon.y = 103;
		senIcon.visible = false;
		add(senIcon);

		betaIcon = new HealthIcon('beta');
		betaIcon.x = 314;
		betaIcon.y = 103;
		betaIcon.visible = false;
		add(betaIcon);

		alphaIcon = new HealthIcon('icon-alpha');
		alphaIcon.x = 314;
		alphaIcon.y = 103;
		alphaIcon.visible = false;
		add(alphaIcon);

		switch (WeekData.getWeekFileName()) //Just keeping this here for now
		{
			case 'week3':
				bfModePrefix = '-w3';
				trace('cookin');
	
			case 'week4':
				bfModePrefix = '-wind';
				trace('cookin');
		}

		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = FlxG.keys.justPressed.ENTER;

		if (!alreadySelectedShit)
		{
			if (upP)
				{
					changeSelection(-1);
				}
				if (downP)
				{
					changeSelection(1);
				}
				if (controls.UI_UP_P)
					upArrow.animation.play('press')
				else
					upArrow.animation.play('idle');

				if (controls.UI_DOWN_P)
					downArrow.animation.play('press');
				else
					downArrow.animation.play('idle');

				if (accepted && !FlxG.keys.anyPressed(['SPACE']))
					{
						alreadySelectedShit = true;
						var daSelected:String = menuItems[curSelected];
						FlxFlicker.flicker(idleCharacter, 0);
					
					//Selection and loading for them
					switch (daSelected)
					{
						case "BOYFRIEND":
							FlxG.sound.play(Paths.sound('confirmMenu'));
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
							idleCharacter.y = 257;
							idleCharacter.x = 307;
							playSelectAnimation(daSelected);
							bfmode = 'sen' + bfModePrefix;
							StoryMenuState.suffixThing = '';
						
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								LoadingState.loadAndSwitchState(new PlayState(), true);
								FreeplayState.destroyFreeplayVocals();
							});
						case "BOYFRIENDBETA":
							FlxG.sound.play(Paths.sound('confirmMenu'));
							playSelectAnimation(daSelected);
							idleCharacter.y = 250;
							idleCharacter.x = 290;
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
							bfmode = 'sen-beta' + bfModePrefix;
							StoryMenuState.suffixThing = '-beta';
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								LoadingState.loadAndSwitchState(new PlayState(), true);
								FreeplayState.destroyFreeplayVocals();
							});
							case "BOYFRIENDALPHA":
							FlxG.sound.play(Paths.sound('confirmMenu'));
							playSelectAnimation(daSelected);
							idleCharacter.y = 230;
							idleCharacter.x = 260;
							FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
							bfmode = 'sen-alpha' + bfModePrefix;
							StoryMenuState.suffixThing = '-alpha';
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								LoadingState.loadAndSwitchState(new PlayState(), true);
								FreeplayState.destroyFreeplayVocals();
							});
					
						default:
							// so it doesnt crash lol	
					}
				}

				if (thekeys[0] == 'SHIFT') // fix this later 
				{
					alreadySelectedShit = true;
					var daSelected:String = menuItems[curSelected];
					FlxFlicker.flicker(idleCharacter, 0);
					FlxG.sound.play(Paths.sound('confirmMenu'));
					playSelectAnimation(daSelected);
					FlxFlicker.flicker(grpMenuShit.members[curSelected],0);
					idleCharacter.y = 240;
					idleCharacter.x = 310;
					
					bfmode = 'kitty';
					StoryMenuState.suffixThing = '';

					PlayState.isStoryMode = false;
		
					new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						if(!GameJoltAPI.checkTrophy(166958))
							GameJoltAPI.getTrophy(166958, '#FEF200', 'Mrow!', 'Find the "Cat"');
						PlayState.SONG = Song.loadFromJson("fuckingkitty-hard", "fuckingkitty");
						LoadingState.loadAndSwitchState(new PlayState(), true);
					});
				}
		
				if (controls.BACK)
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
					FlxG.switchState(new MainMenuState());
				}
				if (FlxG.keys.anyPressed([thekeys[0]]))
				{
					trace("hes doing it "+thekeys[0]);
					thekeys.remove(thekeys[0]);
				}
		}

		super.update(elapsed);
	}

	function playSelectAnimation(char:String):Void
	{
		switch(char)
		{
			case 'BOYFRIEND':
				idleCharacter.animation.play('sen select HEY!!');
			case 'BOYFRIENDBETA':
				idleCharacter.animation.play('beta select HEY!!');
			case 'BOYFRIENDALPHA':
				idleCharacter.animation.play('alpha select HEY!!');
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;
	
		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;
	
		var bullShit:Int = 0;
	
		for (item in grpMenuShit.members)
		{
			item.x = bullShit - curSelected;
			bullShit++;

			item.alpha = 0;
		}

		charCheckLmao();
	}

	function charCheckLmao()
	{
		var daSelected:String = menuItems[curSelected];

		switch (daSelected)
		{
			case "BOYFRIEND":
				idleCharacter.animation.play('sen select idle');
				characterStyle.animation.play('CLASSIC');
				idleCharacter.x = 300;
				idleCharacter.y = 200;
				characterStyle.x = 880;
				senIcon.visible = true;
				betaIcon.visible = false;
				alphaIcon.visible = false;
				menuBG.color = 0xFFFFFF;
			case "BOYFRIENDBETA":
				idleCharacter.animation.play('beta select idle');
				idleCharacter.y = 250;
				idleCharacter.x = 280;
				characterStyle.x = 930;
				characterStyle.animation.play('BETA');
				senIcon.visible = false;
				betaIcon.visible = true;
				alphaIcon.visible = false;
				menuBG.color = 0xFFFFFF;
			case "BOYFRIENDALPHA":
				idleCharacter.animation.play('alpha select idle');
				idleCharacter.y = 270;
				idleCharacter.x = 280;
				characterStyle.x = 900;
				characterStyle.animation.play('ALPHA');
				senIcon.visible = false;
				betaIcon.visible = false;
				alphaIcon.visible = true;
				menuBG.color = 0xFFFFFF;
		}
	
	}
	
}