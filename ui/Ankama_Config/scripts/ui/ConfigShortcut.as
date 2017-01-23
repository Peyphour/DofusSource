package ui
{
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.shortcut.Bind;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2hooks.ShortcutUpdate;
   import flash.utils.Dictionary;
   
   public class ConfigShortcut extends ConfigUi
   {
       
      
      public var bindsApi:BindsApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var grid:Grid;
      
      public var cbKeyboard:ComboBox;
      
      public var btn_clearShortcuts:ButtonContainer;
      
      private var _lastSelectedIndex:int;
      
      private var _categoryCheckboxStates:Dictionary;
      
      private var _categoryCheckboxComponents:Dictionary;
      
      private var _lblShortcutNames:Dictionary;
      
      private var _buttonsList:Dictionary;
      
      private var _bindsList:Dictionary;
      
      private var _shortcutsList:Dictionary;
      
      private var _savedData:Dictionary;
      
      private var _currentShortcut:Shortcut;
      
      private var _shortcutsCat:Dictionary;
      
      public function ConfigShortcut()
      {
         this._categoryCheckboxStates = new Dictionary();
         this._categoryCheckboxComponents = new Dictionary();
         this._lblShortcutNames = new Dictionary(true);
         this._buttonsList = new Dictionary();
         this._bindsList = new Dictionary();
         this._shortcutsList = new Dictionary();
         this._shortcutsCat = new Dictionary();
         super();
      }
      
      public function main(param1:*) : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:String = null;
         this._savedData = sysApi.getData("openShortcutsCategory");
         if(this._savedData == null)
         {
            this._savedData = new Dictionary();
         }
         var _loc2_:Array = new Array();
         var _loc3_:Object = this.bindsApi.getShortcut();
         var _loc4_:Array = new Array();
         for each(_loc5_ in _loc3_)
         {
            if(!_loc5_.admin || sysApi.hasRight())
            {
               _loc4_.push(_loc5_);
            }
         }
         _loc4_.sortOn("unicID",Array.NUMERIC);
         _loc7_ = 0;
         _loc7_ = 0;
         while(_loc7_ < _loc4_.length)
         {
            _loc12_ = _loc4_[_loc7_];
            if(_loc12_.category.name != _loc6_)
            {
               _loc13_ = _loc2_.indexOf(_loc12_.category.description);
               if(_loc13_ == -1)
               {
                  _loc2_.push(!!_loc12_.category.description?_loc12_.category.description:"");
                  _loc2_.push(_loc12_);
                  _loc6_ = _loc12_.category.name;
                  this._shortcutsCat[_loc12_.category.description] = _loc6_;
               }
               else
               {
                  _loc14_ = 0;
                  _loc15_ = _loc13_;
                  _loc16_ = _loc2_.length;
                  while(++_loc15_ < _loc16_)
                  {
                     if(!(_loc2_[_loc15_] is String))
                     {
                        _loc14_++;
                        continue;
                     }
                     break;
                  }
                  _loc2_.splice(_loc13_ + _loc14_ + 1,0,_loc12_);
               }
            }
            else
            {
               _loc2_.push(_loc12_);
            }
            _loc7_++;
         }
         this.grid.dataProvider = _loc2_;
         var _loc8_:Array = new Array();
         var _loc9_:Object = this.bindsApi.availableKeyboards();
         _loc7_ = 0;
         for each(_loc11_ in _loc9_)
         {
            _loc17_ = _loc11_.description;
            _loc17_ = _loc17_.substr(1,_loc17_.length - 2);
            _loc8_.push({
               "label":uiApi.getText(_loc17_),
               "value":_loc11_.locale
            });
            if(_loc11_.locale == this.bindsApi.getCurrentLocale())
            {
               _loc10_ = _loc7_;
            }
            _loc7_++;
         }
         this._lastSelectedIndex = _loc10_;
         uiApi.addComponentHook(this.cbKeyboard,"onSelectItem");
         this.cbKeyboard.dataProvider = _loc8_;
         this.cbKeyboard.selectedIndex = _loc10_;
         sysApi.addHook(ShortcutUpdate,this.onShortcutUpdate);
      }
      
      override public function reset() : void
      {
         this.bindsApi.resetAllBinds();
         this.grid.updateItems();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         if(this.bindsApi.getCurrentLocale() != this.cbKeyboard.value.value)
         {
            _loc4_ = [uiApi.getText("ui.common.ok"),uiApi.getText("ui.common.cancel")];
            _loc5_ = [this.onKeyboardConfirm,this.onKeyboardCancel];
            this.modCommon.openPopup(uiApi.getText("ui.common.confirm"),uiApi.getText("ui.config.shortcut.confirm.changeKeyboard"),_loc4_,_loc5_,this.onKeyboardConfirm,this.onKeyboardCancel);
         }
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         if(param1.name.indexOf("btn_deactivateShortcuts") != -1)
         {
            this.handleCheckboxClick(param1);
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_clearShortcuts)
         {
            this.modCommon.openPopup(uiApi.getText("ui.common.confirm"),uiApi.getText("ui.popup.confirmCancelShortcuts"),[uiApi.getText("ui.common.ok"),uiApi.getText("ui.common.cancel")],[this.onClearShortcuts,null]);
         }
         else if(param1.name.indexOf("btn_deactivateShortcuts") != -1)
         {
            this.handleCheckboxClick(param1);
         }
         else
         {
            this._currentShortcut = this._shortcutsList[param1];
            uiApi.loadUi("configShortcutPopup",null,{
               "callback":this.onChangeShortcut,
               "shortcut":this._currentShortcut,
               "bind":this._bindsList[param1]
            },3);
         }
         super.onRelease(param1);
      }
      
      private function onClearShortcuts() : void
      {
         var _loc1_:Bind = null;
         var _loc3_:Object = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.grid.dataProvider)
         {
            if(!(_loc3_ is String) && Shortcut(_loc3_).visible && Shortcut(_loc3_).bindable)
            {
               _loc1_ = this.bindsApi.getShortcutBind(_loc3_.name,false);
               if(_loc1_ && _loc1_.key != null && !_loc1_.disabled)
               {
                  this.bindsApi.removeShortcutBind(_loc3_.name);
               }
            }
            _loc2_.push(_loc3_);
         }
         this.grid.dataProvider = _loc2_;
      }
      
      private function handleCheckboxClick(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         for(_loc2_ in this._categoryCheckboxComponents)
         {
            if(this._categoryCheckboxComponents[_loc2_] == param1)
            {
               this._categoryCheckboxStates[_loc2_] = param1.selected;
               break;
            }
         }
         _loc3_ = this.grid.dataProvider.indexOf(_loc2_);
         if(_loc3_ != -1)
         {
            this._savedData[this._shortcutsCat[_loc2_]] = param1.selected;
            this.deactivateShortcutsFromCategory(_loc3_ + 1,!param1.selected);
         }
      }
      
      private function deactivateShortcutsFromCategory(param1:int, param2:Boolean, param3:Boolean = true) : void
      {
         var _loc4_:Shortcut = null;
         var _loc5_:* = undefined;
         while(param1 < this.grid.dataProvider.length)
         {
            if(this.grid.dataProvider[param1] is String)
            {
               break;
            }
            if(param3)
            {
               _loc4_ = this.grid.dataProvider[param1];
               for(_loc5_ in this._shortcutsList)
               {
                  if(this._shortcutsList[_loc5_] != null)
                  {
                     if(this._shortcutsList[_loc5_].name == _loc4_.name && !this.bindsApi.bindIsPermanent(this.bindsApi.getShortcutBind(this.grid.dataProvider[param1].name,true)))
                     {
                        (_loc5_ as ButtonContainer).disabled = param2;
                        break;
                     }
                  }
               }
            }
            this.bindsApi.disableShortcut(this.grid.dataProvider[param1].name,param2);
            param1++;
         }
         sysApi.setData("openShortcutsCategory",this._savedData);
      }
      
      private function onChangeShortcut(param1:Bind) : void
      {
         if(this._currentShortcut == null)
         {
         }
         if(param1 != null)
         {
            this.bindsApi.setShortcutBind(this._currentShortcut.name,param1.key,param1.alt,param1.ctrl,param1.shift);
         }
         else
         {
            this.bindsApi.removeShortcutBind(this._currentShortcut.name);
         }
         this._currentShortcut = null;
      }
      
      private function onKeyboardConfirm() : void
      {
         this.bindsApi.changeKeyboard(this.cbKeyboard.value.value);
         this._lastSelectedIndex = this.cbKeyboard.selectedIndex;
      }
      
      private function onKeyboardCancel() : void
      {
         this.cbKeyboard.selectedIndex = this._lastSelectedIndex;
      }
      
      public function updateConfigLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:* = null;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:Bind = null;
         if(param1)
         {
            if(param1 is String)
            {
               for(_loc4_ in this._categoryCheckboxComponents)
               {
                  if(_loc4_ != param1 && this._categoryCheckboxComponents[_loc4_] == param2.btn_deactivateShortcuts)
                  {
                     this._categoryCheckboxComponents[_loc4_] = null;
                     break;
                  }
               }
               param2.lblDescription.cssClass = "oppositebold";
               param2.lblDescription.text = param1;
               param2.btnAssoc.visible = false;
               param2.shortcutLine.bgColor = sysApi.getConfigEntry("colors.grid.title");
               param2.btn_label_btn_deactivateShortcuts.fullWidth();
               param2.btn_deactivateShortcuts.x = param2.shortcutLine.contentWidth - param2.btn_label_btn_deactivateShortcuts.textWidth - 100;
               if(this._categoryCheckboxStates[param1] == null)
               {
                  _loc5_ = this.grid.dataProvider.indexOf(param1);
                  if(this._savedData[this._shortcutsCat[param1]] != null)
                  {
                     _loc6_ = this._savedData[this._shortcutsCat[param1]];
                     this._categoryCheckboxStates[param1] = _loc6_;
                     if(!_loc6_)
                     {
                        this.deactivateShortcutsFromCategory(_loc5_ + 1,true,false);
                     }
                     param2.btn_deactivateShortcuts.selected = _loc6_;
                  }
                  else
                  {
                     this._savedData[this._shortcutsCat[param1]] = true;
                     this._categoryCheckboxStates[param1] = true;
                     param2.btn_deactivateShortcuts.selected = true;
                  }
               }
               else
               {
                  if(this._categoryCheckboxComponents[param1] != param2.btn_deactivateShortcuts)
                  {
                     param2.btn_deactivateShortcuts.selected = this._categoryCheckboxStates[param1];
                  }
                  this._savedData[this._shortcutsCat[param1]] = param2.btn_deactivateShortcuts.selected;
                  this._categoryCheckboxComponents[param1] = param2.btn_deactivateShortcuts;
                  uiApi.addComponentHook(param2.btn_deactivateShortcuts,"onRelease");
                  uiApi.addComponentHook(param2.btn_deactivateShortcuts,"onDoubleClick");
               }
               param2.btn_deactivateShortcuts.visible = true;
            }
            else
            {
               param2.lblDescription.cssClass = "p";
               param2.btnAssoc.state = 0;
               param2.lblDescription.text = param1.description;
               param2.btn_lbl_btnAssoc.html = false;
               _loc7_ = this.bindsApi.getShortcutBind(param1.name,true);
               param2.btn_lbl_btnAssoc.text = _loc7_ && _loc7_.key?_loc7_.toString():"(" + uiApi.getText("ui.common.none") + ")";
               param2.btnAssoc.visible = true;
               param2.shortcutLine.bgColor = -1;
               param2.lblDescription.visible = true;
               param2.btn_deactivateShortcuts.visible = false;
               param2.btnAssoc.disabled = this.bindsApi.bindIsPermanent(_loc7_) || param1.disable;
               param2.btnAssoc.reset();
               this._buttonsList[param1] = {
                  "button":param2.btnAssoc,
                  "label":param2.btn_lbl_btnAssoc
               };
               this._bindsList[param2.btnAssoc] = _loc7_;
               this._shortcutsList[param2.btnAssoc] = param1;
               uiApi.addComponentHook(param2.btnAssoc,"onRelease");
               if(!this._lblShortcutNames[param2.lblDescription.name])
               {
                  uiApi.addComponentHook(param2.lblDescription,ComponentHookList.ON_ROLL_OVER);
                  uiApi.addComponentHook(param2.lblDescription,ComponentHookList.ON_ROLL_OUT);
               }
               this._lblShortcutNames[param2.lblDescription.name] = param1.tooltipContent;
            }
         }
         else
         {
            param2.lblDescription.cssClass = "p";
            param2.btnAssoc.visible = false;
            param2.lblDescription.visible = false;
         }
      }
      
      private function onShortcutUpdate(param1:String, param2:Bind) : void
      {
         var _loc3_:Object = null;
         if(this._currentShortcut != null)
         {
            _loc3_ = this._buttonsList[this._currentShortcut];
            _loc3_.button.state = 0;
            _loc3_.label.text = param2 != null && param2.key != null?param2.toString():"(" + uiApi.getText("ui.common.none") + ")";
            _loc3_.button.reset();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         if(param1.name.indexOf("lblDescription") != -1)
         {
            _loc2_ = this._lblShortcutNames[param1.name];
         }
         if(_loc2_)
         {
            uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
   }
}
