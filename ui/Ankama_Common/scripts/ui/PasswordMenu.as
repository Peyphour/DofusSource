package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.KeyUp;
   import d2hooks.LeaveDialog;
   import flash.ui.Keyboard;
   
   public class PasswordMenu
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var bindsApi:BindsApi;
      
      private var _size:int;
      
      private var _changeOrUse:Boolean;
      
      private var _numberList:Array;
      
      private var _index:int;
      
      private var _listPosX:Array;
      
      private var _txList:Array;
      
      private var _lblList:Array;
      
      private var _onCancel:Function;
      
      private var _onConfirm:Function;
      
      private var _onClose:Function;
      
      public var mainCtr:GraphicContainer;
      
      public var grid:Object;
      
      public var btnOk:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btnReset:ButtonContainer;
      
      public var lblInfo:TextArea;
      
      public var btn0:ButtonContainer;
      
      public var btn1:ButtonContainer;
      
      public var btn2:ButtonContainer;
      
      public var btn3:ButtonContainer;
      
      public var btn4:ButtonContainer;
      
      public var btn5:ButtonContainer;
      
      public var btn6:ButtonContainer;
      
      public var btn7:ButtonContainer;
      
      public var btn8:ButtonContainer;
      
      public var btn9:ButtonContainer;
      
      public var txBtn0:TextureBitmap;
      
      public var txBtn1:TextureBitmap;
      
      public var txBtn2:TextureBitmap;
      
      public var txBtn3:TextureBitmap;
      
      public var txBtn4:TextureBitmap;
      
      public var txBtn5:TextureBitmap;
      
      public var txBtn6:TextureBitmap;
      
      public var txBtn7:TextureBitmap;
      
      public var textBtn0:Label;
      
      public var textBtn1:Label;
      
      public var textBtn2:Label;
      
      public var textBtn3:Label;
      
      public var textBtn4:Label;
      
      public var textBtn5:Label;
      
      public var textBtn6:Label;
      
      public var textBtn7:Label;
      
      public function PasswordMenu()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this._size = param1.size;
         this._changeOrUse = param1.changeOrUse;
         this._onCancel = param1.cancelCallBack;
         this._onConfirm = param1.confirmCallBack;
         this.lblInfo.wordWrap = true;
         if(this._changeOrUse)
         {
            this.lblInfo.text = this.uiApi.getText("ui.common.lockInfos");
         }
         else
         {
            this.lblInfo.text = this.uiApi.getText("ui.common.unlockInfos");
         }
         this._txList = new Array(this.txBtn0,this.txBtn1,this.txBtn2,this.txBtn3,this.txBtn4,this.txBtn5,this.txBtn6,this.txBtn7);
         this._lblList = new Array(this.textBtn0,this.textBtn1,this.textBtn2,this.textBtn3,this.textBtn4,this.textBtn5,this.textBtn6,this.textBtn7);
         this._listPosX = new Array(8);
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            this._listPosX[_loc2_] = this._txList[_loc2_].x - 2;
            _loc2_++;
         }
         this.reset();
         this.bindsApi.enableShortcutKey(Keyboard.SPACE,32,false);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.sysApi.addHook(LeaveDialog,this.onLeaveDialog);
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addComponentHook(this.btnOk,"onRelease");
         this.uiApi.addComponentHook(this.btnReset,"onRelease");
         this.uiApi.addComponentHook(this.btn0,"onRelease");
         this.uiApi.addComponentHook(this.btn1,"onRelease");
         this.uiApi.addComponentHook(this.btn2,"onRelease");
         this.uiApi.addComponentHook(this.btn3,"onRelease");
         this.uiApi.addComponentHook(this.btn4,"onRelease");
         this.uiApi.addComponentHook(this.btn5,"onRelease");
         this.uiApi.addComponentHook(this.btn6,"onRelease");
         this.uiApi.addComponentHook(this.btn7,"onRelease");
         this.uiApi.addComponentHook(this.btn8,"onRelease");
         this.uiApi.addComponentHook(this.btn9,"onRelease");
         this.sysApi.disableWorldInteraction();
         this.sysApi.removeFocus();
      }
      
      public function getCode() : String
      {
         var _loc3_:int = 0;
         var _loc1_:* = "";
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            if(_loc2_ >= this._size)
            {
               _loc1_ = _loc1_ + "_";
            }
            else
            {
               _loc3_ = this._numberList[_loc2_];
               if(_loc3_ != -1)
               {
                  if(_loc3_ == 10)
                  {
                     _loc1_ = _loc1_ + "_";
                  }
                  else
                  {
                     _loc1_ = _loc1_ + _loc3_;
                  }
               }
               else
               {
                  _loc1_ = _loc1_ + "_";
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function unload() : void
      {
         this.bindsApi.enableShortcutKey(Keyboard.SPACE,32,true);
         this.sysApi.enableWorldInteraction();
      }
      
      private function addNumber(param1:int) : void
      {
         this._numberList[this._index] = param1;
         this._index++;
         if(this._index >= this._size)
         {
            this._index = 0;
         }
         this.updateNumbers();
      }
      
      private function reset() : void
      {
         this._numberList = new Array(this._size);
         var _loc1_:int = 0;
         while(_loc1_ < this._size)
         {
            this._numberList[_loc1_] = -1;
            _loc1_++;
         }
         this._index = 0;
         this.updateNumbers();
      }
      
      private function updateNumbers() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._size)
         {
            _loc3_ = this._numberList[_loc1_];
            if(_loc3_ == -1 || _loc3_ == 10)
            {
               if(_loc1_ == this._index)
               {
                  _loc4_ = this._lblList[_loc1_];
                  _loc4_.visible = true;
                  _loc4_.text = "_";
               }
               else
               {
                  this._lblList[_loc1_].visible = false;
               }
            }
            else
            {
               _loc4_ = this._lblList[_loc1_];
               _loc4_.visible = true;
               _loc4_.text = String(this._numberList[_loc1_]);
            }
            _loc1_++;
         }
         var _loc2_:int = _loc1_;
         while(_loc2_ < 8)
         {
            this._txList[_loc2_].visible = false;
            this._lblList[_loc2_].visible = false;
            _loc2_++;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(true)
         {
            case param1 == this.btnReset:
               this.reset();
               return;
            case param1 == this.btn_close:
               this.uiApi.unloadUi("passwordMenu");
               if(this._onCancel != null)
               {
                  this._onCancel();
               }
               return;
            case param1 == this.btnOk:
               this.uiApi.unloadUi("passwordMenu");
               this._onConfirm(this._changeOrUse,this.getCode());
               return;
            case param1 == this.btn0:
               this.addNumber(0);
               return;
            case param1 == this.btn1:
               this.addNumber(1);
               return;
            case param1 == this.btn2:
               this.addNumber(2);
               return;
            case param1 == this.btn3:
               this.addNumber(3);
               return;
            case param1 == this.btn4:
               this.addNumber(4);
               return;
            case param1 == this.btn5:
               this.addNumber(5);
               return;
            case param1 == this.btn6:
               this.addNumber(6);
               return;
            case param1 == this.btn7:
               this.addNumber(7);
               return;
            case param1 == this.btn8:
               this.addNumber(8);
               return;
            case param1 == this.btn9:
               this.addNumber(9);
               return;
            default:
               return;
         }
      }
      
      private function onKeyUp(param1:Object, param2:int) : void
      {
         switch(param2)
         {
            case Keyboard.SPACE:
               this.addNumber(10);
               return;
            case Keyboard.NUMBER_0:
            case Keyboard.NUMPAD_0:
               this.addNumber(0);
               return;
            case Keyboard.NUMBER_1:
            case Keyboard.NUMPAD_1:
               this.addNumber(1);
               return;
            case Keyboard.NUMBER_2:
            case Keyboard.NUMPAD_2:
               this.addNumber(2);
               return;
            case Keyboard.NUMBER_3:
            case Keyboard.NUMPAD_3:
               this.addNumber(3);
               return;
            case Keyboard.NUMBER_4:
            case Keyboard.NUMPAD_4:
               this.addNumber(4);
               return;
            case Keyboard.NUMBER_5:
            case Keyboard.NUMPAD_5:
               this.addNumber(5);
               return;
            case Keyboard.NUMBER_6:
            case Keyboard.NUMPAD_6:
               this.addNumber(6);
               return;
            case Keyboard.NUMBER_7:
            case Keyboard.NUMPAD_7:
               this.addNumber(7);
               return;
            case Keyboard.NUMBER_8:
            case Keyboard.NUMPAD_8:
               this.addNumber(8);
               return;
            case Keyboard.NUMBER_9:
            case Keyboard.NUMPAD_9:
               this.addNumber(9);
               return;
            default:
               return;
         }
      }
      
      private function onLeaveDialog() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               this.uiApi.unloadUi("passwordMenu");
               this._onConfirm(this._changeOrUse,this.getCode());
               return true;
            case "closeUi":
               this.uiApi.unloadUi("passwordMenu");
               if(this._onCancel != null)
               {
                  this._onCancel();
               }
               return true;
            default:
               return false;
         }
      }
   }
}
