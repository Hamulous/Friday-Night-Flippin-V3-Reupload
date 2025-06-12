package states;

import flixel.input.FlxPointer;
import lime.utils.Assets;
#if sys
import sys.FileSystem;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRandom;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import lime.utils.Assets;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import backend.Fish;

class Fishing extends MusicBeatState
{
    var pf:String = 'fishing';
    var mouse:FlxSprite; 
    var mouseclick:FlxSprite; 
    public static var zoomvalue:Float = 3; 
    //game objects
    var dusty:FlxSprite;
    var water:FlxSprite;
    var boat:FlxSprite;
    var rod:FlxSprite;
    var unlockedSong:FlxText;
    public static var pod:FlxSprite;
    var highscore:FlxText; // hi :)
    var HTP1:FlxText; 
    var HTP2:FlxText; 
    var HTP3:FlxText;
    var composetext:FlxText;
    var lineInstStart:FlxSprite;
    var lineInstEnd:FlxSprite;
    var line1:FlxSprite;
    var line2:FlxSprite;
	var allfish:FlxTypedGroup<Fish>;
    public static var score:Int = 0;

    public static var startSong = true;

    // DEBUG
    var isDebug:Bool = false; // basically just do what you want to customize the mini game lol

	override public function create()
	{
        FlxG.sound.playMusic(Paths.music('game'), 1, true);

        #if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("I'M FUCKING FISHING!", null);
		#end


		super.create();
		allfish = new FlxTypedGroup<Fish>();
        Conductor.bpm = 90;
		FlxG.sound.music.stop;
		//FlxG.mouse.visible = true;]
        if (FlxG.save.data.fishscore == null)
            FlxG.save.data.fishscore = 0;

        score = FlxG.save.data.fishscore;

        //THE SKY CREATION
        var thatfunnyX:Float = 0;
		for (i in 0...7)
        {
            var thatbg:FlxSprite;
            thatbg = new FlxSprite(0,0).loadGraphic(Paths.image('$pf/sky'+FlxG.random.int(1,3)));
            thatbg.x = thatfunnyX;
            thatbg.setGraphicSize(Std.int(thatbg.width * zoomvalue));
            thatbg.updateHitbox();
            thatbg.ID = i;
            thatfunnyX += 213;
            add(thatbg);
        }

        unlockedSong = new FlxText(462, FlxG.height - 544, 0, "A SONG IN FREEPLAY HAS BEEN UNLOCKED!", 24);
		unlockedSong.scrollFactor.set();
        unlockedSong.alpha = 0;
		unlockedSong.setFormat("VCR OSD Mono", 16, FlxColor.BLACK, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.WHITE);
        FlxTween.tween(unlockedSong, {y: unlockedSong.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});
		add(unlockedSong);
        dusty = new FlxSprite(596,412).loadGraphic(Paths.image('$pf/dusty'), true, 31);
		dusty.setGraphicSize(Std.int(dusty.width * zoomvalue));
		dusty.animation.add("bop", [0, 2, 3, 0], 30, false);
		dusty.updateHitbox();
        rod = new FlxSprite(532,402).loadGraphic(Paths.image('$pf/rod'));
		rod.setGraphicSize(Std.int(rod.width * zoomvalue));
		rod.updateHitbox();
        boat = new FlxSprite(530,323).loadGraphic(Paths.image('$pf/boat'));
		boat.setGraphicSize(Std.int(boat.width * zoomvalue));
		boat.updateHitbox();
        pod = new FlxSprite(530,323).loadGraphic(Paths.image('$pf/pod'));
		pod.setGraphicSize(Std.int(pod.width * zoomvalue));
		pod.updateHitbox();
        mouse = new FlxSprite(0,0).loadGraphic(Paths.image('$pf/mouse'));
		mouse.setGraphicSize(Std.int(mouse.width * zoomvalue));
		mouse.updateHitbox();
        mouseclick = new FlxSprite(0,0).loadGraphic(Paths.image('$pf/mouseClick'), true, 20);
		mouseclick.setGraphicSize(Std.int(mouseclick.width * zoomvalue));
		mouseclick.animation.add("zoom", [0, 1, 2, 3], 30, false);
		mouseclick.updateHitbox();
        mouseclick.alpha = 0;
        var evilTrail = new FlxTrail(mouseclick, null, 4, 24, 0.3, 0.069);

        //layering
        add(rod);
		add(dusty);
		add(boat);
        add(composetext);

        // doing the same for water but kinda different
        var thatfunnyX:Float = 0;
        for (i in 0...5)
            {
                var thatbg:FlxSprite;
                thatbg = new FlxSprite(0,380).loadGraphic(Paths.image('$pf/waters/normal'));
                thatbg.x = thatfunnyX;
                thatbg.setGraphicSize(Std.int(thatbg.width * zoomvalue));
                thatbg.updateHitbox();
                thatbg.ID = i;
                thatfunnyX += 300;
                add(thatbg);
            }
            add(pod);
            add(line1);
            highscore = new FlxText(6, 3, 0, "HIGH: "+FlxG.save.data.fishscore, 36);
            add(highscore);
            HTP1 = new FlxText(6, 37, 0, "Press Z to reel your rod", 36);
            HTP1.visible = true;
            add(HTP1);
            HTP2 = new FlxText(6, 72, 0, "Press X to save your score", 36);
            HTP2.visible = true;
            add(HTP2);
            HTP3 = new FlxText(6, 112, 0, "Press C to hide this", 36);
            HTP3.visible = true;
            add(HTP3);
            add(allfish);
        add(mouseclick);
		add(mouse);
		FlxG.autoPause = false;

        spawnFish();
    }
    var timeAuto:Float = 120;
    var timeRender:Float = 0;

	override public function update(elapsed:Float)
    {
        mouse.x = FlxG.mouse.screenX;
        mouse.y = FlxG.mouse.screenY;
        if (FlxG.save.data.fishscore > score)
        highscore.text = 'HIGH: '+FlxG.save.data.fishscore;
        else if (FlxG.save.data.fishscore < score)
        highscore.text = 'HIGH: $score';

        // getting a fish
		allfish.forEach(function(spr:Fish)
            {
                if (spr.isCaught == true)
                {
                    spr.kill();
                }
            });

        if (score >= 29 && !FlxG.save.data.itComeWithEggroll)
        {   
            unlockedSong.alpha = 1;
            FlxG.save.data.itComeWithEggroll = true;
        }

        if (score == 100 && !GameJoltAPI.checkTrophy(167012))
        {
            GameJoltAPI.getTrophy(167012, '#FEF200', 'Im Fishing!', 'Catch 100 fish');
        }

        // creates fish at random ass times
		if (FlxG.random.int(0,10000) == 1)
        {
            spawnFish();
        }

        #if debug
        if (FlxG.keys.pressed.SLASH)
        {
            spawnFish();
        }
        #end

		if (timeAuto < 1)
        {
            saveprog();
            timeAuto = 120;
        }
		else
        {
            timeAuto -= elapsed;
        }
        pod.y += 0.8;
        if (FlxG.keys.justPressed.Z)
            fcast();
        if (FlxG.keys.justPressed.X)
            timeAuto = 0;
        if (FlxG.keys.justPressed.C)
            if (HTP1.visible == false) //only need to make one for the bool to become true
            {
                HTP1.visible = true;
                HTP2.visible = true;
                HTP3.visible = true;
            } else {
                HTP1.visible = false;
                HTP2.visible = false;
                HTP3.visible = false;
            }

        if (controls.BACK)
        {
            saveprog();
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxG.sound.music.stop();
            FlxG.sound.playMusic(Paths.music('freakyMenu'), 1, true);
            FlxG.switchState(new MainMenuState());
            FlxG.mouse.visible = false;
        }
        if (FlxG.mouse.justPressed)
        {
            mouseclick.alpha = 1;
			mouseclick.animation.play("zoom");
            mouseclick.x = mouse.x-30;
            mouseclick.y = mouse.y-30;
            FlxTween.tween(mouseclick, {alpha: 0}, 0.3, {ease: FlxEase.quintOut});
        }

        if (FlxG.mouse.pressedRight && mouseclick.overlaps(rod) && isDebug)
        {
            rod.x = mouse.x-30;
            rod.y = mouse.y-30;
            mouseclick.x = mouse.x-30;
            mouseclick.y = mouse.y-30;
        }

        if (FlxG.keys.justPressed.C && isDebug)
            {
                trace("\n \n x: "+rod.x+" y: "+rod.y);
            }
		super.update(elapsed);
        Conductor.songPosition = FlxG.sound.music.time;
    }

	override function beatHit()
        {
            super.beatHit();
			dusty.animation.play("bop");
            //trace("funnybeat");
        }
    //the saving graphics
    function saveprog()
        {
            FlxG.save.data.fishscore = score;
            var pog:FlxSprite;
            pog = new FlxSprite(1148,558).loadGraphic(Paths.image('$pf/loadPog'));
            pog.setGraphicSize(Std.int(pog.width * zoomvalue));
            pog.updateHitbox();
            var svText:FlxSprite;
            svText = new FlxSprite(1100,649).loadGraphic(Paths.image('$pf/saving'));
            svText.setGraphicSize(Std.int(svText.width * zoomvalue));
            svText.updateHitbox();
            add(svText);
            add(pog);
            FlxTween.tween(pog, {angle: 360}, 0.7, {ease: FlxEase.quintOut,
                onComplete: function(twn:FlxTween)
                {
                    pog.angle = 0;
					new FlxTimer().start(1, function(tmr:FlxTimer)
                        {
                    FlxTween.tween(pog, {angle: 360}, 0.7, {ease: FlxEase.quintOut,
                        onComplete: function(twn:FlxTween)
                        {
                            pog.angle = 0;
                            new FlxTimer().start(1, function(tmr:FlxTimer)
                                {
                            FlxTween.tween(pog, {angle: 360, alpha: 0}, 0.7, {ease: FlxEase.quintOut,
                                onComplete: function(twn:FlxTween)
                                {
                                    pog.angle = 0;
                                    remove(pog);
                                }
                            });
                            FlxTween.tween(svText, {angle: 360, alpha: 0}, 0.7, {ease: FlxEase.quintOut,
                                onComplete: function(twn:FlxTween)
                                {
                                    svText.angle = 0;
                                    remove(svText);
                                }
                            });
                        });
                        }
                    });
                });
                }
            });
            FlxG.save.data.fishscore = score;
        }
    // this is for casting
        function fcast()
        {
            //FlxG.sound.play(Paths.sound('SNAP'));
            pod.x = FlxG.random.int(10,1225);
            pod.y = 0;
        }

        // HAHA FUNNY SPAWNING FOR FISH
        function spawnFish()
        {
            var aFish:Fish;
            var type:String = 'default';
            var anim:Array<Int> = [0,1];
            trace(anim);
            anim = [];
            var typelol:Int = FlxG.random.int(20,1100);

            if (typelol < 1000) // random type of fish
                type = 'default';
            else if (typelol > 1000 && typelol < 1099)
                type = 'clown';
            else if (typelol == 1100)
                type = 'fat';
            var classDef:Array<String> = CoolUtil.coolTextFile(Paths.txt('fishing/fishClasses'));
            for (i in 0...classDef.length)
                {
                    if (type == classDef[i].split(",")[0])
                        {
                            trace(anim);
                            for (i in 0...classDef[i].split(",")[2].split(":").length)
                                {
                                    anim.push(Std.parseInt(classDef[i].split(",")[2].split(":")[i]));
                                    trace(anim);
                                }
                                aFish = new Fish(FlxG.random.int(20,1100),558,type,anim,Std.parseInt(classDef[i].split(",")[3]),Std.parseInt(classDef[i].split(",")[4]) == 1);
                                aFish.loadGraphic(Paths.image('$pf/${type}'), true, Std.parseInt(classDef[i].split(",")[1]));
                                aFish.setGraphicSize(Std.int(aFish.width * Fishing.zoomvalue));
                                aFish.updateHitbox();
                                allfish.add(aFish);
                        }
                }
        }
}