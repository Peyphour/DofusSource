package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import d2actions.AddIgnored;
   import d2actions.CharacterReport;
   import d2actions.ChatReport;
   import d2hooks.TextInformation;
   
   public class Report
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var socialApi:SocialApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var dataApi:DataApi;
      
      public var chatApi:ChatApi;
      
      public var timeApi:TimeApi;
      
      private var _playerID:Number = 0;
      
      private var _reasonName:Array;
      
      private var _playerName:String = "";
      
      private var _message:String = "";
      
      private var _fingerprint:String = "";
      
      private var _id:Number = 0;
      
      private var _channel:int = 0;
      
      private var _timestamp:Number = 0;
      
      private var _type:uint = 0;
      
      public var lbl_text:TextArea;
      
      public var btn_close:ButtonContainer;
      
      public var btn_send:ButtonContainer;
      
      public var btn_help:ButtonContainer;
      
      public var btn_howTo:ButtonContainer;
      
      public var cb_reason:ComboBox;
      
      public function Report()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         this.uiApi.addComponentHook(this.cb_reason,"onRelease");
         this.uiApi.addComponentHook(this.btn_send,"onRelease");
         this.uiApi.addComponentHook(this.cb_reason,"onSelectItem");
         if(param1.playerID is Number && param1.playerName is String)
         {
            this._playerID = param1.playerID;
            this._playerName = param1.playerName;
            this._type = 1;
         }
         if(param1.context != null && param1.context.hasOwnProperty("fingerprint") && param1.context.hasOwnProperty("timestamp"))
         {
            _loc8_ = this.socialApi.getChatSentence(param1.context.timestamp,param1.context.fingerprint);
            if(_loc8_ != null)
            {
               this._message = _loc8_.baseMsg;
               this._fingerprint = _loc8_.fingerprint;
               this._id = param1.context.id;
               this._channel = _loc8_.channel;
               this._timestamp = param1.context.timestamp;
               this._type = 0;
            }
         }
         var _loc2_:Object = this.dataApi.getAllAbuseReasons();
         var _loc3_:Array = new Array();
         var _loc4_:int = _loc2_.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc9_ = _loc2_[_loc6_];
            if(_loc9_ != null)
            {
               if((_loc9_._mask >> this._type & 1) == 1)
               {
                  _loc10_ = {
                     "label":_loc9_.name,
                     "abuseReasonId":_loc9_._abuseReasonId,
                     "mask":_loc9_._mask,
                     "reasonTextId":_loc9_._reasonTextId
                  };
                  _loc3_.push(_loc10_);
               }
            }
            _loc6_++;
         }
         this.cb_reason.dataProvider = _loc3_;
         this.cb_reason.value = _loc3_[0];
         var _loc7_:String = this.sysApi.getCurrentServer().name + " - " + this.timeApi.getDate(this._timestamp) + " " + this.timeApi.getClock(this._timestamp,true);
         if(this._message)
         {
            this.lbl_text.text = _loc7_ + " - " + this._playerName + this.uiApi.getText("ui.common.colon") + this.chatApi.getStaticHyperlink(this._message);
         }
         else
         {
            this.lbl_text.text = _loc7_ + " - " + this._playerName;
         }
      }
      
      public function unload() : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi("report");
               break;
            case this.btn_send:
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.social.reportValidation"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onValidation],this.onValidation);
               break;
            case this.btn_help:
               this.sysApi.goToUrl(this.uiApi.getText("ui.link.phishing"));
               break;
            case this.btn_howTo:
               this.sysApi.goToUrl(this.uiApi.getText("ui.link.howToReport"));
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.cb_reason:
               if(this.cb_reason.value.abuseReasonId == 4)
               {
                  this.btn_help.visible = true;
               }
               else
               {
                  this.btn_help.visible = false;
               }
         }
      }
      
      public function onValidation() : void
      {
         if(this._type == 1)
         {
            this.sysApi.sendAction(new CharacterReport(this._playerID,this.cb_reason.value.abuseReasonId));
         }
         else if(this._type == 0)
         {
            this.sysApi.sendAction(new ChatReport(this._playerID,this.cb_reason.value.abuseReasonId,this._playerName,this._channel,this._fingerprint,this._message,this._timestamp));
         }
         this.sysApi.sendAction(new AddIgnored(this._playerName));
         this.sysApi.dispatchHook(TextInformation,this.uiApi.getText("ui.social.reportFeedBack",this._playerName),10,this.timeApi.getTimestamp());
         this.uiApi.unloadUi("report");
      }
   }
}
