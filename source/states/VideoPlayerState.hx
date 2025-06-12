package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import backend.VideoHandler;
import flixel.math.FlxPoint;

using StringTools;

class VideoPlayerState extends MusicBeatState
{
	var oldFPS:Int = VideoHandler.MAX_FPS;
	var video:VideoHandler;
	var videoname:String;
    var videoCallBack:String;
	var startdelay:Float;
    var window:FlxSprite;
    var skipText:FlxText;
    var isPaused:Bool = false;
    var canSkip:Bool = false;
    var skippedVideo:Bool = false;

	//DEBUG THING
	var editable:Bool = false;
    var editbleSprite:FlxSprite;
    var lpo:Int = 700;

	public function new(vidname:String, callBack:String, delay:Float, ?canskip:Bool = true) 
	{
		super();	
        videoCallBack = callBack;
		videoname = vidname;
		startdelay = delay;
        canSkip = canskip; 
	}

	override public function create():Void
	{
        //Preach Sprite
        window = new FlxSprite();

		super.create();

		new FlxTimer().start(startdelay, function(tmr:FlxTimer)
		{
			VideoHandler.MAX_FPS = 60;

			video = new VideoHandler();

			video.playMP4(Paths.video(videoname), function(){
				next();
				#if web
					VideoHandler.MAX_FPS = oldFPS;
				#end
			}, false, false);

			//HARD CODING BECAUSE I'M STUPID IG???
			switch (videoname)
			{
				case 'klaskiiTitle':
					video.updateHitbox();
					video.setPosition(318, 162);
					video.scale.set(2, 2);
			}
			video.antialiasing = ClientPrefs.data.antialiasing;
			add(video);

            skipText = new FlxText(12, FlxG.height - 44, 0, "Press Q To Skip!", 32);
            skipText.scrollFactor.set();
            skipText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            skipText.alpha = 0.000001;
            add(skipText);

			editbleSprite = video;
			editable = false;
		});
	}

	override public function update(elapsed:Float)
    {
        if (canSkip)
        {
            if (controls.ACCEPT)
            {
                isPaused = !isPaused;
                if (isPaused)
                {
                    video.pause();
                    skipText.alpha = 1;
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                }
                else 
                {
                    skipText.alpha = 0.000001;
                    video.resume();
                }
            }
    
            if (FlxG.keys.justPressed.Q && isPaused && !skippedVideo)
            {
                skippedVideo = true;
                window = new FlxSprite();
                window.frames = Paths.getSparrowAtlas('Glass_Boom');
                window.animation.addByPrefix('break', "Break", 24, false);
                window.scale.set(1.5, 1);
                window.screenCenter();
                add(window);
    
                window.animation.play('break');
                window.animation.finishCallback = (aName:String) ->
                {
                    trace('VIDEO SKIPPED!!');
                    next();
                }
                FlxG.sound.play(Paths.sound('glassbreak'));
            }
        }
       

		if (FlxG.keys.pressed.SHIFT && editable)
            {
                editbleSprite.x = FlxG.mouse.screenX;
                editbleSprite.y = FlxG.mouse.screenY;
            }
        else if (FlxG.keys.justPressed.C && editable)
            {
                trace(editbleSprite);
                trace(lpo);
            }
        else if (FlxG.keys.justPressed.E && editable)
                {
                    if (FlxG.keys.pressed.ALT)
                        lpo += 100;
                    else
                        lpo += 15;
                    editbleSprite.setGraphicSize(Std.int(lpo));
                    editbleSprite.updateHitbox();
                }
        else if (FlxG.keys.justPressed.Q && editable)
                {
                    if (FlxG.keys.pressed.ALT)
                        lpo -= 100;
                    else
                        lpo -= 15;
                    editbleSprite.setGraphicSize(Std.int(lpo));
                    editbleSprite.updateHitbox();
                }
        else if (FlxG.keys.justPressed.L && editable)
                {
                    if (FlxG.keys.pressed.ALT)
                        editbleSprite.x += 50;
                    else
                        editbleSprite.x += 1;
                }
        else if (FlxG.keys.justPressed.K && editable)
                {
                    if (FlxG.keys.pressed.ALT)
                        editbleSprite.y += 50;
                    else
                        editbleSprite.y += 1;
                }
        else if (FlxG.keys.justPressed.J && editable)
                {
                    if (FlxG.keys.pressed.ALT)
                        editbleSprite.x -= 50;
                    else
                        editbleSprite.x -= 1;
                }
        else if (FlxG.keys.justPressed.I && editable)
                {
                    if (FlxG.keys.pressed.ALT)
                        editbleSprite.y -= 50;
                    else
                        editbleSprite.y -= 1;
                }
		super.update(elapsed);
	}

	function next():Void{
        switch (videoCallBack.toLowerCase())
        {
            case 'playstate':
                LoadingState.loadAndSwitchState(new PlayState(), true);
			case 'titlestate':
				MusicBeatState.switchState(new TitleState());
            case 'storymenu':
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
                MusicBeatState.switchState(new StoryMenuState());
            case 'cutscenemenu':
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
                MusicBeatState.switchState(new CutSceneMenu());
            default:
                LoadingState.loadAndSwitchState(new PlayState(), true);
        }
	}
}
