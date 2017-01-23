package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.AgreementAgreed;
   import d2actions.QuitGame;
   
   public class UserAgreement
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      private var _currentAgreement:uint;
      
      private var _agreementsList:Array;
      
      public var lbl_title:Label;
      
      public var lbl_content:TextArea;
      
      public var btn_refuse:ButtonContainer;
      
      public var btn_accept:ButtonContainer;
      
      public var mainCtr:GraphicContainer;
      
      public function UserAgreement()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:Object = null;
         this.mainCtr.mouseEnabled = true;
         this.mainCtr.mouseChildren = true;
         this._agreementsList = new Array();
         for each(_loc2_ in param1)
         {
            this._agreementsList.push(_loc2_);
         }
         this.lbl_content.mouseChildren = true;
         this.lbl_content.mouseEnabled = true;
         this.lbl_content.selectable = true;
         this.displayAgreement();
      }
      
      public function unload() : void
      {
      }
      
      private function displayAgreement() : void
      {
         if(this._agreementsList[this._currentAgreement] == "tou")
         {
            this.lbl_content.text = this.uiApi.getText("ui.legal.tou1") + this.uiApi.getText("ui.legal.tou2");
         }
         else
         {
            this.lbl_content.text = this.uiApi.getText("ui.legal." + this._agreementsList[this._currentAgreement]);
         }
         this.lbl_title.text = this.uiApi.getText("ui.legal.title." + this._agreementsList[this._currentAgreement]);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_accept:
               this.sysApi.sendAction(new AgreementAgreed(this._agreementsList[this._currentAgreement]));
               if(this._currentAgreement >= this._agreementsList.length - 1)
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               else
               {
                  this._currentAgreement++;
                  this.displayAgreement();
               }
               break;
            case this.btn_refuse:
               this.sysApi.sendAction(new QuitGame());
         }
      }
   }
}
