package cutscenes;

import states.charactermenus.CharMenuStory;
import flixel.FlxObject;

typedef TimedEvent = {
    var time:Float;
    var callback:Void->Void;
}

class DialogueCutscene extends MusicBeatSubstate
{
    var timer:Float = 0;
    var timedEvents:Array<TimedEvent> = [];

    // DEBUG THING
	var editMode:Bool = false;
	var editableSprite:FlxSprite;
	var lpo:Int = 700;

    var skid:FlxSprite;
    var midcutscene_cultist:FlxSprite;
    var sen_seq:FlxSprite;
    var eyes_Seq:FlxSprite;
    var lem:FlxSprite;

	public function new(cutsceneType:String)
	{
		super();

        var bg:FlxSprite = new FlxSprite();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

        switch(cutsceneType)
        {
            case 'incendio':
                Paths.setCurrentLevel('week4');

                var skyStars:BGSprite = new BGSprite('limo/Background_Stars', -320, -100, 0.1, 0.1);
				add(skyStars);

                midcutscene_cultist = new FlxSprite(121, 95);
                midcutscene_cultist.frames = Paths.getSparrowAtlas('dialoguecutscenes/midcutscene_cultist');
                midcutscene_cultist.animation.addByPrefix('idle', 'deadas hell', 24, false);
                midcutscene_cultist.scrollFactor.set();
                midcutscene_cultist.setGraphicSize(Std.int(1385));
                midcutscene_cultist.updateHitbox();
                add(midcutscene_cultist);

                eyes_Seq = new FlxSprite(-191, -341);
                eyes_Seq.frames = Paths.getSparrowAtlas('dialoguecutscenes/Eyes_Seq');
                eyes_Seq.animation.addByPrefix('idle', 'eyes cutscene seq', 24, false);
                eyes_Seq.scrollFactor.set();
                eyes_Seq.setGraphicSize(Std.int(1600));
                eyes_Seq.updateHitbox();
                add(eyes_Seq);

                lem = new FlxSprite(371, 186);
                lem.frames = Paths.getSparrowAtlas('dialoguecutscenes/Lem_Seq');
                lem.animation.addByPrefix('idle', 'lem cutscene seq', 24, false);
                lem.scrollFactor.set();
                lem.setGraphicSize(Std.int(540));
                lem.updateHitbox();
                add(lem);

                var limo:BGSprite = new BGSprite('limo/limoDrive', 108, 381, 1, 1, ['Limo stage'], true);
                limo.setGraphicSize(Std.int(1625));
                limo.updateHitbox();
                add(limo); //mfw I read the code and there are more of these, who knew?

                skid = new FlxSprite(63, -100);
                skid.frames = Paths.getSparrowAtlas('dialoguecutscenes/Skid_Sequence');
                skid.animation.addByPrefix('idle', 'skid cutscene seq', 24, false);
                skid.scrollFactor.set();
                skid.setGraphicSize(Std.int(660));
                skid.updateHitbox();
                add(skid);

                switch (CharMenuStory.bfmode)
                {
                    case 'sen-beta' | 'sen-beta-wind':
                        sen_seq = new FlxSprite(661, 110);
                        sen_seq.frames = Paths.getSparrowAtlas('dialoguecutscenes/Beta_Seq');
                        sen_seq.animation.addByPrefix('idle', 'beta cutscene seq ', 24, false);
                        sen_seq.scrollFactor.set();
                        sen_seq.setGraphicSize(Std.int(300));
                        sen_seq.updateHitbox();
                    case 'sen-alpha' | 'sen-alpha-wind':
                        sen_seq = new FlxSprite(648, 121);
                        sen_seq.frames = Paths.getSparrowAtlas('dialoguecutscenes/Alpha_Seq');
                        sen_seq.animation.addByPrefix('idle', 'alpha cutscene seq', 24, false);
                        sen_seq.scrollFactor.set();
                        sen_seq.setGraphicSize(Std.int(285));
                        sen_seq.updateHitbox();
                    default:
                        sen_seq = new FlxSprite(707, 165);
                        sen_seq.frames = Paths.getSparrowAtlas('dialoguecutscenes/Sen_Seq');
                        sen_seq.animation.addByPrefix('idle', 'sen cutscene seq', 24, false);
                        sen_seq.scrollFactor.set();
                        sen_seq.setGraphicSize(Std.int(255));
                        sen_seq.updateHitbox();
                }
                add(sen_seq);

                timedEvents = [
                {
                    time: 1,
                    callback: () ->
                    {
                        FlxG.sound.play(Paths.sound('mid_cutscene'), 0.4);

                        midcutscene_cultist.animation.play('idle');
                        sen_seq.animation.play('idle');
                        lem.animation.play('idle');
                        skid.animation.play('idle');
                        eyes_Seq.animation.play('idle');
                    }
                }, 
                {
                    time: 6,
                    callback: () ->
                    {
                        close();
                        PlayState.instance.afterCutsceneDialogue('week4');
                    }
                }
                ];
        }
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

		super.update(elapsed);
        timer += elapsed;

        if(timedEvents[0].time <= timer){
		    timedEvents[0].callback();
            timedEvents.shift();
        }
	}
}
