package states;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;

class CutSceneMenu extends MusicBeatState
{
    // DEBUG THING
	var editMode:Bool = false;
	var editableSprite:FlxSprite;
	var lpo:Int = 700;
    
    var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
    var dashesSprs:FlxTypedSpriteGroup<FlxSprite>;
    var bg:FlxSprite;
    var senPrefix:String = 'SEN';

    var curSelected:Int = 1;
    var beta_Orelander:FlxSprite;
    var sen_Rose:FlxSprite;
    var isBeta:Bool = true;

    override public function create():Void
    {
		bg = new FlxSprite(1);
		bg.frames = Paths.getSparrowAtlas('Cutscene_Menu/Wall_Instance');
		bg.animation.addByPrefix('idle', 'wall_instance', 24, false);
        bg.setGraphicSize(Std.int(1290));
        bg.updateHitbox();
        bg.antialiasing = ClientPrefs.data.antialiasing;
        add(bg);

        var tv:FlxSprite = new FlxSprite(-66);
		tv.frames = Paths.getSparrowAtlas('Cutscene_Menu/TV Loop');
		tv.animation.addByPrefix('idle', 'teevee', 24, true);
        tv.animation.play('idle');
        tv.setGraphicSize(Std.int(625));
        tv.updateHitbox();
        tv.antialiasing = ClientPrefs.data.antialiasing;
        add(tv);

        beta_Orelander = new FlxSprite(1164, 141);
		beta_Orelander.frames = Paths.getSparrowAtlas('Cutscene_Menu/Beta_Orelander');
        beta_Orelander.animation.addByIndices('idle', 'Beta_Oleander', [0, 1, 2, 3, 4], "", 24, true);
        beta_Orelander.animation.addByPrefix('selected', 'Beta_Oleander_Select', 24, true);
        beta_Orelander.animation.play('selected');
        beta_Orelander.setGraphicSize(Std.int(625));
        beta_Orelander.updateHitbox();
        beta_Orelander.antialiasing = ClientPrefs.data.antialiasing;
        add(beta_Orelander);

        sen_Rose = new FlxSprite(1164, 141);
		sen_Rose.frames = Paths.getSparrowAtlas('Cutscene_Menu/Sen_Rose');
        sen_Rose.animation.addByIndices('idle', 'Sen_Rose', [0, 1, 2, 3], "", 24, true);
        sen_Rose.animation.addByPrefix('selected', 'Sen_Rose_Select', 24, true);
        sen_Rose.animation.play('idle');
        sen_Rose.setGraphicSize(Std.int(625));
        sen_Rose.updateHitbox();
        sen_Rose.antialiasing = ClientPrefs.data.antialiasing;
        add(sen_Rose);

        editableSprite = sen_Rose;
        editMode = true; 

        dashesSprs = new FlxTypedSpriteGroup<FlxSprite>();
        add(dashesSprs);

        for(i in 1...4)
        {
            var tapes:FlxSprite = new FlxSprite(-316 + (i * 450), 495);
            tapes.loadGraphic(Paths.image('Cutscene_Menu/T'+i));
            tapes.ID = i;
            dashesSprs.add(tapes);
            tapes.antialiasing = ClientPrefs.data.antialiasing;
            tapes.updateHitbox();   
        }

        leftArrow = new FlxSprite(19, 595);
		leftArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.antialiasing = ClientPrefs.data.antialiasing;
	    add(leftArrow);

        rightArrow = new FlxSprite(1211, 595);
		rightArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = ClientPrefs.data.antialiasing;
		add(rightArrow);

        changeSelection(0);
        changeSen();

        new FlxTimer().start(10, function(tmr:FlxTimer) {
            playbganimation();
        });

        super.create();
    }

    var selectedSomethin:Bool = false;

    override public function update(elapsed:Float):Void
    {
        if (!selectedSomethin)
        {
            if (controls.UI_RIGHT)
                rightArrow.animation.play('press')
            else
                rightArrow.animation.play('idle');

            if (controls.UI_LEFT)
                leftArrow.animation.play('press');
            else
                leftArrow.animation.play('idle');

            if (controls.BACK)
            {
                selectedSomethin = true;
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuState());
            }

            var leftP = controls.UI_LEFT_P;
            var rightP = controls.UI_RIGHT_P;
            var upP = controls.UI_UP_P;
            var downP = controls.UI_DOWN_P;
            var accepted = controls.ACCEPT;

            if (leftP)
            {
                changeSelection(-1);
                FlxG.sound.play(Paths.sound('scrollMenu'));
            }
            else if (rightP)
            {
                changeSelection(1);
                FlxG.sound.play(Paths.sound('scrollMenu'));
            }

            if (upP || downP)
            {
                changeSen();
                FlxG.sound.play(Paths.sound('scrollMenu'));
            }

            if (accepted)
            {
                selectedSomethin = true;
                FlxG.sound.play(Paths.sound('confirmMenu'));
                
                if (FlxG.sound.music != null)
                    FlxG.sound.music.stop();

                dashesSprs.forEach(function(spr:FlxSprite)
                {
                    if (curSelected != spr.ID)
                    {
                        FlxTween.tween(spr, {alpha: 0}, 0.4, {
                            ease: FlxEase.quadOut,
                            onComplete: function(twn:FlxTween)
                            {
                                spr.kill();
                            }
                        });
                    }
                    else
                    {
                        FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
                        {
                            switch (curSelected)
                            {
                                case 1:
                                    MusicBeatState.switchState(new VideoPlayerState(senPrefix + '_W1', 'cutscenemenu', 0.2));
                                case 2:
                                    MusicBeatState.switchState(new VideoPlayerState(senPrefix + '_W3', 'cutscenemenu', 0.2));
                                case 3:
                                    MusicBeatState.switchState(new VideoPlayerState(senPrefix + '_W4', 'cutscenemenu', 0.2));
                            }
                        });
                    }
                });
            }
        }

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

        dashesSprs.x = FlxMath.lerp(dashesSprs.x, 860 - (460 * (curSelected)), 0.10);

        super.update(elapsed);
    }

    function changeSelection(change:Int = 0)
    {
        FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;
        trace(curSelected);

		if (curSelected <= 0)
			curSelected = 3;
		if (curSelected >= 4)
			curSelected = 1;

        for (item in dashesSprs.members)
        {
            if (item.ID == curSelected){
                item.alpha = 1;
                item.setGraphicSize(Std.int(345));	
            } else{
                item.setGraphicSize(Std.int(309));
                item.alpha = 0.6;
            }
        }
    }

    function playbganimation()
    {
        bg.animation.play('idle');
        new FlxTimer().start(10, function(tmr:FlxTimer) {
            playbganimation();
        });
    }

    function changeSen()
    {
        isBeta = !isBeta;
        if (isBeta)
        {
            senPrefix = 'BETA';
            sen_Rose.animation.play('idle');
            beta_Orelander.animation.play('selected');
            beta_Orelander.setPosition(835, -77);
            beta_Orelander.setGraphicSize(Std.int(265));
            sen_Rose.setPosition(905, -124);
            sen_Rose.setGraphicSize(Std.int(100));
            sen_Rose.alpha = 0.4;
            beta_Orelander.alpha = 1;
        }
        else 
        {
            senPrefix = 'SEN';
            sen_Rose.animation.play('selected');
            beta_Orelander.animation.play('idle');
            sen_Rose.setPosition(733, -269);
            sen_Rose.setGraphicSize(Std.int(265));
            beta_Orelander.setPosition(974, 47);
            beta_Orelander.setGraphicSize(Std.int(125));
            sen_Rose.alpha = 1;
            beta_Orelander.alpha = 0.4;
        }
    }
}