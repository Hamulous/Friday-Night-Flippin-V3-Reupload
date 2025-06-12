package modchart;

import flixel.math.FlxAngle;
import modchart.events.CallbackEvent;
import modchart.*;

class Modcharts {
    static function numericForInterval(start, end, interval, func){
        var index = start;
        while(index < end){
            func(index);
            index += interval;
        }
    }

    static var songs = ["babysitting"];
	public static function isModcharted(songName:String){
		if (songs.contains(songName.toLowerCase()))
            return true;

        // add other conditionals if needed

        //return true; // turns modchart system on for all songs, only use for like.. debugging
        return false;
    }

    public static function loadModchart(modManager:ModManager, songName:String){
        switch (songName.toLowerCase()){
            case 'babysitting':
                modManager.setPercent("opponentSwap", 100);

            case 'decay':
                modManager.queueFunc(186, 188, function(event:CallbackEvent, cDS:Float){
                    var s = cDS - 928;
                    var beat = s / 4;
                    modManager.setValue("transformY", -30 * Math.abs(Math.sin(Math.PI * beat)), 0);
                });
                modManager.queueSet(186, "confusion", 270, 0);
                modManager.queueEase(186, 190, "confusion", 0, 'quadOut', 0);

                var beatbox = [];

                numericForInterval(192, 320, 4, function(i){
                    beatbox.push(i);
                });

                var m = 1;
                for(i in 0...beatbox.length){
                    m = m * -1;
                    var step = beatbox[i];
                    var wow = i % 2;
                    if (wow==0) {
                        modManager.queueSet(step, 'transformX', -50);
                    }else if(wow == 1){
                        modManager.queueSet(step, 'transformX', 50);
                    }
                    modManager.queueSetP(step, 'tipsy', 25);
                    modManager.queueSetP(step, 'tipsyOffset', 5);
                    modManager.queueEase(step, step + 4, 'transformX', 0, 'cubeOut');
                    modManager.queueEaseP(step, step + 4, 'tipsy', 0, 'cubeOut');
                    modManager.queueEaseP(step, step + 4, 'tipsyOffset', 0, 'cubeOut');
                }

                modManager.queueSet(443, "confusion", 270, 0);
                modManager.queueEase(443, 447, "confusion", 0, 'quadOut', 0);

                var beatbox2 = [];

                numericForInterval(448, 576, 4, function(i){
                    beatbox2.push(i);
                });

                var m = 1;
                for(i in 0...beatbox2.length){
                    m = m * -1;
                    var step = beatbox2[i];
                    var wow = i % 2;
                    if (wow==0) {
                        modManager.queueSet(step, 'transformX', -50);
                    }else if(wow == 1){
                        modManager.queueSet(step, 'transformX', 50);
                    }
                    modManager.queueSetP(step, 'tipsy', 25);
                    modManager.queueSetP(step, 'tipsyOffset', 5);
                    modManager.queueEase(step, step + 4, 'transformX', 0, 'cubeOut');
                    modManager.queueEaseP(step, step + 4, 'tipsy', 0, 'cubeOut');
                    modManager.queueEaseP(step, step + 4, 'tipsyOffset', 0, 'cubeOut');
                }

                modManager.queueEase(566, 569, "bounce", 4, "quadInOut", 0);
                modManager.queueEase(569, 576, "bounce", 0, "quadInOut", 0);
           
            default:

        }
    }
}