package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2enums.StatesEnum;
   import d2hooks.ClosePopup;
   
   public class PollPopup
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      private var _validCallBack:Function;
      
      private var _cancelCallback:Function;
      
      private var _btnAnswers:Array;
      
      private var _onlyOneAnswer:Boolean;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_answers:GraphicContainer;
      
      public var tx_background:Texture;
      
      public var lbl_title_popup:Label;
      
      public var lbl_description:TextArea;
      
      public var btn_ok:ButtonContainer;
      
      public function PollPopup()
      {
         this._btnAnswers = new Array();
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc11_:ButtonContainer = null;
         var _loc12_:Texture = null;
         var _loc13_:Label = null;
         var _loc14_:int = 0;
         var _loc16_:String = null;
         var _loc17_:Array = null;
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_ok.soundId = SoundEnum.OK_BUTTON;
         this.lbl_title_popup.text = param1.title;
         this.lbl_description.text = param1.content;
         this._validCallBack = param1.validCallBack;
         this._cancelCallback = param1.cancelCallback;
         this._onlyOneAnswer = param1.onlyOneAnswer;
         var _loc3_:int = this.uiApi.me().getConstant("labelHeight");
         var _loc4_:int = this.uiApi.me().getConstant("labelPosX");
         var _loc5_:int = this.uiApi.me().getConstant("textureSize");
         var _loc6_:int = this.lbl_description.width - 20 - _loc4_ - _loc5_ - this.ctr_answers.x;
         var _loc7_:Object = this.uiApi.createUri(this.uiApi.me().getConstant("css") + "normal.css");
         var _loc8_:Object = !!this._onlyOneAnswer?this.uiApi.createUri(this.uiApi.me().getConstant("uriRadio")):this.uiApi.createUri(this.uiApi.me().getConstant("uriCheck"));
         var _loc9_:int = param1.answers.length;
         var _loc10_:Label = this.uiApi.createComponent("Label") as Label;
         _loc10_.width = this.lbl_description.width - 20;
         _loc10_.multiline = true;
         _loc10_.wordWrap = true;
         _loc10_.fixedHeight = false;
         _loc10_.css = _loc7_;
         _loc10_.text = param1.content;
         _loc2_ = _loc10_.height - this.lbl_description.height;
         this.lbl_description.height = _loc10_.height;
         this.ctr_answers.width = this.lbl_description.width - 20;
         var _loc15_:uint = 0;
         while(_loc15_ < _loc9_)
         {
            _loc11_ = this.uiApi.createContainer("ButtonContainer") as ButtonContainer;
            _loc11_.width = this.lbl_description.width - 20;
            _loc11_.height = _loc3_;
            _loc11_.y = _loc14_;
            _loc11_.name = "checkBtn" + (_loc15_ + 1);
            if(this._onlyOneAnswer)
            {
               _loc11_.radioMode = true;
               _loc11_.radioGroup = "answerGroup";
            }
            else
            {
               _loc11_.radioMode = false;
            }
            _loc12_ = this.uiApi.createComponent("Texture") as Texture;
            _loc12_.y = 8;
            _loc12_.width = _loc5_;
            _loc12_.height = _loc5_;
            _loc12_.uri = _loc8_;
            _loc12_.autoGrid = true;
            _loc12_.name = _loc11_.name + "_tx";
            this.uiApi.me().registerId(_loc12_.name,this.uiApi.createContainer("GraphicElement",_loc12_,new Array(),_loc12_.name));
            _loc12_.finalize();
            _loc16_ = this.uiApi.replaceKey(param1.answers[_loc15_]);
            _loc10_.width = _loc6_;
            _loc10_.text = _loc16_;
            _loc13_ = this.uiApi.createComponent("Label") as Label;
            _loc13_.width = _loc6_;
            _loc13_.height = _loc10_.height;
            _loc13_.x = _loc4_ + _loc5_;
            _loc13_.verticalAlign = "center";
            _loc13_.css = _loc7_;
            _loc13_.wordWrap = true;
            _loc13_.multiline = true;
            _loc13_.text = _loc16_;
            _loc11_.addChild(_loc12_);
            _loc11_.addChild(_loc13_);
            _loc14_ = _loc14_ + (_loc10_.height + 10);
            _loc17_ = new Array();
            _loc17_[StatesEnum.STATE_NORMAL] = new Array();
            _loc17_[StatesEnum.STATE_NORMAL][_loc12_.name] = new Array();
            _loc17_[StatesEnum.STATE_NORMAL][_loc12_.name]["gotoAndStop"] = "normal";
            _loc17_[StatesEnum.STATE_OVER] = new Array();
            _loc17_[StatesEnum.STATE_OVER][_loc12_.name] = new Array();
            _loc17_[StatesEnum.STATE_OVER][_loc12_.name]["gotoAndStop"] = "over";
            _loc17_[StatesEnum.STATE_CLICKED] = new Array();
            _loc17_[StatesEnum.STATE_CLICKED][_loc12_.name] = new Array();
            _loc17_[StatesEnum.STATE_CLICKED][_loc12_.name]["gotoAndStop"] = "pressed";
            _loc17_[StatesEnum.STATE_SELECTED] = new Array();
            _loc17_[StatesEnum.STATE_SELECTED][_loc12_.name] = new Array();
            _loc17_[StatesEnum.STATE_SELECTED][_loc12_.name]["gotoAndStop"] = "selected";
            _loc11_.changingStateData = _loc17_;
            this.uiApi.addComponentHook(_loc11_,"onRelease");
            this.ctr_answers.addChild(_loc11_);
            this._btnAnswers.push(_loc11_);
            _loc11_.finalize();
            _loc15_++;
         }
         this.ctr_answers.height = _loc14_ + 10;
         _loc2_ = _loc2_ + this.ctr_answers.height;
         this.tx_background.height = this.tx_background.height + _loc2_;
         this.uiApi.me().render();
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:ButtonContainer = null;
         if(param1.name.indexOf("checkBtn") == 0)
         {
            if(this._onlyOneAnswer)
            {
               param1.selected = true;
            }
            else
            {
               param1.selected = !param1.selected;
            }
            return;
         }
         if(param1 == this.btn_ok)
         {
            if(this._validCallBack != null)
            {
               _loc2_ = new Array();
               for each(_loc3_ in this._btnAnswers)
               {
                  if(_loc3_.selected)
                  {
                     _loc2_.push(int(_loc3_.name.substr(8)));
                  }
               }
               this._validCallBack(_loc2_);
            }
         }
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function unload() : void
      {
         this.sysApi.dispatchHook(ClosePopup);
      }
   }
}
