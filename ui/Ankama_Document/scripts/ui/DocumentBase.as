package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.LeaveDialogRequest;
   import d2actions.QuestObjectiveValidation;
   import d2actions.QuestStartRequest;
   import d2enums.CompassTypeEnum;
   import d2hooks.AddMapFlag;
   import data.ImageData;
   import data.LinkData;
   import flash.text.StyleSheet;
   import flash.text.TextFormat;
   
   public class DocumentBase
   {
      
      private static var EXP_IMG:RegExp = /(.*?)(<img.*?\/?>)/gi;
      
      private static var EXP_DIESE:RegExp = /#+/g;
      
      private static var EXP_LINK:RegExp = /<a\shref=('|")(.*?)('|")\s*>(.*?)<\/a>/gi;
      
      private static const START_QUEST:String = "startquest";
      
      private static const VALIDATE_OBJECTIVE:String = "validateobjective";
      
      private static const GO_TO_COORDINATE:String = "map";
      
      private static const NAVIGATE_TO_URL:String = "url";
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var mapApi:MapApi;
      
      private var _debugSprContainer:GraphicContainer;
      
      private var _rootDebugCtr:GraphicContainer;
      
      private var _debugTextField:Input;
      
      private var _debugTextFormat:TextFormat;
      
      private var _debugValidBtn:ButtonContainer;
      
      private var _debugCancelbtn:ButtonContainer;
      
      private var _debugCopyAllBtn:ButtonContainer;
      
      public function DocumentBase()
      {
         super();
      }
      
      public static function replace(param1:String, param2:String, param3:String) : String
      {
         var _loc9_:Number = NaN;
         var _loc4_:String = new String();
         var _loc5_:Boolean = false;
         var _loc6_:Number = param1.length;
         var _loc7_:Number = param2.length;
         var _loc8_:Number = 0;
         for(; _loc8_ < _loc6_; _loc8_++)
         {
            if(param1.charAt(_loc8_) == param2.charAt(0))
            {
               _loc5_ = true;
               _loc9_ = 0;
               while(_loc9_ < _loc7_)
               {
                  if(param1.charAt(_loc8_ + _loc9_) != param2.charAt(_loc9_))
                  {
                     _loc5_ = false;
                     break;
                  }
                  _loc9_++;
               }
               if(_loc5_)
               {
                  _loc4_ = _loc4_ + param3;
                  _loc8_ = _loc8_ + (_loc7_ - 1);
                  continue;
               }
            }
            _loc4_ = _loc4_ + param1.charAt(_loc8_);
         }
         return _loc4_;
      }
      
      protected function overrideLinkStyleInCss(param1:StyleSheet) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.color = "#AB4F22";
         _loc2_.fontWeight = "bold";
         _loc2_.textDecoration = "underline";
         param1.setStyle("a",_loc2_);
      }
      
      protected function linkHandler(param1:String) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:Array = param1.split(",");
         if(_loc2_[0] == START_QUEST)
         {
            this.sysApi.sendAction(new QuestStartRequest(int(_loc2_[1])));
            this.closeMe();
         }
         else if(_loc2_[0] == VALIDATE_OBJECTIVE)
         {
            this.sysApi.sendAction(new QuestObjectiveValidation(int(_loc2_[1]),int(_loc2_[2])));
            this.closeMe();
         }
         else if(_loc2_[0] == GO_TO_COORDINATE)
         {
            _loc3_ = _loc2_[1];
            _loc4_ = _loc2_[2];
            this.sysApi.dispatchHook(AddMapFlag,"flag_srv" + CompassTypeEnum.COMPASS_TYPE_SIMPLE + "_pos_" + _loc3_ + "_" + _loc4_,_loc3_ + "," + _loc4_,this.mapApi.getCurrentWorldMap().id,_loc3_,_loc4_,5605376,true);
         }
         else if(_loc2_[0] == NAVIGATE_TO_URL)
         {
            this.sysApi.goToUrl(_loc2_[1]);
         }
      }
      
      private function closeMe() : void
      {
         this.sysApi.sendAction(new LeaveDialogRequest());
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function getImageData(param1:String) : ImageData
      {
         var _loc2_:ImageData = new ImageData();
         var _loc3_:RegExp = new RegExp(EXP_IMG);
         var _loc4_:* = _loc3_.exec(param1);
         if(_loc4_ == null)
         {
            return null;
         }
         var _loc5_:String = _loc4_[2];
         if(_loc5_.charAt(_loc5_.length - 2) != "/")
         {
            _loc5_ = _loc5_.replace(">","/>");
         }
         var _loc6_:XML = new XML(_loc5_);
         var _loc7_:Array = _loc6_.@src.split(",");
         var _loc8_:String = _loc7_[1] + "." + _loc7_[0];
         _loc2_.regExpResult = _loc4_[0];
         _loc2_.before = _loc4_[1];
         _loc2_.src = _loc8_.replace(EXP_DIESE,"");
         _loc2_.width = parseInt(_loc6_.@width);
         _loc2_.height = parseInt(_loc6_.@height);
         _loc2_.hspace = parseInt(_loc6_.@hspace);
         _loc2_.align = _loc6_.@align;
         return _loc2_;
      }
      
      public function getAllImagesData(param1:String) : Vector.<ImageData>
      {
         var _loc3_:* = undefined;
         var _loc2_:Vector.<ImageData> = new Vector.<ImageData>();
         var _loc4_:RegExp = new RegExp(EXP_IMG);
         while((_loc3_ = _loc4_.exec(param1)) != null)
         {
            _loc2_.push(this.getImageData(_loc3_[0]));
         }
         return _loc2_;
      }
      
      public function getAllLinks(param1:String) : Vector.<LinkData>
      {
         var _loc3_:LinkData = null;
         var _loc4_:* = undefined;
         var _loc2_:Vector.<LinkData> = new Vector.<LinkData>();
         var _loc5_:RegExp = new RegExp(EXP_LINK);
         while((_loc4_ = _loc5_.exec(param1)) != null)
         {
            _loc3_ = new LinkData(_loc4_[4],_loc4_[2]);
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      protected function formateText(param1:String) : String
      {
         var _loc2_:String = param1;
         while(_loc2_.search("\n") != -1)
         {
            _loc2_ = _loc2_.replace("\n","");
         }
         while(_loc2_.search("\r") != -1)
         {
            _loc2_ = _loc2_.replace("\r","");
         }
         return _loc2_;
      }
      
      public function getProperties(param1:String) : Object
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         if(!param1)
         {
            return null;
         }
         var _loc2_:Object = new Object();
         var _loc3_:Array = param1.split(";");
         if(_loc3_.length > 0)
         {
            _loc5_ = _loc3_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc3_[_loc4_].split("=");
               if(_loc6_.length == 2)
               {
                  _loc2_[_loc6_[0]] = _loc6_[1];
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function openDebugEditionPanel(param1:GraphicContainer, param2:String, param3:Number = 0, param4:Number = 0) : void
      {
         var _loc5_:Label = null;
         var _loc6_:Label = null;
         var _loc7_:Label = null;
         if(this._rootDebugCtr == param1)
         {
            return;
         }
         this._rootDebugCtr = param1;
         if(this._debugSprContainer == null)
         {
            this._debugSprContainer = this.uiApi.createContainer("GraphicContainer") as GraphicContainer;
            this._debugSprContainer.bgColor = 16777215;
            this._debugSprContainer.borderColor = 0;
            this._debugSprContainer.width = 450;
            this._debugSprContainer.height = 550;
            this._debugTextField = this.uiApi.createComponent("Input") as Input;
            this._debugTextField.multiline = true;
            this._debugTextField.wordWrap = true;
            this._debugTextField.selectable = true;
            this._debugTextField.mouseEnabled = false;
            this._debugTextField.textfield.mouseWheelEnabled = false;
            this._debugTextField.html = false;
            this._debugValidBtn = this.uiApi.createContainer("ButtonContainer") as ButtonContainer;
            this._debugValidBtn.x = 60;
            this._debugValidBtn.y = 500;
            this._debugValidBtn.changingStateData = new Array();
            this._debugValidBtn.finalize();
            _loc5_ = this.uiApi.createComponent("Label") as Label;
            _loc5_.width = 50;
            _loc5_.height = 50;
            _loc5_.verticalAlign = "center";
            _loc5_.text = "VALID";
            this._debugValidBtn.addChild(_loc5_);
            this.uiApi.addComponentHook(this._debugValidBtn,"onRelease");
            this._debugCancelbtn = this.uiApi.createContainer("ButtonContainer") as ButtonContainer;
            this._debugCancelbtn.x = 340;
            this._debugCancelbtn.y = 500;
            this._debugCancelbtn.changingStateData = new Array();
            this._debugCancelbtn.finalize();
            _loc6_ = this.uiApi.createComponent("Label") as Label;
            _loc6_.width = 60;
            _loc6_.height = 50;
            _loc6_.verticalAlign = "center";
            _loc6_.text = "CANCEL";
            this._debugCancelbtn.addChild(_loc6_);
            this.uiApi.addComponentHook(this._debugCancelbtn,"onRelease");
            this._debugCopyAllBtn = this.uiApi.createContainer("ButtonContainer") as ButtonContainer;
            this._debugCopyAllBtn.x = 150;
            this._debugCopyAllBtn.y = 500;
            this._debugCopyAllBtn.changingStateData = new Array();
            this._debugCopyAllBtn.finalize();
            _loc7_ = this.uiApi.createComponent("Label") as Label;
            _loc7_.width = 130;
            _loc7_.height = 50;
            _loc7_.verticalAlign = "center";
            _loc7_.text = "COPY TO CLIPBOARD";
            this._debugCopyAllBtn.addChild(_loc7_);
            this.uiApi.addComponentHook(this._debugCopyAllBtn,"onRelease");
            this._debugSprContainer.addChild(this._debugTextField);
            this._debugSprContainer.addChild(this._debugValidBtn);
            this._debugSprContainer.addChild(this._debugCopyAllBtn);
            this._debugSprContainer.addChild(this._debugCancelbtn);
         }
         this._debugTextField.text = replace(param2,"> <",">\n <");
         this._debugTextField.height = 800;
         this._debugTextField.fullSize(400);
         this._debugTextField.finalize();
         this._debugSprContainer.x = param3;
         this._debugSprContainer.y = param4;
         param1.addChild(this._debugSprContainer);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this._debugCancelbtn:
               this.hideDebugEditionPanel();
               break;
            case this._debugValidBtn:
               this.updateDocumentContent(this._rootDebugCtr,this._debugTextField.text);
               break;
            case this._debugCopyAllBtn:
               this.copyAllDataToClipBoard();
         }
      }
      
      public function copyAllDataToClipBoard() : void
      {
      }
      
      public function hideDebugEditionPanel() : void
      {
         if(this._debugSprContainer != null && this._rootDebugCtr != null)
         {
            this._rootDebugCtr.removeChild(this._debugSprContainer);
            this._rootDebugCtr = null;
         }
      }
      
      public function updateDocumentContent(param1:GraphicContainer, param2:String) : void
      {
      }
      
      public function debugModeIsOpen() : Boolean
      {
         return this._rootDebugCtr != null;
      }
   }
}
