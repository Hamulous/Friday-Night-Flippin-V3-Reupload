package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import openfl.utils.Assets;
import haxe.Json;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.7.2h'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var bgItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'options',
		'credits',
		'fish',
		'movies'
	];

	var magenta:FlxSprite;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		Mods.loadTopMod();

		GameJoltAPI.connect();
		GameJoltAPI.authDaUser(FlxG.save.data.gjUser, FlxG.save.data.gjToken);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		bgItems = new FlxTypedGroup<FlxSprite>();
		add(bgItems);

		var bg:FlxSprite = new FlxSprite(-14, -20).loadGraphic(Paths.image('mainmenu_flippin/funny board'));
		bg.updateHitbox();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 0);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.scale.x = 1;
			menuItem.scale.y = 1;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu_flippin/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			switch (i)                                        
			{                                        
				case 0:                        
					menuItem.x = 70;
					menuItem.y = 0;
				case 1:                         
					menuItem.x = 70;
					menuItem.y = 130;
				case 2:                             
					menuItem.x = 200;
					menuItem.y = 230;
				case 3:                            
					menuItem.x = 70;
					menuItem.y = 390;
				case 4:
					menuItem.x = 400;
					menuItem.y = 455;
				case 5:
					menuItem.x = 70;
					menuItem.y = 535;
			}
			menuItems.add(menuItem);
			menuItem.updateHitbox();

			var bgItem:FlxSprite = new FlxSprite(1, 0);
			bgItem.antialiasing = ClientPrefs.data.antialiasing;
			bgItem.frames = Paths.getSparrowAtlas('mainmenu_flippin/bg_' + optionShit[i]);

			if (i == 5)
				bgItem.animation.addByPrefix('idle', "cutscenes bg", 24);
			else 
				bgItem.animation.addByPrefix('idle', optionShit[i] + " bg", 24);
			
			bgItem.animation.play('idle');
			bgItem.alpha = 0;
			bgItems.add(bgItem);
			bgItem.updateHitbox();
		}

		var flippinVer:FlxText = new FlxText(12, FlxG.height - 64, 0, "Friday Night Flippin' V3", 12);
		flippinVer.scrollFactor.set();
		flippinVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(flippinVer);
		var psychVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		psychVer.scrollFactor.set();
		psychVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(psychVer);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);
		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;

					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (optionShit[curSelected])
						{
							case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
							case 'freeplay':
								MusicBeatState.switchState(new FreeplayState());
							case 'credits':
								MusicBeatState.switchState(new CreditsAwesome());
								FlxG.sound.playMusic(Paths.music('decay_chill_mix_wip_1'), 1, true);
							case 'fish':
								MusicBeatState.switchState(new Fishing());
							case 'movies':
								MusicBeatState.switchState(new CutSceneMenu());
							case 'options':
								MusicBeatState.switchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
									PlayState.stageUI = 'normal';
								}
						}
					});

					for (i in 0...menuItems.members.length)
					{
						if (i == curSelected)
							continue;
						FlxTween.tween(menuItems.members[i], {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								menuItems.members[i].kill();
							}
						});
					}
				}
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		menuItems.members[curSelected].animation.play('idle');
		menuItems.members[curSelected].updateHitbox();
		bgItems.members[curSelected].alpha = 0;

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.members[curSelected].animation.play('selected');
		menuItems.members[curSelected].centerOffsets();
		bgItems.members[curSelected].alpha = 1;
	}
}