package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.TimelineEntityOut;
   import d2actions.TimelineEntityOver;
   import d2enums.ComponentHookList;
   import d2hooks.ShowSwapPositionRequestMenu;
   
   public class SwapPositionIcon
   {
       
      
      private var _requestId:uint;
      
      private var _isRequester:Boolean;
      
      private var _entityId:Number;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var tx_icon:Texture;
      
      public function SwapPositionIcon()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this._requestId = param1.requestId;
         this._isRequester = param1.isRequester;
         this._entityId = param1.entityId;
         this.tx_icon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("icons_uri") + (!!this._isRequester?"swapRequested":"swapRequest"));
         this.tx_icon.handCursor = true;
         this.uiApi.addComponentHook(this.tx_icon,ComponentHookList.ON_RELEASE);
         if(param1.rollEvents)
         {
            this.uiApi.addComponentHook(this.tx_icon,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(this.tx_icon,ComponentHookList.ON_ROLL_OUT);
         }
      }
      
      public function unload() : void
      {
         if(this.uiApi.getUi("swapPositionMenu"))
         {
            this.modContextMenu.closeAllMenu();
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.tx_icon)
         {
            this.sysApi.dispatchHook(ShowSwapPositionRequestMenu,this._requestId,this._isRequester);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         if(param1 == this.tx_icon)
         {
            this.sysApi.sendAction(new TimelineEntityOver(this._entityId,true,false));
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         if(param1 == this.tx_icon)
         {
            this.sysApi.sendAction(new TimelineEntityOut(this._entityId));
         }
      }
   }
}
