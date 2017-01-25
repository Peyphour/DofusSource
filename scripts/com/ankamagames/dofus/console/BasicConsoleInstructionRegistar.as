package com.ankamagames.dofus.console
{
   import com.ankamagames.dofus.console.debug.ActionsInstructionHandler;
   import com.ankamagames.dofus.console.debug.DisplayMapInstructionHandler;
   import com.ankamagames.dofus.console.debug.FrameInstructionHandler;
   import com.ankamagames.dofus.console.debug.LuaInstructionHandler;
   import com.ankamagames.dofus.console.debug.MiscInstructionHandler;
   import com.ankamagames.dofus.console.debug.SoundInstructionHandler;
   import com.ankamagames.dofus.console.debug.UiHandlerInstructionHandler;
   import com.ankamagames.dofus.console.debug.VersionInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.console.ConsoleInstructionRegistar;
   
   public class BasicConsoleInstructionRegistar implements ConsoleInstructionRegistar
   {
       
      
      public function BasicConsoleInstructionRegistar()
      {
         super();
      }
      
      public function registerInstructions(param1:ConsoleHandler) : void
      {
         param1.addHandler("version",new VersionInstructionHandler());
         param1.addHandler("mapid",new DisplayMapInstructionHandler());
         param1.addHandler(["savereplaylog"],new MiscInstructionHandler());
         param1.addHandler(["uiinspector","inspectuielement","autoreloadui","loadui","unloadui","clearuicache","resetuisavedusermodification","getthemefingerprint","clearthemedata","clearcsscache","cleartooltipcache","useuicache","uilist","reloadui","modulelist","debugwebreader"],new UiHandlerInstructionHandler());
         param1.addHandler(["framelist","framepriority"],new FrameInstructionHandler());
         param1.addHandler(["sendaction","listactions","sendhook"],new ActionsInstructionHandler());
         param1.addHandler(["adduisoundelement"],new SoundInstructionHandler());
         param1.addHandler(["lua","luarecorder"],new LuaInstructionHandler());
      }
   }
}
