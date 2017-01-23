package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.PartInfo;
   
   public class UnavailableCharacterPopup
   {
      
      public static const PART_NOT_INSTALLED:uint = 0;
      
      public static const PART_BEING_UPDATER:uint = 1;
      
      public static const PART_UP_TO_DATE:uint = 2;
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public const UI_STATE_UNAVAILABLE:uint = 0;
      
      public const UI_STATE_AVAILABLE:uint = 1;
      
      public var _state:uint;
      
      public var _downloadUi:Object;
      
      public var tx_progressBar:Texture;
      
      public var tx_progressBarBackground:Texture;
      
      public var lbl_title:Label;
      
      public var lbl_text:Label;
      
      public var lbl_progress:Label;
      
      public var btn_lbl_btn_back:Label;
      
      public var btn_close:ButtonContainer;
      
      public var btn_back:ButtonContainer;
      
      public function UnavailableCharacterPopup()
      {
         super();
      }
      
      public function set state(param1:uint) : void
      {
         this._state = this.state;
         switch(this.state)
         {
            case this.UI_STATE_UNAVAILABLE:
               this.lbl_title.text = this.uiApi.getText("ui.split.unavailableCharacter");
               this.lbl_text.text = this.uiApi.getText("ui.split.unavailableCharacterText");
               this.btn_lbl_btn_back.text = this.uiApi.getText("ui.common.back");
               break;
            case this.UI_STATE_AVAILABLE:
               this.lbl_title.text = this.uiApi.getText("ui.split.availableCharacter");
               this.lbl_text.text = this.uiApi.getText("ui.split.availableCharacterText");
               this.btn_lbl_btn_back.text = this.uiApi.getText("ui.common.restart");
         }
      }
      
      public function get state() : uint
      {
         return this._state;
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(PartInfo,this.onPartInfo);
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addComponentHook(this.btn_back,"onRelease");
         this.state = this.UI_STATE_UNAVAILABLE;
         this.updateProgressBar(0);
         var _loc2_:Object = this.uiApi.getUi("downloadUi");
         if(_loc2_)
         {
            this._downloadUi = _loc2_.uiClass;
            this._downloadUi.visible = false;
         }
      }
      
      public function unload() : void
      {
         if(this._downloadUi)
         {
            this._downloadUi.visible = true;
         }
      }
      
      public function onPartInfo(param1:Object, param2:Number) : void
      {
         if(param1.state == PART_BEING_UPDATER)
         {
            this.updateProgressBar(int(param2));
         }
         else if(param1.state == PART_UP_TO_DATE)
         {
            this.updateProgressBar(100);
            this.state = this.UI_STATE_AVAILABLE;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_back:
               if(this.state == this.UI_STATE_UNAVAILABLE)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else if(this.state == this.UI_STATE_AVAILABLE)
               {
                  this.sysApi.reset();
               }
         }
      }
      
      public function updateProgressBar(param1:uint) : void
      {
         this.tx_progressBar.width = this.tx_progressBarBackground.width * param1 / 100;
         this.lbl_progress.text = param1 + "%";
      }
   }
}
