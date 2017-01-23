package com.ankamagames.dofus.console.moduleLogger
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.console.moduleLUA.ConsoleLUA;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.utils.benchmark.monitoring.FpsManagerUtils;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   
   public final class ModuleDebugManager
   {
      
      private static const WIDTH:int = 220;
      
      private static const HEIGHT:int = 42;
      
      private static var _ui:Sprite;
      
      private static var _fpsShape:Shape;
      
      private static var _textField:TextField;
      
      private static var _lastSecond:int;
      
      private static var _numImages:int;
      
      private static var _offSetX:int;
      
      private static var _offSetY:int;
      
      private static var _valuesList:Vector.<int> = new Vector.<int>();
      
      private static var _lastValue:int = 0;
      
      private static var _console1:ConsoleIcon;
      
      private static var _console2:ConsoleIcon;
      
      private static var _console3:ConsoleIcon;
       
      
      public function ModuleDebugManager()
      {
         super();
      }
      
      public static function display(param1:Boolean, param2:Boolean = true) : void
      {
         if(param1)
         {
            if(!_ui)
            {
               createUI(param2);
            }
            StageShareManager.stage.addChild(_ui);
            _fpsShape.graphics.clear();
            _valuesList.length = 0;
            _lastValue = _lastSecond = getTimer();
            StageShareManager.stage.addEventListener(Event.ENTER_FRAME,loop);
         }
         else if(_ui && _ui.parent)
         {
            _ui.parent.removeChild(_ui);
         }
      }
      
      public static function get isDisplayed() : Boolean
      {
         return _ui && _ui.parent;
      }
      
      private static function loop(param1:Event) : void
      {
         if(!_ui.stage)
         {
            StageShareManager.stage.removeEventListener(Event.ENTER_FRAME,loop);
            return;
         }
         var _loc2_:int = getTimer();
         if(_loc2_ - _lastSecond > 1000)
         {
            _textField.htmlText = "<font color=\'#7C87D1\'>FPS: " + _numImages + " / " + _ui.stage.frameRate + "</font>\n<font color=\'#00BBBB\'>MEM: " + FpsManagerUtils.calculateMB(System.totalMemory).toPrecision(4) + " / " + FpsManagerUtils.calculateMB(System.privateMemory).toPrecision(4) + " MB</font>";
            _numImages = 0;
            _lastSecond = _loc2_;
         }
         else
         {
            _numImages++;
         }
         var _loc3_:int = _loc2_ - _lastValue;
         _valuesList.push(-_loc3_);
         if(_valuesList.length > WIDTH)
         {
            _valuesList.shift();
         }
         _lastValue = _loc2_;
         _fpsShape.graphics.clear();
         _fpsShape.graphics.lineStyle(1,16777215,1,true);
         _fpsShape.graphics.moveTo(0,_valuesList[0]);
         var _loc4_:int = _valuesList.length;
         var _loc5_:int = 0;
         while(++_loc5_ < _loc4_)
         {
            _fpsShape.graphics.lineTo(_loc5_,_valuesList[_loc5_]);
         }
      }
      
      private static function createUI(param1:Boolean) : void
      {
         if(_ui)
         {
            throw new Error();
         }
         _ui = new Sprite();
         _ui.x = _ui.y = 100;
         _fpsShape = new Shape();
         _ui.addChild(_fpsShape);
         _fpsShape.y = 20;
         var _loc2_:Sprite = new Sprite();
         _loc2_.doubleClickEnabled = true;
         _ui.addChild(_loc2_);
         _loc2_.graphics.beginFill(0,0.7);
         _loc2_.graphics.lineTo(0,HEIGHT);
         _loc2_.graphics.lineTo(WIDTH,HEIGHT);
         _loc2_.graphics.lineTo(WIDTH,0);
         _loc2_.graphics.endFill();
         _loc2_.graphics.lineStyle(2);
         _loc2_.graphics.moveTo(0,0);
         _loc2_.graphics.lineTo(0,HEIGHT);
         _loc2_.graphics.lineTo(WIDTH,HEIGHT);
         _loc2_.graphics.lineTo(WIDTH,0);
         _textField = new TextField();
         _textField.y = 2;
         _ui.addChild(_textField);
         _textField.multiline = true;
         _textField.wordWrap = false;
         _textField.mouseEnabled = false;
         _textField.width = WIDTH;
         _textField.height = HEIGHT;
         var _loc3_:TextFormat = new TextFormat("Verdana",14,12763866);
         _loc3_.leading = 2;
         _textField.defaultTextFormat = _loc3_;
         if(param1)
         {
            _console1 = new ConsoleIcon("screen",16,"Open/close Module Console");
            _console1.x = WIDTH - (_console1.width + 2);
            _console1.y = HEIGHT - (_console1.height * 2 + 4);
            _console1.addEventListener(MouseEvent.MOUSE_DOWN,onOpenConsole);
            _ui.addChild(_console1);
            _console2 = new ConsoleIcon("terminal",16,"Open/close Console");
            _console2.x = WIDTH - (_console2.width + 2);
            _console2.y = HEIGHT - (_console2.height + 2);
            _console2.addEventListener(MouseEvent.MOUSE_DOWN,onOpenLogConsole);
            _ui.addChild(_console2);
            _console3 = new ConsoleIcon("script",16,"Open/close LUA Console");
            _console3.x = WIDTH - (_console3.width + 2) * 2;
            _console3.y = HEIGHT - (_console3.height + 2);
            _console3.addEventListener(MouseEvent.MOUSE_DOWN,onOpenLuaConsole);
            _ui.addChild(_console3);
         }
         _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         _loc2_.addEventListener(MouseEvent.DOUBLE_CLICK,onMouseDoubleClick);
      }
      
      private static function onOpenLogConsole(param1:Event) : void
      {
         KernelEventsManager.getInstance().processCallback(HookList.ToggleConsole);
      }
      
      private static function onOpenConsole(param1:Event) : void
      {
         Console.getInstance().chatMode = false;
         Console.getInstance().toggleDisplay();
      }
      
      private static function onOpenLuaConsole(param1:Event) : void
      {
         ConsoleLUA.getInstance().toggleDisplay();
      }
      
      private static function onMouseDown(param1:Event) : void
      {
         _offSetX = _ui.mouseX;
         _offSetY = _ui.mouseY;
         _ui.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
         _ui.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      private static function onMouseUp(param1:Event) : void
      {
         _ui.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
         _ui.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      private static function onMouseMove(param1:MouseEvent) : void
      {
         _ui.x = _ui.stage.mouseX - _offSetX;
         _ui.y = _ui.stage.mouseY - _offSetY;
         param1.updateAfterEvent();
      }
      
      private static function onMouseDoubleClick(param1:MouseEvent) : void
      {
         System.gc();
      }
   }
}
