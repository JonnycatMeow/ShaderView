package;

import flixel.addons.display.FlxRuntimeShader;
import flixel.FlxSprite;
import flixel.FlxState;
import haxe.Exception;
import sys.io.File;

class ShaderWeb extends FlxState
{
    override public function create()
    {
        var image:FlxSprite = new FlxSprite();
        image.loadGraphic('your image');
        add(image);

        FlxG.stage.window.onDropFile.add(function(path:String):Void {
            try
            {
                image.shader = new FlxRuntimeShader(File.getContent(path));
            }
            catch (e:Exception)
                Log.warn(e.message);
        });

        super.create();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}
