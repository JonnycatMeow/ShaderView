import flixel.addons.display.FlxRuntimeShader;
import flixel.FlxSprite;
import haxe.Exception;
import sys.io.File;

var image:FlxSprite = new FlxSprite();
image.loadGraphic('assets/');
add(image);

FlxG.stage.window.onDropFile.add(function(path:String):Void
{
    try
    {
        image.shader = new FlxRuntimeShader(File.getContent(path));
    }
    catch (e:Exception)
        Log.warn(e.messege);
});