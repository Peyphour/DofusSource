package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.ChangeServer;
   import d2actions.ResetGame;
   import d2hooks.LoginQueueStatus;
   import d2hooks.QueueStatus;
   
   public class QueuePopup
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var lbl_text2:Label;
      
      public var btn_back:ButtonContainer;
      
      public function QueuePopup()
      {
         super();
      }
      
      public function main(param1:Array) : void
      {
         if(!param1)
         {
            param1 = [0,666,true];
         }
         this.sysApi.addHook(LoginQueueStatus,this.onLoginQueueStatus);
         this.sysApi.addHook(QueueStatus,this.onQueueStatus);
         if(param1[2])
         {
            this.updateLoginQueue(param1[0],param1[1]);
         }
         else
         {
            this.updateQueue(param1[0],param1[1]);
         }
      }
      
      public function unload() : void
      {
      }
      
      private function updateQueue(param1:uint, param2:uint) : void
      {
         this.lbl_text2.text = this.uiApi.getText("ui.queue.number",param1,param2) + "\n" + this.uiApi.getText("ui.queue.server",this.sysApi.getCurrentServer().name);
      }
      
      private function updateLoginQueue(param1:uint, param2:uint) : void
      {
         this.lbl_text2.text = this.uiApi.getText("ui.queue.number",param1,param2);
      }
      
      public function onLoginQueueStatus(param1:uint, param2:uint) : void
      {
         if(param1 < 1)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
         else
         {
            this.updateLoginQueue(param1,param2);
         }
      }
      
      public function onQueueStatus(param1:uint, param2:uint) : void
      {
         if(param1 < 1)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
         else
         {
            this.updateQueue(param1,param2);
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_back:
               if(!this.uiApi.getUi("serverSelection") && !this.uiApi.getUi("serverListSelection") && !this.uiApi.getUi("serverTypeSelection") && !this.uiApi.getUi("characterCreation"))
               {
                  this.sysApi.sendAction(new ResetGame());
               }
               else
               {
                  this.sysApi.sendAction(new ChangeServer());
               }
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         return false;
      }
   }
}
