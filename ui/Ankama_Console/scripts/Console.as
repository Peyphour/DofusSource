package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.StrataEnum;
   import d2hooks.ToggleConsole;
   import d2hooks.UiLoaded;
   import flash.display.Sprite;
   import ui.ConsoleUi;
   
   public class Console extends Sprite
   {
      
      private static var _self:Console;
       
      
      protected var console:ConsoleUi = null;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      private var _consoleState:Boolean;
      
      private var _waitingCmd:Array;
      
      public function Console()
      {
         this._waitingCmd = [];
         super();
      }
      
      public static function getInstance() : Console
      {
         return _self;
      }
      
      public function main() : void
      {
         _self = this;
         this.uiApi.addShortcutHook("toggleConsole",this.onConsoleToggle);
         this.sysApi.addHook(ToggleConsole,this.onHookConsoleToggle);
      }
      
      public function showConsole(param1:Boolean) : void
      {
         var _loc2_:Object = this.uiApi.getUi("console");
         if(_loc2_)
         {
            this._consoleState = _loc2_.visible = param1;
            if(param1)
            {
               ConsoleUi(_loc2_.uiClass).updateInfo();
               this.uiApi.getUi("console").uiClass.setFocus();
            }
            else
            {
               this.sysApi.removeFocus();
            }
         }
         else
         {
            this.uiApi.loadUi("console","console",[param1],StrataEnum.STRATA_TOP);
            this._consoleState = param1;
         }
      }
      
      public function addCommande(param1:String, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Object = this.uiApi.getUi("console");
         if(_loc4_)
         {
            if(param3)
            {
               this.showConsole(true);
            }
            ConsoleUi(_loc4_.uiClass).addCmd(param1,param2,param3);
         }
         else
         {
            this._waitingCmd.push({
               "cmd":param1,
               "send":param2,
               "openConsole":param3
            });
            this.sysApi.addHook(UiLoaded,this.onUiLoaded);
            this.showConsole(false);
         }
      }
      
      private function onAuthentificationStart(param1:Boolean) : void
      {
         this.showConsole(false);
      }
      
      private function onConsoleToggle(param1:String) : Boolean
      {
         var _loc2_:String = this.sysApi.getConfigEntry("config.boo");
         if(!this.sysApi.hasRight() && !_loc2_)
         {
            return false;
         }
         if(param1 != "toggleConsole")
         {
            return true;
         }
         if(this._consoleState)
         {
            this.showConsole(false);
         }
         else
         {
            this.showConsole(true);
         }
         return false;
      }
      
      private function onHookConsoleToggle() : void
      {
         var _loc1_:String = this.sysApi.getConfigEntry("config.boo");
         if(!this.sysApi.hasRight() && !_loc1_ && !this.sysApi.isDevMode())
         {
            return;
         }
         if(this._consoleState)
         {
            this.showConsole(false);
         }
         else
         {
            this.showConsole(true);
         }
      }
      
      private function onUiLoaded(param1:String) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ConsoleUi = null;
         if(param1 == "console")
         {
            this.sysApi.removeHook(UiLoaded);
            _loc2_ = 0;
            while(_loc2_ < this._waitingCmd.length)
            {
               this.addCommande(this._waitingCmd[_loc2_].cmd,this._waitingCmd[_loc2_].send,this._waitingCmd[_loc2_].openConsole);
               _loc2_++;
            }
            _loc3_ = this.uiApi.getUi("console").uiClass;
            this.uiApi.getUi("console").visible = this._consoleState;
            this._waitingCmd = [];
         }
      }
   }
}
