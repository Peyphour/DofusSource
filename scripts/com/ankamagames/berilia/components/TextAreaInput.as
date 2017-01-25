package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.components.messages.ChangeMessage;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.handlers.FocusHandler;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.replay.KeyboardInput;
   import com.ankamagames.jerakine.replay.LogFrame;
   import com.ankamagames.jerakine.replay.LogTypeEnum;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import flash.text.TextFieldType;
   import flash.ui.Keyboard;
   
   public class TextAreaInput extends TextArea implements FinalizableUIComponent
   {
      
      private static const UNDO_MAX_SIZE:uint = 10;
      
      private static const _strReplace:String = "NoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNo" + "LogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNo" + "LogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNo" + "LogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNo" + "LogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLogNoLog";
       
      
      private var _nMaxChars:int;
      
      private var _sRestrictChars:String;
      
      private var _bNumberAutoFormat:Boolean = false;
      
      private var _nSelectionStart:int;
      
      private var _nSelectionEnd:int;
      
      private var _isNumericInput:Boolean;
      
      private var _lastTextOnInput:String;
      
      public var imeActive:Boolean;
      
      private var _sendingText:Boolean;
      
      private var _chatHistoryText:Boolean;
      
      private var _inputHistory:Vector.<InputEntry#5384>;
      
      private var _historyEntryHyperlinkCodes:Vector.<String>;
      
      private var _currentHyperlinkCodes:Vector.<String>;
      
      private var _historyCurrentIndex:int;
      
      private var _undoing:Boolean;
      
      private var _redoing:Boolean;
      
      private var _deleting:Boolean;
      
      public var focusEventHandlerPriority:Boolean = true;
      
      public function TextAreaInput()
      {
         super();
         _tText.selectable = true;
         _tText.type = TextFieldType.INPUT;
         _tText.maxChars = this._nMaxChars;
         _tText.restrict = this._sRestrictChars;
         _tText.mouseEnabled = true;
         _tText.multiline = true;
         _tText.wordWrap = true;
         _tText.addEventListener(Event.CHANGE,this.onTextChange);
         _tText.addEventListener(TextEvent.TEXT_INPUT,this.onTextInput);
         _tText.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         _tText.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,1,true);
         this._inputHistory = new Vector.<InputEntry#5384>(0);
         this._currentHyperlinkCodes = new Vector.<String>(0);
      }
      
      public function get lastTextOnInput() : String
      {
         return this._lastTextOnInput;
      }
      
      public function get maxChars() : uint
      {
         return this._nMaxChars;
      }
      
      public function set maxChars(param1:uint) : void
      {
         this._nMaxChars = param1;
         _tText.maxChars = this._nMaxChars;
      }
      
      public function get restrictChars() : String
      {
         return this._sRestrictChars;
      }
      
      public function set restrictChars(param1:String) : void
      {
         this._sRestrictChars = param1;
         _tText.restrict = this._sRestrictChars;
         this._isNumericInput = this._sRestrictChars == "0-9" || this._sRestrictChars == "0-9  ";
      }
      
      public function get haveFocus() : Boolean
      {
         return Berilia.getInstance().docMain.stage.focus == _tText;
      }
      
      override public function set text(param1:String) : void
      {
         super.text = param1;
         _tText.text = param1;
         this.onTextChange(null);
      }
      
      override public function appendText(param1:String, param2:String = null) : void
      {
         super.appendText(param1,param2);
         this.checkClearHistory();
         this._undoing = this._redoing = this._deleting = this._chatHistoryText = false;
         this.onTextChange(null);
      }
      
      override public function remove() : void
      {
         _tText.removeEventListener(Event.CHANGE,this.onTextChange);
         _tText.removeEventListener(TextEvent.TEXT_INPUT,this.onTextInput);
         _tText.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         _tText.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this._inputHistory.length = 0;
         this._currentHyperlinkCodes.length = 0;
         super.remove();
      }
      
      override public function free() : void
      {
         super.free();
      }
      
      private function undo() : void
      {
         if(this._deleting && _tText.text.length == 0)
         {
            this._inputHistory.pop();
         }
         if(this._chatHistoryText)
         {
            return;
         }
         if(this._inputHistory.length > 0)
         {
            if(!this._undoing && !this._redoing)
            {
               this._historyCurrentIndex = this._inputHistory.length - 1;
            }
            else if(this._historyCurrentIndex > 0)
            {
               this._historyCurrentIndex--;
            }
            else
            {
               this._historyCurrentIndex = -1;
               _tText.text = !!this._isNumericInput?"0":"";
               this._historyEntryHyperlinkCodes = null;
               this._undoing = true;
               this._redoing = false;
               this._deleting = false;
               this.onTextChange(null);
               return;
            }
            if(this._historyCurrentIndex + 1 > this._inputHistory.length - 1 && !this.wasHistoryText())
            {
               this.addHistory(_tText.text);
            }
            _tText.text = this._inputHistory[this._historyCurrentIndex].text;
            this._historyEntryHyperlinkCodes = this._inputHistory[this._historyCurrentIndex].hyperlinkCodes;
            this._currentHyperlinkCodes.length = 0;
         }
         else
         {
            if(_tText.text.length > 0)
            {
               this.addHistory(_tText.text);
            }
            this._historyCurrentIndex = -1;
            _tText.text = !!this._isNumericInput?"0":"";
            this._historyEntryHyperlinkCodes = null;
         }
         caretIndex = -1;
         this._undoing = true;
         this._redoing = false;
         this._deleting = false;
         this.onTextChange(null);
      }
      
      private function redo() : void
      {
         if(this._chatHistoryText)
         {
            return;
         }
         if(this._inputHistory.length > 0 && this._historyCurrentIndex < this._inputHistory.length - 1)
         {
            _tText.text = this._inputHistory[++this._historyCurrentIndex].text;
            this._historyEntryHyperlinkCodes = this._inputHistory[this._historyCurrentIndex].hyperlinkCodes;
            this._currentHyperlinkCodes.length = 0;
            caretIndex = -1;
            this._redoing = true;
            this._undoing = false;
            this._deleting = false;
            this.onTextChange(null);
         }
      }
      
      private function addHistory(param1:String) : void
      {
         var _loc2_:Vector.<String> = this.getHyperLinkCodes();
         var _loc3_:InputEntry = new InputEntry#5384(param1,_loc2_);
         if(this._inputHistory.length < UNDO_MAX_SIZE)
         {
            this._inputHistory.push(_loc3_);
         }
         else
         {
            this._inputHistory.shift();
            this._inputHistory.push(_loc3_);
            if(this._historyCurrentIndex > 0)
            {
               this._historyCurrentIndex--;
            }
         }
         this._historyEntryHyperlinkCodes = null;
         this._currentHyperlinkCodes.length = 0;
      }
      
      private function checkClearHistory() : Boolean
      {
         var _loc1_:int = 0;
         if((this._undoing || this._redoing) && this.wasHistoryText())
         {
            _loc1_ = this._historyCurrentIndex + 1;
            this._inputHistory.splice(_loc1_,this._inputHistory.length - _loc1_);
            this._historyCurrentIndex = this._inputHistory.length - 1;
            return true;
         }
         return false;
      }
      
      private function wasHistoryText() : Boolean
      {
         return this._inputHistory.length > 0 && (this._historyCurrentIndex != -1 && this._historyCurrentIndex <= this._inputHistory.length - 1 && this._lastTextOnInput == this._inputHistory[this._historyCurrentIndex].text || this._historyCurrentIndex == -1 && (this._lastTextOnInput == "" || this._lastTextOnInput == "0"));
      }
      
      private function deletePreviousWord() : void
      {
         var _loc1_:Array = _tText.text.split(" ");
         _loc1_.pop();
         _tText.text = _loc1_.join(" ");
         if(this.checkClearHistory())
         {
            this._inputHistory.pop();
         }
         this._undoing = this._deleting = this._redoing = this._chatHistoryText = false;
         this.onTextChange(null);
      }
      
      override public function focus() : void
      {
         Berilia.getInstance().docMain.stage.focus = _tText;
         FocusHandler.getInstance().setFocus(_tText);
      }
      
      public function blur() : void
      {
         Berilia.getInstance().docMain.stage.focus = null;
         FocusHandler.getInstance().setFocus(null);
      }
      
      override public function process(param1:Message) : Boolean
      {
         var _loc2_:KeyboardKeyDownMessage = null;
         if(param1 is MouseClickMessage && MouseClickMessage(param1).target == this)
         {
            this.focus();
         }
         if(this.haveFocus)
         {
            if(param1 is KeyboardKeyDownMessage)
            {
               _loc2_ = param1 as KeyboardKeyDownMessage;
               if(_loc2_.keyboardEvent.ctrlKey && _loc2_.keyboardEvent.keyCode == Keyboard.Z && !_loc2_.keyboardEvent.shiftKey)
               {
                  this.undo();
               }
               else if(_loc2_.keyboardEvent.shiftKey && _loc2_.keyboardEvent.ctrlKey && _loc2_.keyboardEvent.keyCode == Keyboard.Z)
               {
                  this.redo();
               }
               else if(_loc2_.keyboardEvent.keyCode != Keyboard.ENTER && _loc2_.keyboardEvent.keyCode != Keyboard.BACKSPACE && !_loc2_.keyboardEvent.ctrlKey && !(_loc2_.keyboardEvent.shiftKey && _loc2_.keyboardEvent.keyCode == Keyboard.SHIFT) && _loc2_.keyboardEvent.keyCode != Keyboard.UP && _loc2_.keyboardEvent.keyCode != Keyboard.DOWN)
               {
                  this._undoing = this._deleting = this._redoing = this._chatHistoryText = false;
               }
            }
         }
         return super.process(param1);
      }
      
      public function setSelection(param1:int, param2:int) : void
      {
         this._nSelectionStart = param1;
         this._nSelectionEnd = param2;
         _tText.setSelection(this._nSelectionStart,this._nSelectionEnd);
      }
      
      public function addHyperLinkCode(param1:String) : void
      {
         this._currentHyperlinkCodes.push(param1);
      }
      
      public function getHyperLinkCodes() : Vector.<String>
      {
         var _loc1_:Vector.<String> = null;
         if(!this._historyEntryHyperlinkCodes)
         {
            _loc1_ = this._currentHyperlinkCodes.concat();
         }
         else
         {
            _loc1_ = this._historyEntryHyperlinkCodes.concat(this._currentHyperlinkCodes);
         }
         return _loc1_;
      }
      
      private function onTextChange(param1:Event) : void
      {
         var _loc2_:* = false;
         if(this._lastTextOnInput != null)
         {
            if(this._isNumericInput)
            {
               _loc2_ = StringUtils.kamasToString(StringUtils.stringToKamas(this._lastTextOnInput,""),"") == StringUtils.kamasToString(StringUtils.stringToKamas(_tText.text,""),"");
            }
            else
            {
               _loc2_ = this._lastTextOnInput == _tText.text;
            }
         }
         if(!_loc2_)
         {
            LogFrame.log(LogTypeEnum.KEYBOARD_INPUT,new KeyboardInput(customUnicName,_strReplace.substr(0,_tText.text.length)));
            if(!this._sendingText && !this._chatHistoryText)
            {
               this.checkClearHistory();
               if(this._lastTextOnInput && !this._deleting && !this._redoing && !this._undoing && this._lastTextOnInput.length > _tText.text.length)
               {
                  this.addHistory(this._lastTextOnInput);
               }
               if(this._deleting && _tText.text.length == 0)
               {
                  this.addHistory(!!this._isNumericInput?"0":"");
                  this._historyCurrentIndex = this._inputHistory.length - 1;
                  this._historyEntryHyperlinkCodes = null;
               }
            }
         }
         this._lastTextOnInput = _tText.text;
         this._sendingText = false;
         this._nSelectionStart = 0;
         this._nSelectionEnd = 0;
         Berilia.getInstance().handler.process(new ChangeMessage(InteractiveObject(this)));
         updateScrollBarPos();
         updateScrollBar();
      }
      
      private function onTextInput(param1:TextEvent) : void
      {
         if(param1.text.length > 1)
         {
            this.checkClearHistory();
            if(!this._undoing && !this._redoing && !this._deleting && this._lastTextOnInput != null && _tText.text.length + param1.text.length > this._lastTextOnInput.length)
            {
               this.addHistory(this._lastTextOnInput);
            }
            this._undoing = this._deleting = this._redoing = this._chatHistoryText = false;
         }
      }
      
      private function onKeyUp(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER && XmlConfig.getInstance().getEntry("config.lang.current") != "ja" && !(param1.altKey || param1.shiftKey || param1.ctrlKey || param1.hasOwnProperty("controlKey") && param1.controlKey || param1.hasOwnProperty("commandKey") && param1.commandKey))
         {
            this._sendingText = true;
            this._inputHistory.length = 0;
            this._historyCurrentIndex = 0;
         }
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(!param1.altKey && !param1.shiftKey && param1.ctrlKey && param1.keyCode == Keyboard.Y)
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            this.redo();
         }
         else if(!param1.altKey && !param1.shiftKey && param1.ctrlKey && param1.keyCode == Keyboard.BACKSPACE)
         {
            param1.preventDefault();
            param1.stopImmediatePropagation();
            this.deletePreviousWord();
         }
         else if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN)
         {
            this._chatHistoryText = true;
            this._undoing = this._redoing = this._deleting = false;
            this._inputHistory.length = 0;
            this._historyCurrentIndex = 0;
         }
         else if(param1.keyCode == Keyboard.BACKSPACE)
         {
            this._chatHistoryText = false;
            if(!this._deleting)
            {
               this._deleting = true;
               this._undoing = this._redoing = false;
               if(this._lastTextOnInput)
               {
                  this.addHistory(this._lastTextOnInput);
               }
            }
         }
         else if(!param1.altKey && param1.shiftKey && !param1.ctrlKey && param1.keyCode == Keyboard.ENTER)
         {
            _log.debug("shift entrée");
         }
      }
   }
}

class InputEntry#5384
{
    
   
   private var _text:String;
   
   private var _hyperlinkCodes:Vector.<String>;
   
   function InputEntry#5384(param1:String, param2:Vector.<String>)
   {
      super();
      this._text = param1;
      this._hyperlinkCodes = param2;
   }
   
   public function get text() : String
   {
      return this._text;
   }
   
   public function get hyperlinkCodes() : Vector.<String>
   {
      return this._hyperlinkCodes;
   }
}
