package states.stages;

#if !flash
import openfl.filters.ShaderFilter;
import shaders.BloomShader;
#end

class Yard extends BaseStage
{
	var lockcam:Bool = true;

	var bloom:BloomShader;

	override function create()
	{
		game.useDirectionalCamera = false;

		var sky:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image("sky"));
		sky.setGraphicSize(Std.int(sky.width * 1.3));
		sky.updateHitbox();
		add(sky);
		
		var wall:FlxSprite = new FlxSprite(-200, 100).loadGraphic(Paths.image("Wall"));
		wall.setGraphicSize(Std.int(wall.width * 1.3));
		wall.updateHitbox();
		add(wall);

		var grass:FlxSprite = new FlxSprite(-200, 405).loadGraphic(Paths.image("Grass-shit"));
		grass.setGraphicSize(Std.int(grass.width * 1.3));
		grass.updateHitbox();
		add(grass);

		var plants:FlxSprite = new FlxSprite(-200, 0).loadGraphic(Paths.image("Plants"));
		plants.setGraphicSize(Std.int(plants.width * 1.3));
		plants.updateHitbox();
		add(plants);

		bloom = new BloomShader();
		camGame.setFilters([new ShaderFilter(bloom)]);
	}

	override function update(elapsed:Float)
	{
		if (bloom != null) {
			bloom.data.intensity.value = [bloom.shaderintensity];
			bloom.data.blurSize.value = [bloom.shaderblurSize];
		} 

		if (lockcam) game.triggerEvent('Camera Follow Pos', '730', '435', 0);
	}
}