package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.shortcut.Bind;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.AuthorizedCommand;
   import d2enums.DataStoreEnum;
   import d2hooks.CharacterSelectionStart;
   import d2hooks.ConsoleAddCmd;
   import d2hooks.ConsoleClear;
   import d2hooks.ConsoleOutput;
   import d2hooks.KeyUp;
   import d2hooks.KeyboardShortcut;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class ConsoleUi
   {
      
      private static const SAVE_NAME:String = "consoleOption";
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var bindsApi:BindsApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var contextMod:Object;
      
      private var _maxCmdHistoryIndex:uint = 25;
      
      private var _aHistory:Object;
      
      private var _nHistoryIndex:int = 0;
      
      public var taConsole:TextArea;
      
      public var lblInfo:Label;
      
      public var tiCmd:Input;
      
      public var mainContainer:GraphicContainer;
      
      public var topBar:GraphicContainer;
      
      public var btnReduce:ButtonContainer;
      
      public var btnExtend:ButtonContainer;
      
      public var btnClose:ButtonContainer;
      
      public var btnMenu:ButtonContainer;
      
      public var btnClear:ButtonContainer;
      
      public var btnBlock:ButtonContainer;
      
      private var _init:Boolean;
      
      private var _menu:Array;
      
      private var _options:Object;
      
      private var _savePreset:Boolean;
      
      private var _replaceTimer:Timer;
      
      private var _autoCompleteRunning:Boolean;
      
      private var _autoCompleteWithList:Boolean;
      
      private var _autoCompleteWithHistory:Boolean;
      
      private var _inputChanged:Boolean;
      
      private var _autoCompletePossibilities:Array;
      
      private var _autoCompleteIndex:int;
      
      private var _paramsRE:RegExp;
      
      private var _blockScroll:Boolean = false;
      
      private var _lastInput:String;
      
      public function ConsoleUi()
      {
         this._paramsRE = /'[a-zA-Z-*]*'/g;
         super();
      }
      
      public function main(param1:Boolean) : void
      {
         if(this.sysApi.getOs() == "Linux")
         {
            this.lblInfo.setCssFont("\"Courier New\", Courier, monospace");
            this.taConsole.setCssFont("\"Courier New\", Courier, monospace");
            this.tiCmd.setCssFont("\"Courier New\", Courier, monospace");
         }
         this.sysApi.addHook(ConsoleAddCmd,this.onConsoleAddCmd);
         this.sysApi.addHook(ConsoleClear,this.onConsoleClear);
         this.sysApi.addHook(ConsoleOutput,this.onConsoleOutput);
         this.sysApi.addHook(CharacterSelectionStart,this.onCharacterSelectionStart);
         this.sysApi.addHook(KeyboardShortcut,this.onKeyBoardShortcut);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("upArrow",this.onShortcut);
         this.uiApi.addShortcutHook("downArrow",this.onShortcut);
         this.uiApi.addShortcutHook("autoComplete",this.onShortcut);
         this.uiApi.addShortcutHook("historySearch",this.onShortcut);
         this.uiApi.addComponentHook(this.btnReduce,"onRelease");
         this.uiApi.addComponentHook(this.btnExtend,"onRelease");
         this.uiApi.addComponentHook(this.btnClose,"onRelease");
         this.uiApi.addComponentHook(this.btnMenu,"onRelease");
         this.uiApi.addComponentHook(this.btnClear,"onRelease");
         this.uiApi.addComponentHook(this.btnBlock,"onRelease");
         this.uiApi.addComponentHook(this.topBar,"onDoubleClick");
         this.uiApi.addComponentHook(this.tiCmd,"onChange");
         this._autoCompletePossibilities = [];
         this.taConsole.activeSmallHyperlink();
         this.taConsole.useCustomFormat = true;
         if(!this._aHistory)
         {
            this.init();
         }
         this._options = this.sysApi.getData(SAVE_NAME,DataStoreEnum.BIND_ACCOUNT);
         if(!this._options)
         {
            this._savePreset = true;
            this._autoCompleteWithList = true;
            this._autoCompleteWithHistory = true;
         }
         else
         {
            this._savePreset = this._options.savePreset;
            this._autoCompleteWithList = !!this._options.hasOwnProperty("autoCompleteWithList")?Boolean(this._options.autoCompleteWithList):true;
            this._autoCompleteWithHistory = !!this._options.hasOwnProperty("autoCompleteWithHistory")?Boolean(this._options.autoCompleteWithHistory):true;
            if(!this._options.hasOwnProperty("fontSize"))
            {
               this._options.fontSize = 14;
            }
         }
         if(!this._options || !this._savePreset)
         {
            this._options = {
               "opacity":66,
               "x":100,
               "y":100,
               "width":1024,
               "height":500,
               "openConsole":false,
               "savePreset":this._savePreset,
               "fontSize":14
            };
         }
         this.updateInfo();
         this.onAlphaChange(this._options.opacity);
         this.onFontSizeChange(this._options.fontSize);
         if(param1)
         {
            this.setFocus();
         }
      }
      
      public function setFocus() : void
      {
         this.tiCmd.focus();
      }
      
      public function addCmd(param1:String, param2:Boolean, param3:Boolean) : void
      {
         if(param2)
         {
            this.executeCmd(param1);
         }
         else
         {
            this.tiCmd.text = param1;
         }
         if(param3)
         {
            this.setFocus();
         }
      }
      
      public function updateInfo() : void
      {
         var _loc3_:Object = null;
         var _loc1_:* = "";
         var _loc2_:Server = this.sysApi.getCurrentServer();
         if(_loc2_)
         {
            _loc1_ = _loc2_.name + " (" + _loc2_.id + ")";
         }
         if(this.playerApi)
         {
            _loc3_ = this.playerApi.getPlayedCharacterInfo();
            if(_loc3_)
            {
               _loc1_ = _loc1_ + (", " + _loc3_.name + " (" + _loc3_.id + ")");
            }
         }
         if(!_loc1_.length)
         {
            _loc1_ = "Connection server\'s";
         }
         this.lblInfo.text = _loc1_;
      }
      
      private function init() : void
      {
         this._aHistory = this.sysApi.getData("CommandsHistory");
         if(!this._aHistory)
         {
            this._aHistory = new Array();
         }
         this._nHistoryIndex = this._aHistory.length;
      }
      
      private function validCmd() : Boolean
      {
         if(!this.tiCmd.haveFocus)
         {
            return false;
         }
         var _loc1_:String = this.tiCmd.text;
         if(_loc1_.length == 0)
         {
            return true;
         }
         var _loc2_:String = _loc1_;
         while(_loc2_.indexOf("<") != -1)
         {
            _loc2_ = _loc2_.replace("<","&lt;");
         }
         while(_loc2_.indexOf(">") != -1)
         {
            _loc2_ = _loc2_.replace(">","&gt;");
         }
         this.output(" > " + _loc2_ + "\n");
         this.tiCmd.text = "";
         this.executeCmd(_loc1_);
         return true;
      }
      
      private function executeCmd(param1:String) : void
      {
         if(!this._aHistory)
         {
            this.init();
         }
         if(!this._aHistory.length || param1 != this._aHistory[this._aHistory.length - 1])
         {
            this._aHistory.push(param1);
            if(this._aHistory.length > this._maxCmdHistoryIndex)
            {
               this._aHistory = this._aHistory.slice(this._aHistory.length - this._maxCmdHistoryIndex,this._aHistory.length);
            }
            this._nHistoryIndex = this._aHistory.length;
            this.sysApi.setData("CommandsHistory",this._aHistory);
         }
         else
         {
            this._nHistoryIndex = this._aHistory.length;
         }
         this.sysApi.sendAction(new AuthorizedCommand(param1));
         this.setFocus();
      }
      
      private function output(param1:String, param2:uint = 0) : void
      {
         var _loc3_:String = this._options.opacity != 100?"alpha":"";
         this.taConsole.appendText(param1,param2 == 0?"p" + _loc3_:param2 == 1?"pinfo" + _loc3_:param2 == 2?"perror" + _loc3_:"p" + _loc3_);
         if(!this._blockScroll)
         {
            this.taConsole.scrollV = this.taConsole.maxScrollV;
         }
         if(this.uiApi.me().visible)
         {
            this.tiCmd.focus();
         }
      }
      
      private function trimWhitespace(param1:String) : String
      {
         if(param1 == null)
         {
            return "";
         }
         return param1.replace(/^\s+|\s+$/g,"");
      }
      
      private function getParamsAutoCompleteFromHelp(param1:String, param2:Boolean) : Array
      {
         var _loc8_:String = null;
         var _loc11_:String = null;
         var _loc13_:String = null;
         var _loc3_:Array = param1.split(" ");
         var _loc4_:String = param1.substring(param1.lastIndexOf(" ") + 1);
         var _loc5_:String = this.sysApi.getCmdHelp(_loc3_[0],param2);
         if(_loc5_.indexOf("Unknown command") != -1)
         {
            return null;
         }
         var _loc6_:Array = _loc5_.split(" ");
         var _loc7_:int = _loc3_.length - 1;
         if(_loc7_ <= _loc6_.length - 1)
         {
            _loc8_ = _loc6_[_loc7_];
         }
         var _loc9_:Array = _loc8_.match(this._paramsRE);
         var _loc10_:Array = [];
         var _loc12_:String = param1.substring(0,param1.lastIndexOf(" "));
         for each(_loc11_ in _loc9_)
         {
            _loc13_ = _loc12_ + " " + _loc11_.replace(/\'/g,"");
            if(_loc13_.indexOf(param1) != -1)
            {
               _loc10_.push(_loc13_);
            }
         }
         return _loc10_;
      }
      
      private function autoComplete(param1:Boolean = false, param2:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc6_:Object = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc11_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:uint = 0;
         var _loc15_:String = null;
         var _loc16_:Array = null;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc19_:String = null;
         var _loc20_:String = null;
         var _loc21_:Number = NaN;
         var _loc22_:String = null;
         var _loc23_:Array = null;
         var _loc24_:String = null;
         var _loc25_:String = null;
         var _loc26_:String = null;
         var _loc3_:String = this.tiCmd.text;
         var _loc7_:uint = 0;
         _loc5_ = _loc3_.length > 0?_loc3_.charAt(0) == "/"?false:true:false;
         if((this._autoCompleteWithList || !this._autoCompleteWithList && this._inputChanged) && _loc3_.length != 0 && !param1)
         {
            if(!_loc5_)
            {
               _loc3_ = _loc3_.substr(1);
            }
            if(_loc3_.length == 0)
            {
               return;
            }
            _loc14_ = _loc3_.substr(0,this.tiCmd.caretIndex).split(" ").length - 1;
            if(_loc14_ == 0)
            {
               _loc6_ = this.sysApi.getAutoCompletePossibilities(_loc3_,_loc5_);
            }
            else
            {
               _loc16_ = _loc3_.split(" ");
               _loc17_ = _loc16_[0];
               _loc16_.splice(0,1);
               _loc18_ = _loc16_;
               _loc6_ = this.sysApi.getAutoCompletePossibilitiesOnParam(_loc17_,_loc5_,_loc14_ - 1,_loc18_);
            }
            _loc7_ = _loc6_.length;
            _loc15_ = this.sysApi.getConsoleAutoCompletion(_loc3_,_loc5_);
         }
         var _loc10_:String = this.tiCmd.text;
         var _loc12_:Dictionary = new Dictionary();
         if(this._autoCompleteWithHistory && (this._autoCompleteWithList || !this._autoCompleteWithList && this._inputChanged))
         {
            _loc11_ = [];
            for each(_loc19_ in this._aHistory)
            {
               _loc19_ = this.trimWhitespace(_loc19_);
               if(!_loc12_[_loc19_.toLowerCase()] && _loc19_.toLowerCase().indexOf(_loc10_) != -1)
               {
                  _loc11_.push(_loc19_);
                  _loc12_[_loc19_.toLowerCase()] = true;
               }
            }
         }
         if(this._autoCompleteWithList && _loc11_ && _loc11_.length)
         {
            _loc9_ = [];
            _loc9_.push(this.contextMod.createContextMenuTitleObject("History"));
            for each(_loc20_ in _loc11_)
            {
               _loc21_ = _loc20_.toLowerCase().indexOf(_loc10_);
               _loc4_ = _loc10_.length;
               _loc9_.push(this.contextMod.createContextMenuItemObject(_loc20_.substr(0,_loc21_) + "<b>" + _loc20_.substr(_loc21_,_loc4_) + "</b>" + _loc20_.substr(_loc21_ + _loc4_),this.onPossibilityChoice,[_loc20_,true,false],false,null,false,true));
            }
            if(_loc7_ == 0 && _loc11_.length == 1)
            {
               _loc15_ = _loc20_;
               _loc5_ = true;
            }
            _loc7_ = _loc7_ + _loc11_.length;
         }
         if(this._autoCompleteWithList)
         {
            _loc13_ = [];
            if(_loc7_ == 1)
            {
               if(!param2)
               {
                  this.tiCmd.text = (!!_loc5_?"":"/") + _loc15_;
               }
               this.tiCmd.setSelection(this.tiCmd.length,this.tiCmd.length);
               this._autoCompleteRunning = false;
               this.contextMod.closeAllMenu();
            }
            else if(_loc6_ && _loc6_.length > 1)
            {
               _loc13_.push(this.contextMod.createContextMenuTitleObject(!!_loc5_?"Server commands":"Client commands"));
               _loc4_ = this.getBoldLength(_loc3_,_loc15_) + (!!_loc5_?0:1);
               for each(_loc22_ in _loc6_)
               {
                  _loc8_ = this.sysApi.getCmdHelp(_loc22_,_loc5_);
                  if(_loc8_)
                  {
                     _loc8_ = _loc8_.split("[").join("&#91;");
                  }
                  _loc13_.push(this.contextMod.createContextMenuItemObject((!!_loc5_?"":"/") + "<b>" + _loc22_.substr(0,_loc4_) + "</b>" + _loc22_.substr(_loc4_),this.onPossibilityChoice,[_loc22_,_loc5_,_loc14_ != 0],false,null,false,true,_loc8_));
               }
            }
            if(_loc9_)
            {
               _loc13_ = _loc13_.concat(_loc9_);
            }
            if(_loc13_.length)
            {
               this.contextMod.createContextMenu(_loc13_,{
                  "x":this.mainContainer.x,
                  "y":this.mainContainer.y + this.mainContainer.height
               },this.onContextMenuClose);
               this._autoCompleteRunning = true;
            }
            else
            {
               this.contextMod.closeAllMenu();
            }
         }
         if(!this._autoCompleteWithList && !param2 && _loc3_.length > 0)
         {
            if(this._inputChanged)
            {
               this._autoCompleteIndex = 0;
               this._inputChanged = false;
               this._autoCompletePossibilities = [];
               if(_loc6_ && _loc6_.length > 0)
               {
                  if(_loc14_ != 0)
                  {
                     _loc23_ = [];
                     for each(_loc24_ in _loc6_)
                     {
                        _loc25_ = _loc3_.substring(0,_loc3_.lastIndexOf(" ")) + " " + _loc24_;
                        if(_loc25_.indexOf(_loc3_) != -1)
                        {
                           _loc23_.push(_loc25_);
                        }
                     }
                     if(_loc23_.length > 0)
                     {
                        this._autoCompletePossibilities = this._autoCompletePossibilities.concat(_loc23_);
                     }
                  }
                  else
                  {
                     this._autoCompletePossibilities = this._autoCompletePossibilities.concat(_loc6_);
                  }
               }
               else if(_loc3_.indexOf(" ") != -1)
               {
                  _loc23_ = this.getParamsAutoCompleteFromHelp(_loc3_,_loc5_);
                  if(_loc23_)
                  {
                     this._autoCompletePossibilities = this._autoCompletePossibilities.concat(_loc23_);
                  }
               }
               if(_loc11_ && _loc11_.length > 0)
               {
                  this._autoCompletePossibilities = this._autoCompletePossibilities.concat(_loc11_);
               }
            }
            else if(this._autoCompleteIndex < this._autoCompletePossibilities.length - 1)
            {
               this._autoCompleteIndex++;
            }
            else
            {
               this._autoCompleteIndex = 0;
            }
            if(this._autoCompletePossibilities.length > 0)
            {
               _loc26_ = this._autoCompletePossibilities[this._autoCompleteIndex];
               if(_loc26_.charAt(0) == "/")
               {
                  _loc26_ = _loc26_.substr(1);
               }
               this.tiCmd.text = (!_loc5_?"/":"") + _loc26_;
               this.tiCmd.caretIndex = this.tiCmd.text.length;
            }
         }
      }
      
      private function onConsoleOutput(param1:String, param2:uint) : void
      {
         if(this._options.openConsole)
         {
            Console.getInstance().showConsole(true);
         }
         this.output(param1 + "\n",param2);
      }
      
      private function onKeyBoardShortcut(param1:Bind, param2:uint) : void
      {
         var _loc3_:Bind = this.bindsApi.getRegisteredBind(param1);
         if(!this._autoCompleteWithList && (!_loc3_ || _loc3_.targetedShortcut != "autoComplete"))
         {
            this._inputChanged = true;
            this._autoCompleteRunning = false;
         }
      }
      
      private function onKeyUp(param1:Object, param2:uint) : void
      {
         if(!this._autoCompleteWithList && param2 == Keyboard.BACKSPACE)
         {
            this._inputChanged = true;
            this._autoCompleteRunning = false;
         }
         else if(this._autoCompleteRunning && param2 == Keyboard.ESCAPE)
         {
            this._autoCompleteRunning = false;
         }
      }
      
      private function onShortcut(param1:String) : Boolean
      {
         if(!this.uiApi.me().visible)
         {
            return false;
         }
         switch(param1)
         {
            case "validUi":
               return this.validCmd();
            case "upArrow":
            case "downArrow":
               if(!this.tiCmd.haveFocus)
               {
                  return true;
               }
               if(!this._aHistory.length)
               {
                  return true;
               }
               if(param1 == "upArrow" && this._nHistoryIndex >= 0)
               {
                  this._nHistoryIndex--;
               }
               if(param1 == "downArrow" && this._nHistoryIndex < this._aHistory.length)
               {
                  this._nHistoryIndex++;
               }
               if(this._aHistory[this._nHistoryIndex] != null)
               {
                  this.tiCmd.text = this._aHistory[this._nHistoryIndex];
               }
               else
               {
                  this.tiCmd.text = "";
               }
               this.tiCmd.setSelection(this.tiCmd.length,this.tiCmd.length);
               return true;
            case "autoComplete":
               this.tiCmd.focus();
               this.autoComplete();
               return true;
            case "historySearch":
               this.tiCmd.focus();
               this.autoComplete();
               return true;
            default:
               return false;
         }
      }
      
      private function onPossibilityChoice(param1:String, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         if(param3)
         {
            _loc4_ = this.tiCmd.text;
            _loc5_ = this.tiCmd.caretIndex;
            while(_loc5_ >= 0)
            {
               if(_loc4_.charAt(_loc5_) == " ")
               {
                  this.tiCmd.text = _loc4_.substr(0,_loc5_ + 1) + param1;
                  break;
               }
               _loc5_--;
            }
         }
         else
         {
            this.tiCmd.text = (!!param2?"":"/") + param1 + " ";
         }
         this.tiCmd.caretIndex = this.tiCmd.text.length;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         switch(param1)
         {
            case this.btnClose:
               Console.getInstance().showConsole(false);
               break;
            case this.btnExtend:
               this.mainContainer.x = 100;
               this.mainContainer.y = 100;
               this.mainContainer.width = 1100;
               this.mainContainer.height = 500;
               this.uiApi.me().render();
               break;
            case this.btnReduce:
               if(this.mainContainer.height > 200)
               {
                  this.mainContainer.height = this.mainContainer.height - 200;
               }
               else
               {
                  this.mainContainer.height = 500;
               }
               this.uiApi.me().render();
               break;
            case this.btnClear:
               this.taConsole.text = "";
               break;
            case this.btnMenu:
               this._menu = [];
               _loc2_ = [];
               _loc3_ = [];
               _loc4_ = [];
               _loc5_ = [];
               this._menu.push(this.contextMod.createContextMenuItemObject("Opacity",null,null,false,_loc2_));
               _loc2_.push(this.contextMod.createContextMenuItemObject("33%",this.onAlphaChange,[33],false,null,this._options.opacity == 33));
               _loc2_.push(this.contextMod.createContextMenuItemObject("66%",this.onAlphaChange,[66],false,null,this._options.opacity == 66));
               _loc2_.push(this.contextMod.createContextMenuItemObject("100%",this.onAlphaChange,[100],false,null,this._options.opacity == 100));
               this.onAlphaChange(this._options.opacity);
               this._menu.push(this.contextMod.createContextMenuItemObject("Font size",null,null,false,_loc3_));
               _loc3_.push(this.contextMod.createContextMenuItemObject("14",this.onFontSizeChange,[14],false,null,this._options.fontSize == 14));
               _loc3_.push(this.contextMod.createContextMenuItemObject("16",this.onFontSizeChange,[16],false,null,this._options.fontSize == 16));
               _loc3_.push(this.contextMod.createContextMenuItemObject("20",this.onFontSizeChange,[20],false,null,this._options.fontSize == 20));
               this._menu.push(this.contextMod.createContextMenuItemObject("Open console",null,null,false,_loc4_));
               _loc4_.push(this.contextMod.createContextMenuItemObject("Manual",this.onOpenConsoleChange,[false],false,null,!this._options.openConsole));
               _loc4_.push(this.contextMod.createContextMenuItemObject("When receive message",this.onOpenConsoleChange,[true],false,null,this._options.openConsole));
               this._menu.push(this.contextMod.createContextMenuItemObject("Autocomplete mode",null,null,false,_loc5_));
               _loc5_.push(this.contextMod.createContextMenuItemObject("Show list",this.onChangeAutocomplete,[true],false,null,this._autoCompleteWithList));
               _loc5_.push(this.contextMod.createContextMenuItemObject("Command line",this.onChangeAutocomplete,[false],false,null,!this._autoCompleteWithList));
               this._menu.push(this.contextMod.createContextMenuItemObject("Autocomplete with history",this.onChangeAutocompleteWithHistory,null,false,null,this._autoCompleteWithHistory));
               this._menu.push(this.contextMod.createContextMenuItemObject("Save preset",this.onSavePreset,null,false,null,this._savePreset));
               this.contextMod.createContextMenu(this._menu);
               break;
            case this.btnBlock:
               this._blockScroll = !this._blockScroll;
               this.btnBlock.selected = this._blockScroll;
         }
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         this.onRelease(this.btnExtend);
      }
      
      private function onFontSizeChange(param1:uint) : void
      {
         this.taConsole.setCssSize(param1);
         this._options.fontSize = param1;
         this.sysApi.setData("consoleOption",this._options,DataStoreEnum.BIND_ACCOUNT);
      }
      
      private function onAlphaChange(param1:uint) : void
      {
         this.mainContainer.bgAlpha = param1 / 100;
         this._options.opacity = param1;
         this.sysApi.setData("consoleOption",this._options,DataStoreEnum.BIND_ACCOUNT);
      }
      
      private function onOpenConsoleChange(param1:Boolean) : void
      {
         this._options.openConsole = param1;
         this.sysApi.setData("consoleOption",this._options,DataStoreEnum.BIND_ACCOUNT);
      }
      
      private function onSavePreset() : void
      {
         this._savePreset = !this._savePreset;
         this._options.savePreset = this._savePreset;
         this.sysApi.setData("consoleOption",this._options,DataStoreEnum.BIND_ACCOUNT);
      }
      
      private function onChangeAutocomplete(param1:Boolean) : void
      {
         this._autoCompleteWithList = param1;
         this._options.autoCompleteWithList = this._autoCompleteWithList;
         this.sysApi.setData("consoleOption",this._options,DataStoreEnum.BIND_ACCOUNT);
         if(this._autoCompleteWithList && this._autoCompletePossibilities)
         {
            this._autoCompletePossibilities.length = 0;
         }
         this._autoCompleteRunning = false;
      }
      
      private function onChangeAutocompleteWithHistory() : void
      {
         this._autoCompleteWithHistory = !this._autoCompleteWithHistory;
         this._options.autoCompleteWithHistory = this._autoCompleteWithHistory;
         this.sysApi.setData("consoleOption",this._options,DataStoreEnum.BIND_ACCOUNT);
      }
      
      private function onCharacterSelectionStart(... rest) : void
      {
         this.updateInfo();
      }
      
      private function onConsoleClear() : void
      {
         this.taConsole.text = "";
      }
      
      private function onContextMenuClose() : void
      {
         if(this._lastInput != this.tiCmd.text)
         {
            this._autoCompleteRunning = false;
         }
      }
      
      public function onChange(param1:Object) : void
      {
         var _loc2_:* = false;
         if(this._lastInput && this.tiCmd.text)
         {
            _loc2_ = this._lastInput.length > this.tiCmd.text.length;
         }
         if(this._autoCompleteRunning && this.tiCmd.haveFocus && this._lastInput != this.tiCmd.text)
         {
            this.autoComplete(false,_loc2_);
         }
         this._lastInput = this.tiCmd.text;
      }
      
      private function onConsoleAddCmd(param1:Boolean, param2:String) : void
      {
         this.addCmd(param2,param1,false);
      }
      
      private function getBoldLength(param1:String, param2:String) : int
      {
         if(param1 == null || param2 == null)
         {
            return 0;
         }
         var _loc3_:Array = param1.split(" ");
         var _loc4_:Array = param2.split(" ");
         var _loc5_:int = String(_loc3_.pop()).length;
         var _loc6_:int = String(_loc4_.pop()).length;
         return _loc5_ < _loc6_?int(_loc5_):int(_loc6_);
      }
   }
}
