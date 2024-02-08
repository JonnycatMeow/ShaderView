package;

import flixel.FlxG;
import flixel.FlxGame;
import haxe.CallStack;
import haxe.Exception;
import haxe.Log;
import lime.system.System;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.Lib;
import sys.io.File;
import sys.FileSystem;

using StringTools;

class Main extends Sprite
{
	public function new():Void
	{
		super();

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);

		addChild(new FlxGame(1280, 720, ShaderWeb, 60, 60));
	}

	private inline function onUncaughtError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();
		event.stopImmediatePropagation();

		final log:Array<String> = [];

		if (Std.isOfType(event.error, Error))
			log.push(cast(event.error, Error).message);
		else if (Std.isOfType(event.error, ErrorEvent))
			log.push(cast(event.error, ErrorEvent).text);
		else
			log.push(Std.string(event.error));

		for (item in CallStack.exceptionStack(true))
		{
			switch (item)
			{
				case CFunction:
					log.push('C Function');
				case Module(m):
					log.push('Module [$m]');
				case FilePos(s, file, line, column):
					log.push('$file [line $line]');
				case Method(classname, method):
					log.push('$classname [method $method]');
				case LocalFunction(name):
					log.push('Local Function [$name]');
			}
		}

		final msg:String = log.join('\n');

		try
		{
			if (!FileSystem.exists('errors'))
				FileSystem.createDirectory('errors');

			File.saveContent('errors/' + Date.now().toString().replace(' ', '-').replace(':', "'") + '.txt', msg);
		}
		catch (e:Exception)
			Log.trace('Couldn\'t save error message "${e.message}"', null);

		Log.trace(msg, null);
		Lib.application.window.alert(msg, 'Error!');
		System.exit(1);
	}
}
