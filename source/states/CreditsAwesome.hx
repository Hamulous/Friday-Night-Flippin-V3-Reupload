package states;

class CreditsAwesome extends MusicBeatState
{
    var bg:FlxSprite;
   
	var curSelected:Int = 0;

    // stores the last credits object
	public static var lastCred:FlxSprite;

    var psychButton:FlxButton;
    var psychButtonSpr:FlxSprite;

    public var credGroup:FlxSpriteGroup;

    override function create()
        {
            FlxG.mouse.visible = true;

            bg = new FlxSprite().loadGraphic(Paths.image('creditsbutcool/background'));
            bg.setGraphicSize(FlxG.width);
            bg.antialiasing = ClientPrefs.data.antialiasing;
            bg.screenCenter();
            bg.scrollFactor.set();
            add(bg);

            credGroup = new FlxSpriteGroup();
		    add(credGroup);
            
            psychButton = new FlxButton(0, 0, "PSYCH ENGINE CREDITS", function()
            {
                MusicBeatState.switchState(new CreditsState());
            });
            psychButton.scale.set(3.2, 8);
            psychButton.x = FlxG.width - (psychButton.width + 200);
            psychButton.y = FlxG.height - (psychButton.height + 160);
            psychButton.updateHitbox();
            psychButton.alpha = 0;
            add(psychButton);

            psychButtonSpr = new FlxSprite(psychButton.x, psychButton.y);
			psychButtonSpr.antialiasing = ClientPrefs.data.antialiasing;
            psychButtonSpr.frames = Paths.getSparrowAtlas('creditsbutcool/Cred_Arrows');
			psychButtonSpr.animation.addByPrefix('idle', "button_idle", 24);
			psychButtonSpr.animation.addByPrefix('selected', "button_hover", 24);
			psychButtonSpr.animation.play('idle');
            add(psychButtonSpr);

            //this method is probably fucking AWFUL
            
			changeSelection(0);
		    super.create();

            cacheCredits();
        }

    override function update(elapsed:Float)
    {
        if (FlxG.sound.music != null)
            Conductor.songPosition = FlxG.sound.music.time;
		
		if (controls.UI_LEFT_P)
		{
			changeSelection(-1);
		}

		if (controls.UI_RIGHT_P)
		{
			changeSelection(1);
		}
        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxG.sound.music.stop();
            FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);

            MusicBeatState.switchState(new MainMenuState());
			FlxG.mouse.visible = false;
        }

        if(psychButton.status != FlxButton.NORMAL)
        {
            psychButtonSpr.animation.play('selected');
            psychButtonSpr.alpha = 1;
            psychButtonSpr.offset.set(8, 28);
        }
        else
        {
            psychButtonSpr.animation.play('idle');
            psychButtonSpr.alpha = 0.8;
            psychButtonSpr.offset.set(0, 0);
        }

        super.update(elapsed);
    }

    private function cacheCredits()
    {
        //this probably sucks

        Paths.image("creditsbutcool/Art_1");
        Paths.image("creditsbutcool/Art_2");
        Paths.image("creditsbutcool/Music_1");
        Paths.image("creditsbutcool/Music_2");
        Paths.image("creditsbutcool/Music_3");
        Paths.image("creditsbutcool/Music_4");
        Paths.image("creditsbutcool/Voice_1");
        Paths.image("creditsbutcool/Voice_2");
        Paths.image("creditsbutcool/Voice_3");
        Paths.image("creditsbutcool/nCode_1");
        Paths.image("creditsbutcool/nCode_2");
        Paths.image("creditsbutcool/nCode_3");
    }

    var sprToShow:String;

	function changeSelection(change:Int = 0)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

			curSelected += change;

			if (curSelected == 12)
				curSelected = 0;
			if (curSelected == -1)
				curSelected = 11;

            switch (curSelected)
            {
                case 0:
                    sprToShow = 'Art_1';
                case 1:
                    sprToShow = 'Art_2';
                case 2:
                    sprToShow = 'Music_1';
                case 3:
                    sprToShow = 'Music_2';
                case 4:
                    sprToShow = 'Music_3';
                case 5:
                    sprToShow = 'Music_4';
                case 6:
                    sprToShow = 'Voice_1';
                case 7:
                    sprToShow = 'Voice_2';
                case 8:
                    sprToShow = 'Voice_3';
                case 9:
                    sprToShow = 'nCode_1';
                case 10:
                    sprToShow = 'nCode_2';
                case 11:
                    sprToShow = 'nCode_3';
            }

            var credSpr:FlxSprite = new FlxSprite();

            credSpr.loadGraphic(Paths.image('creditsbutcool/$sprToShow'));
            credSpr.setGraphicSize(FlxG.width);
            credSpr.antialiasing = ClientPrefs.data.antialiasing;
            credSpr.screenCenter();
            credSpr.scrollFactor.set();
            credGroup.add(credSpr);

            if (lastCred != null) lastCred.kill();
			lastCred = credSpr;

            FlxTween.tween(credSpr, {y: credSpr.y + 50}, 0.2, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
		}
}