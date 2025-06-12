package states.stages.objects;

class BackGroundGoons extends FlxSprite
{
	var theOppsAreHere:Bool = true;
	var heyAnim:Bool = false;
	public function new(x:Float = 0, y:Float = 0, goonType:Int = 0)
	{
		super(x, y);

		switch (goonType)
		{
			case 0: //right
				frames = Paths.getSparrowAtlas('philly/Goon_Building_Right');
				animation.addByPrefix('idleGun', 'Right_Building_Goon_Gun_Idle', 24, false);
				animation.addByPrefix('trans' /*👎*/,  'Right_Building_Goon_Trans', 12, false);
				animation.addByPrefix('idle', 'Right_Building_Goon_Idle', 24, false);
				animation.addByPrefix('shoot', 'shoot LEFT', 12, false);
			case 1: //left
				frames = Paths.getSparrowAtlas('philly/Goon_Building_Left');
				animation.addByPrefix('idleGun', 'Left_Building_Goon_Gun_Idle', 24, false);
				animation.addByPrefix('trans' /*👎*/,  'Left_Building_Goon_Trans', 12, false);
				animation.addByPrefix('idle', 'Left_Building_Goon_Idle', 24, false);
				animation.addByPrefix('shoot', 'shoot UP', 12, false);
			case 2: //back right
				frames = Paths.getSparrowAtlas('philly/Goon_Back_Right');
				animation.addByPrefix('idleGun', 'goon_right_gun_idle', 24, false);
				animation.addByPrefix('trans' /*👎*/,  'goon_right_trans', 12, false);
				animation.addByPrefix('idle', 'goon_right_idle', 24, false);
				animation.addByPrefix('shoot', 'shoot DOWN', 12, false);
			case 3: //back left
				frames = Paths.getSparrowAtlas('philly/Goon_Back_Left');
				animation.addByPrefix('idleGun', 'goon_left_gun_idle', 24, false);
				animation.addByPrefix('trans' /*👎*/,  'goon_left_trans', 12, false);
				animation.addByPrefix('idle', 'goon_left_idle', 24, false);
				animation.addByPrefix('shoot', 'shoot RIGHT', 12, false);
		}
			
		swapDanceType(true);
		antialiasing = ClientPrefs.data.antialiasing;
		
		updateHitbox();
		scrollFactor.set(1, 1);
		animation.play('idle');
	}

	public function swapDanceType(firstTime:Bool):Void
	{
		if (firstTime) {
			theOppsAreHere = !theOppsAreHere;
			dance();
		} else {
			theOppsAreHere = !theOppsAreHere;
			if(!theOppsAreHere) { 
				animation.play('trans', true, true);
				animation.finishCallback = (aName:String) -> {
					dance();
				}
			} else { 
				animation.play('trans', true);
				animation.finishCallback = (aName:String) -> {
					dance();
				}
			}
			dance();
		} 
	}

	public function shootAnim():Void
	{
		heyAnim = true;
		animation.play('shoot', true);
		animation.finishCallback = (aName:String) -> {
			heyAnim = false;
		}
	}

	public function dance():Void
	{
		if (!heyAnim)
		{
			if (theOppsAreHere) {
				animation.play('idleGun', true);
			} else {
				animation.play('idle', true);
			}
		}
	}
}