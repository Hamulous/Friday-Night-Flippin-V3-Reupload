package cutscenes;

import haxe.Json;
import openfl.utils.Assets;

import objects.TypedAlphabet;
import cutscenes.DialogueCharacter;

import flixel.addons.text.FlxTypeText;

typedef DialogueFile = {
	var dialogue:Array<DialogueLine>;
}

typedef DialogueLine = {
	var portrait:Null<String>;
	var expression:Null<String>;
	var text:Null<String>;
	var image:Null<String>;
	var boximage:Null<String>;
	var speed:Null<Float>;
	var sound:Null<String>;
	var textColor:Null<String>;
}

class DialogueBoxPsych extends FlxSpriteGroup
{
	public static var DEFAULT_TEXT_X = 175;
	public static var DEFAULT_TEXT_Y = 460;
	public static var LONG_TEXT_ADD = 24;
	var scrollSpeed = 4000;

	var dialogue:TypedAlphabet;
	var dialogueList:DialogueFile = null;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;
	var bgSprite:BGSprite = null;
	var box:FlxSprite;
	var textToType:String = '';

	var arrayCharacters:Array<DialogueCharacter> = [];

	var currentText:Int = 0;
	var offsetPos:Float = -600;
	
	var curCharacter:String = "";

	var curDialogue:DialogueLine = null;

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var dropText:FlxText;
	public var swagDialogue:FlxTypeText;

	var scoreText:FlxText;
	var scoreText2:FlxText;

	public function new(dialogueList:DialogueFile, ?song:String = null, ?songVolume:Float = 1)
	{
		super();
		scoreText = new FlxText(695, 680, 0, "Press Q to skip all dialogue", 36);
		scoreText.setFormat("VCR OSD Mono", 32);
		scoreText2 = new FlxText(697, 682, 0, "Press Q to skip all dialogue", 36);
		scoreText2.setFormat("VCR OSD Mono", 32, FlxColor.BLUE);

		if(song != null && song != '') {
			FlxG.sound.playMusic(Paths.music(song), 0);
			FlxG.sound.music.fadeIn(2, 0, songVolume);
		}

		bgSprite = new BGSprite(null, -514, -280);
		bgSprite.scale.set(0.6, 0.6);
		bgSprite.visible = true;
		add(bgSprite);

		this.dialogueList = dialogueList;
		spawnCharacters();

		box = new FlxSprite(50, 50);
		box.antialiasing = ClientPrefs.data.antialiasing;
		box.scrollFactor.set();
		box.visible = false;
		add(box);

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(Std.parseFloat(CoolUtil.coolTextFile(Paths.getSharedPath('images/portraits/DialogueSetup.txt'))[2].split(":")[1]), Std.parseFloat(CoolUtil.coolTextFile(Paths.getSharedPath('images/portraits/DialogueSetup.txt'))[3].split(":")[1]), Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFFD89494;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);
		add(scoreText);
		add(scoreText2);

		funnyAlphaLoop();
		startNextDialog();
	}

	var dialogueStarted:Bool = false;
	var dialogueEnded:Bool = false;

	public static var LEFT_CHAR_X:Float = -60;
	public static var RIGHT_CHAR_X:Float = -100;
	public static var DEFAULT_CHAR_Y:Float = 60;

	function spawnCharacters() {
		var charsMap:Map<String, Bool> = new Map<String, Bool>();
		for (i in 0...dialogueList.dialogue.length) {
			if(dialogueList.dialogue[i] != null) {
				var charToAdd:String = dialogueList.dialogue[i].portrait;
				if(!charsMap.exists(charToAdd) || !charsMap.get(charToAdd)) {
					charsMap.set(charToAdd, true);
				}
			}
		}

		for (individualChar in charsMap.keys()) {
			var x:Float = LEFT_CHAR_X;
			var y:Float = DEFAULT_CHAR_Y;
			var char:DialogueCharacter = new DialogueCharacter(x + offsetPos, y, individualChar);
			char.setGraphicSize(Std.int(char.width * DialogueCharacter.DEFAULT_SCALE * char.jsonFile.scale));
			char.updateHitbox();
			char.scrollFactor.set();
			add(char);

			var saveY:Bool = false;
			switch(char.jsonFile.dialogue_pos) {
				case 'center':
					char.x = FlxG.width / 2;
					char.x -= char.width / 2;
					y = char.y;
					char.y = FlxG.height + 50;
					saveY = true;
				case 'right':
					x = FlxG.width - char.width + RIGHT_CHAR_X;
					char.x = x - offsetPos;
			}
			x += char.jsonFile.position[0];
			y += char.jsonFile.position[1];
			char.x += char.jsonFile.position[0];
			char.y += char.jsonFile.position[1];
			char.startingPos = (saveY ? y : x);
			arrayCharacters.push(char);
		}
	}

	var ignoreThisFrame:Bool = true; //First frame is reserved for loading dialogue images

	public var closeSound:String = 'clickText';
	public var closeVolume:Float = 0.8;
	var targetnumalpha:Float = 0;
	
	override function update(elapsed:Float)
	{
		scoreText2.alpha = scoreText.alpha;

		if (FlxG.keys.justPressed.Q)
		{
			dialogueEnded = true;
			FlxG.sound.music.fadeOut(1, 0);
			FlxG.sound.play(Paths.sound(closeSound), closeVolume);
			if(skipDialogueThing != null) {
				skipDialogueThing();
			}
		}

		dropText.text = swagDialogue.text;

		if(ignoreThisFrame) {
			ignoreThisFrame = false;
			super.update(elapsed);
			return;
		}

		if(!dialogueEnded) {
			if(Controls.instance.ACCEPT) {
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}

				if(currentText >= dialogueList.dialogue.length) {
					dialogueEnded = true;
					FlxG.sound.music.fadeOut(1, 0);
				} else {
					startNextDialog();
				}
				FlxG.sound.play(Paths.sound(closeSound), closeVolume);
			}

			if(lastCharacter != -1 && arrayCharacters.length > 0) {
				for (i in 0...arrayCharacters.length) {
					var char = arrayCharacters[i];
					if(char != null) {
						if(i != lastCharacter) {
							switch(char.jsonFile.dialogue_pos) {
								case 'left':
									char.x = char.startingPos + offsetPos;
								case 'center':
									char.y = char.startingPos + FlxG.height;
								case 'right':
									char.x = char.startingPos - offsetPos;
							}
						} else {
							switch(char.jsonFile.dialogue_pos) {
								case 'left':
									char.x = char.startingPos;
								case 'center':
									char.y = char.startingPos;
								case 'right':
									char.x = char.startingPos;
							}
						}
					}
				}
			}
		} else { //Dialogue ending
			if(box != null) {
				box.kill();
				remove(box);
				box.destroy();
				box = null;
			}

			if(bgSprite != null) {
				bgSprite.alpha -= 0.5 * elapsed;
				if(bgSprite.alpha <= 0) {
					bgSprite.kill();
					remove(bgSprite);
					bgSprite.destroy();
					bgSprite = null;
				}
			}

			for (i in 0...arrayCharacters.length) {
				var leChar:DialogueCharacter = arrayCharacters[i];
				if(leChar != null) {
					switch(arrayCharacters[i].jsonFile.dialogue_pos) {
						case 'left':
							leChar.x -= scrollSpeed * elapsed;
						case 'center':
							leChar.y += scrollSpeed * elapsed;
						case 'right':
							leChar.x += scrollSpeed * elapsed;
					}
				}
			}

			if(box == null) {
				for (i in 0...arrayCharacters.length) {
					var leChar:DialogueCharacter = arrayCharacters[0];
					if(leChar != null) {
						arrayCharacters.remove(leChar);
						leChar.kill();
						remove(leChar);
						leChar.destroy();
					}
				}
				finishThing();
				kill();
			}
		}

		if (swagDialogue._typing && curDialogue.text != ' …' && curDialogue.text != ' ...')
		{
			var char:DialogueCharacter = arrayCharacters[lastCharacter];
			if(char != null && char.animation.curAnim != null && char.animation.finished) {
				char.animation.curAnim.restart();
			}
		}
		else if (!swagDialogue._typing)
		{
			var char:DialogueCharacter = arrayCharacters[lastCharacter];
			if(char != null && char.animation.curAnim != null && char.animationIsLoop() && char.animation.finished) {
				char.playAnim(char.animation.curAnim.name, true);
			}
		}

		super.update(elapsed);
	}

	var lastCharacter:Int = -1;
	function startNextDialog():Void
	{
		do {
			curDialogue = dialogueList.dialogue[currentText];
		} while(curDialogue == null);

		if(curDialogue.text == null || curDialogue.text.length < 1) curDialogue.text = ' ';
		if(curDialogue.boximage != null)
		{
			remove(box);
			box.loadGraphic(Paths.image('portraits/'+curDialogue.boximage+'/box'));
			add(box);
		} 
		if(curDialogue.speed == null || Math.isNaN(curDialogue.speed)) curDialogue.speed = 0.05;
		if(curDialogue.image != null)
		{
			bgSprite.loadGraphic(Paths.image(curDialogue.image), 'shared');
			bgSprite.setGraphicSize(1408);
			bgSprite.updateHitbox();
			bgSprite.setPosition(-120, -40);
			bgSprite.scrollFactor.set();
			bgSprite.visible = true;
		}
		if (curDialogue.textColor == null) curDialogue.textColor = '0x000000';
			
		dropText.color = CoolUtil.colorFromString(curDialogue.textColor);

		var character:Int = 0;
		box.visible = true;
		for (i in 0...arrayCharacters.length) {
			if(arrayCharacters[i].curCharacter == curDialogue.portrait) {
				character = i;
				break;
			}
		}
		var centerPrefix:String = '';
		var lePosition:String = arrayCharacters[character].jsonFile.dialogue_pos;
		if(lePosition == 'center') centerPrefix = 'center-';

		lastCharacter = character;

		swagDialogue.color = FlxColor.BLACK;
		swagDialogue.delay = curDialogue.speed;
		if (curDialogue.sound == "" || curDialogue.sound == null) {
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue'), 0.6)];
		} else {
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dialogue/'+curDialogue.sound+'-0'+FlxG.random.int(1,5)), 0.6)];
		}
			
		swagDialogue.resetText(curDialogue.text); 
		swagDialogue.start(curDialogue.speed, true);

		var char:DialogueCharacter = arrayCharacters[character];
		if(char != null) {
			if (curDialogue.boximage == 'silhouette')
				char.visible = false;
			else 
				char.visible = true;

			if (!swagDialogue._typing) {
				char.playAnim(curDialogue.expression, true);
			} else {
				char.playAnim(curDialogue.expression, false);
			}
		
			if(char.animation.curAnim != null) {
				var rate:Float = 24 - (((curDialogue.speed - 0.05) / 5) * 480);
				if(rate < 12) rate = 12;
				else if(rate > 48) rate = 48;
				char.animation.curAnim.frameRate = rate;
			}
		}
		currentText++;

		if(nextDialogueThing != null) {
			nextDialogueThing();
		}
	}

	public static function parseDialogue(path:String):DialogueFile {
		return cast Json.parse(Assets.getText(path));
	}

	function funnyAlphaLoop():Void
	{
		FlxTween.tween(scoreText, {alpha: targetnumalpha}, 0.7, {ease: FlxEase.quintOut,
		onComplete: function(twn:FlxTween)
		{
			if (targetnumalpha == 0)
			targetnumalpha = 1;
			else if (targetnumalpha == 1)
			targetnumalpha = 0;
			funnyAlphaLoop();
		}});
	}
}