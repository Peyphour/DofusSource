package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.DownloadError;
   import d2hooks.PartInfo;
   
   public class DownloadUi
   {
      
      public static const PART_NOT_INSTALLED:uint = 0;
      
      public static const PART_BEING_UPDATER:uint = 1;
      
      public static const PART_UP_TO_DATE:uint = 2;
      
      private static const STATE_PROGRESS:int = 0;
      
      private static const STATE_FINISHED:int = 1;
      
      private static const STATE_ERROR:int = 2;
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var mainCtr:GraphicContainer;
      
      public var tx_progressBar:Texture;
      
      public var tx_progressBarBackground:Texture;
      
      public var lbl_largeProgressValue:Label;
      
      public var lbl_tinyProgressValue:Label;
      
      public var btn_loadingBG:ButtonContainer;
      
      public var ctr_large:GraphicContainer;
      
      public var ctr_tiny:GraphicContainer;
      
      public var ctr_progress:GraphicContainer;
      
      public var lbl_message:Label;
      
      private var _partId:uint;
      
      private var _folded:Boolean;
      
      private var _state:int;
      
      public function DownloadUi()
      {
         super();
      }
      
      public function set folded(param1:Boolean) : void
      {
         this._folded = param1;
         this.btn_loadingBG.selected = true;
         if(param1)
         {
            this.ctr_large.visible = false;
            this.ctr_tiny.visible = true;
         }
         else
         {
            this.btn_loadingBG.selected = false;
            this.ctr_large.visible = true;
            this.ctr_tiny.visible = false;
         }
      }
      
      public function get folded() : Boolean
      {
         return this._folded;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this.mainCtr.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this.mainCtr.visible;
      }
      
      public function main(param1:Object) : void
      {
         if(param1.hasOwnProperty("id"))
         {
            this._partId = param1.id;
         }
         if(param1.hasOwnProperty("state"))
         {
            this.state = param1.state;
         }
         else
         {
            this.state = STATE_PROGRESS;
         }
         this.sysApi.addHook(PartInfo,this.onPartInfo);
         this.sysApi.addHook(DownloadError,this.onDownloadError);
         this.uiApi.addComponentHook(this.btn_loadingBG,"onRelease");
      }
      
      public function onPartInfo(param1:Object, param2:Number) : void
      {
         if(param1.state == PART_BEING_UPDATER)
         {
            this.state = STATE_PROGRESS;
            this._partId = param1.id;
            if(param2 == 100)
            {
               this.state = STATE_FINISHED;
            }
            else
            {
               this.updateProgressBar(int(param2));
            }
         }
         else if(this._partId == param1.id && param1.state == PART_UP_TO_DATE)
         {
            this.state = STATE_FINISHED;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_loadingBG:
               this.folded = this.btn_loadingBG.selected;
         }
      }
      
      public function onDownloadError(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:String = null;
         this.state = STATE_ERROR;
         if(param2)
         {
            _loc4_ = param2;
            if(param3)
            {
               _loc4_ = _loc4_ + ("\n" + param3);
            }
         }
         else
         {
            if(param1 == 3)
            {
               _loc4_ = "internal error : bad pack id";
            }
            this.sysApi.log(8,"internal error : bad pack id");
         }
         _loc4_ = _loc4_ + ("\n" + this.uiApi.getText("ui.split.rebootOnError"));
         this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),_loc4_,[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onReboot,this.emptyFunction],this.onReboot,this.emptyFunction);
      }
      
      public function onReboot() : void
      {
         this.sysApi.reset();
      }
      
      public function emptyFunction() : void
      {
      }
      
      private function set state(param1:int) : void
      {
         this._state = param1;
         switch(this._state)
         {
            case STATE_PROGRESS:
               this.ctr_progress.visible = true;
               this.lbl_message.visible = false;
               break;
            case STATE_ERROR:
               this.ctr_progress.visible = false;
               this.lbl_message.visible = true;
               this.lbl_message.text = this.uiApi.getText("ui.streaming.downloadError");
               break;
            case STATE_FINISHED:
               this.ctr_progress.visible = false;
               this.lbl_message.visible = true;
               this.lbl_message.text = this.uiApi.getText("ui.streaming.downloadFinished");
               this.updateProgressBar(100);
         }
      }
      
      private function updateProgressBar(param1:uint) : void
      {
         this.tx_progressBar.width = this.tx_progressBarBackground.width * param1 / 100;
         this.lbl_largeProgressValue.text = param1 + "%";
         this.lbl_tinyProgressValue.text = param1 + "%";
      }
      
      private function setFinished() : void
      {
         this.lbl_message.text = this.uiApi.getText("ui.streaming.downloadError");
         this.lbl_message.visible = true;
      }
   }
}
