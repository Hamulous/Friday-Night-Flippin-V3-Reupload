package objects;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class FreeplayIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var char:String = '';

	public function new(char:String = 'lem')
	{
		super();
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x - 180, sprTracker.y - 45);
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'freeplay/freeplay_icon_' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'freeplay/freeplay_icon_' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'freeplay/freeplay_icon_lem'; //Prevents crash from missing icon

			frames = Paths.getSparrowAtlas('freeplay/freeplay_icon_' + char);

			iconOffsets[0] = (width - 150) / 2;
			iconOffsets[1] = (width - 150) / 2;
			iconOffsets[2] = (width - 150) / 2;
			updateHitbox();

			animation.addByPrefix(char, char + ' icon', 24);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.data.antialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}