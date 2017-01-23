package ui
{
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightJoin;
   import d2hooks.GameFightStart;
   import d2hooks.SpectatorWantLeave;
   import ui.enums.ContextEnum;
   
   public class ContextAwareUi
   {
       
      
      public var sysApi:SystemApi;
      
      private var _currentContext:String = "roleplay";
      
      public function ContextAwareUi()
      {
         super();
      }
      
      public function main(param1:Array) : void
      {
         this.sysApi.addHook(GameFightJoin,this.onGameFightJoin);
         this.sysApi.addHook(GameFightStart,this.onGameFightStart);
         this.sysApi.addHook(GameFightEnd,this.onGameFightEnd);
         this.sysApi.addHook(SpectatorWantLeave,this.onSpectatorWantLeave);
      }
      
      public function get currentContext() : String
      {
         return this._currentContext;
      }
      
      public function set currentContext(param1:String) : void
      {
         this._currentContext = param1;
      }
      
      protected function changeContext(param1:String) : void
      {
         var _loc2_:* = this._currentContext != param1;
         var _loc3_:String = this._currentContext;
         this._currentContext = param1;
         this.onContextChanged(param1,_loc3_,_loc2_);
      }
      
      protected function onContextChanged(param1:String, param2:String = "", param3:Boolean = false) : void
      {
      }
      
      public function onGameFightJoin(param1:Boolean, param2:Boolean, param3:Boolean, param4:int, param5:int, param6:Boolean) : void
      {
         if(param3)
         {
            this.changeContext(ContextEnum.SPECTATOR);
         }
         else if(!param4)
         {
            this.onGameFightStart();
         }
         else
         {
            this.changeContext(ContextEnum.PREFIGHT);
         }
      }
      
      public function onGameFightEnd(param1:Object) : void
      {
         this.changeContext(ContextEnum.ROLEPLAY);
      }
      
      public function onSpectatorWantLeave() : void
      {
         this.changeContext(ContextEnum.ROLEPLAY);
      }
      
      public function onGameFightStart() : void
      {
         if(this._currentContext != ContextEnum.SPECTATOR)
         {
            this.changeContext(ContextEnum.FIGHT);
         }
      }
   }
}
