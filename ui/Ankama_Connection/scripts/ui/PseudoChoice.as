package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.NicknameChoiceRequest;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.KeyDown;
   import d2hooks.NicknameAccepted;
   import d2hooks.NicknameRefused;
   
   public class PseudoChoice
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      private var validatedPseudo:Boolean = false;
      
      private var connecting:Boolean = false;
      
      private var minChars:int;
      
      public var input_pseudo:Input;
      
      public var lbl_result:Label;
      
      public var lbl_warning:Label;
      
      public var btn_close:ButtonContainer;
      
      public var btn_validate:ButtonContainer;
      
      public var tx_info:Texture;
      
      public var tx_warning:Texture;
      
      public function PseudoChoice()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.minChars = parseInt(this.uiApi.me().getConstant("minChars"));
         this.sysApi.addHook(NicknameRefused,this.onNicknameRefused);
         this.sysApi.addHook(NicknameAccepted,this.onNicknameAccepted);
         this.sysApi.addHook(KeyDown,this.onKeyDown);
         this.btn_validate.disabled = true;
         this.tx_warning.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_warning,"onTextureReady");
      }
      
      public function unload() : void
      {
         var _loc1_:Object = null;
         if(!this.connecting)
         {
            _loc1_ = this.uiApi.getUi("login");
            if(_loc1_ && _loc1_.uiClass && _loc1_.uiClass.hasOwnProperty("disableUi"))
            {
               _loc1_.uiClass.disableUi(false);
            }
         }
      }
      
      public function onTextureReady(param1:Object) : void
      {
         this.tx_warning.x = this.lbl_warning.textfield.getCharBoundaries(0).x;
      }
      
      public function onNicknameAccepted() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function onNicknameRefused(param1:uint) : void
      {
         this.connecting = false;
         switch(param1)
         {
            case this.sysApi.getEnum("com.ankamagames.dofus.network.enums.NicknameErrorEnum").ALREADY_USED:
               this.lbl_result.text = this.uiApi.getText("ui.nickname.alreadyUsed");
               break;
            case this.sysApi.getEnum("com.ankamagames.dofus.network.enums.NicknameErrorEnum").SAME_AS_LOGIN:
               this.lbl_result.text = this.uiApi.getText("ui.nickname.equalsLogin");
               break;
            case this.sysApi.getEnum("com.ankamagames.dofus.network.enums.NicknameErrorEnum").TOO_SIMILAR_TO_LOGIN:
               this.lbl_result.text = this.uiApi.getText("ui.nickname.similarToLogin");
               break;
            case this.sysApi.getEnum("com.ankamagames.dofus.network.enums.NicknameErrorEnum").INVALID_NICK:
               this.lbl_result.text = this.uiApi.getText("ui.nickname.invalid");
               break;
            case this.sysApi.getEnum("com.ankamagames.dofus.network.enums.NicknameErrorEnum").UNKNOWN_NICK_ERROR:
               this.lbl_result.text = this.uiApi.getText("ui.nickname.unknown");
               break;
            default:
               this.sysApi.log(8,"Pseudo refusé pour une raison non traitée");
         }
         this.btn_validate.disabled = false;
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_validate:
               if(this.input_pseudo.text && this.input_pseudo.text.length >= this.minChars)
               {
                  this.connecting = true;
                  this.sysApi.sendAction(new NicknameChoiceRequest(this.input_pseudo.text));
                  this.btn_validate.disabled = true;
                  this.lbl_result.text = this.uiApi.getText("ui.common.waiting");
               }
               else
               {
                  this.lbl_result.text = this.uiApi.getText("ui.nickname.invalid");
               }
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == this.tx_info)
         {
            _loc2_ = this.uiApi.getText("ui.pseudoChoice.rule");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",6,1,0,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               if(!this.validatedPseudo)
               {
                  this.sysApi.sendAction(new NicknameChoiceRequest(this.input_pseudo.text));
                  return true;
               }
               break;
            case ShortcutHookListEnum.CLOSE_UI:
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
         }
         return true;
      }
      
      public function onKeyDown(param1:Object, param2:uint) : void
      {
         if(this.input_pseudo.haveFocus)
         {
            this.btn_validate.disabled = !this.input_pseudo.text || this.input_pseudo.text.length < 3;
         }
      }
   }
}
