package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsWrapper;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.ChatTextOutput;
   import d2actions.TimelineEntityOut;
   import d2actions.TimelineEntityOver;
   import d2enums.ChatActivableChannelsEnum;
   import d2enums.LocationEnum;
   import d2hooks.BuffAdd;
   import d2hooks.BuffRemove;
   import d2hooks.BuffUpdate;
   import d2hooks.GameFightTurnStart;
   import d2hooks.UiLoaded;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import ui.items.BuffItem;
   
   public class Buffs
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var fightApi:FightApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _buffItems:Dictionary;
      
      private var _durationSort:Array;
      
      private var _nPlayerId:Number;
      
      private var _expanded:Boolean = false;
      
      private var _casterId:Number;
      
      private var _lastWasPlayer:Boolean = false;
      
      private var _rollOverTarget:Object = null;
      
      private var _backgroundWidthModifier:int;
      
      private var _backgroundOffset:int;
      
      public var tx_background:TextureBitmap;
      
      public var btn_decoRight:ButtonContainer;
      
      public var tx_button_minimize:Texture;
      
      public var tx_button_minimize_bgLeft:Texture;
      
      public var buffsCtr:GraphicContainer;
      
      public var buffListCtr:GraphicContainer;
      
      public var anchorCtr:GraphicContainer;
      
      public var expandedCtr:GraphicContainer;
      
      public function Buffs()
      {
         super();
      }
      
      private static function sortCastingSpellGroup(param1:BuffItem, param2:BuffItem) : int
      {
         return param1.maxCooldown - param2.maxCooldown;
      }
      
      public function main(param1:Number) : void
      {
         this.sysApi.addHook(GameFightTurnStart,this.onGameFightTurnStart);
         this.sysApi.addHook(BuffUpdate,this.onBuffUpdate);
         this.sysApi.addHook(BuffRemove,this.onBuffRemove);
         this.sysApi.addHook(BuffAdd,this.onBuffAdd);
         this.sysApi.addHook(UiLoaded,this.onUiLoaded);
         this.uiApi.addComponentHook(this.btn_decoRight,"onRollOver");
         this.uiApi.addComponentHook(this.btn_decoRight,"onRollOut");
         this.uiApi.addComponentHook(this.tx_button_minimize_bgLeft,"onRollOver");
         this.uiApi.addComponentHook(this.tx_button_minimize_bgLeft,"onRollOut");
         this._backgroundWidthModifier = this.uiApi.me().getConstant("backgroundWidthModifier");
         this._backgroundOffset = this.uiApi.me().getConstant("backgroundOffset");
         this._nPlayerId = param1;
         this.makeItemBuffs(param1);
         this.updateUi();
      }
      
      public function unload() : void
      {
      }
      
      public function set folded(param1:Boolean) : void
      {
         if(param1)
         {
            this.buffListCtr.visible = false;
            this.tx_background.visible = false;
            this.tx_button_minimize.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_plus_floating_menu.png");
         }
         else
         {
            this.buffListCtr.visible = true;
            this.tx_background.visible = true;
            this.tx_button_minimize.uri = this.uiApi.createUri(this.uiApi.me().getConstant("texture") + "hud/icon_minus_floating_menu.png");
         }
      }
      
      private function makeItemBuffs(param1:Number) : void
      {
         var _loc3_:Object = null;
         this._buffItems = new Dictionary();
         this._durationSort = new Array();
         var _loc2_:Object = this.fightApi.getBuffList(param1);
         for each(_loc3_ in _loc2_)
         {
            if(!_loc3_.effect || _loc3_.effect.visibleInBuffUi)
            {
               this.internalAddBuff(_loc3_);
            }
         }
      }
      
      private function newBuffItem(param1:Object) : BuffItem
      {
         var _loc2_:int = -1;
         if(param1.effect.delay > 0)
         {
            _loc2_ = BuffItem.getEndDelayTurn(param1);
         }
         var _loc3_:BuffItem = new BuffItem(param1.castingSpell.spell.id,param1.castingSpell.casterId,param1.parentBoostUid,_loc2_,this.uiApi.me().getConstant("spell_size"),this.uiApi.me().getConstant("css_uri"),this.buffListCtr);
         this.uiApi.addComponentHook(_loc3_.btn_buff,"onRelease");
         this.uiApi.addComponentHook(_loc3_.btn_buff,"onRollOver");
         this.uiApi.addComponentHook(_loc3_.btn_buff,"onRollOut");
         _loc3_.addBuff(param1);
         return _loc3_;
      }
      
      private function updateUi() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:BuffItem = null;
         var _loc4_:BuffItem = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(this._expanded)
         {
            this.tx_background.width = 0;
            this.buffListCtr.width = 0;
            this.expandedCtr.x = this.anchorCtr.x;
            this.expandedCtr.y = this.anchorCtr.y;
            this.uiApi.showTooltip(this._durationSort,null,false,"effectsDuration",8,6,3,"effectsDuration",null,null,null,false,2);
         }
         else
         {
            _loc1_ = new Array();
            _loc2_ = new Array();
            for each(_loc3_ in this._buffItems)
            {
               if(_loc3_.parentBoostUid != 0)
               {
                  _loc2_.push(_loc3_);
               }
               else
               {
                  _loc1_.push(_loc3_);
               }
            }
            _loc1_.sort(sortCastingSpellGroup);
            for each(_loc4_ in _loc2_)
            {
               _loc8_ = false;
               _loc9_ = 0;
               _loc10_ = 0;
               while(_loc10_ < _loc1_.length)
               {
                  if(_loc1_[_loc10_].maxCooldown < _loc4_.cooldown)
                  {
                     _loc9_ = _loc10_;
                  }
                  if(_loc1_[_loc10_].hasUid(_loc4_.parentBoostUid))
                  {
                     _loc1_.splice(_loc10_ + 1,0,_loc4_);
                     _loc8_ = true;
                     break;
                  }
                  _loc10_++;
               }
               if(!_loc8_)
               {
                  _loc1_.splice(_loc9_,0,_loc4_);
               }
            }
            _loc5_ = _loc1_.length * this.uiApi.me().getConstant("spell_size") + (_loc1_.length - 1) * this.uiApi.me().getConstant("spell_offset_horizontal");
            if(_loc5_ < 0)
            {
               _loc5_ = 0;
            }
            _loc6_ = _loc5_;
            _loc7_ = 0;
            for each(_loc3_ in _loc1_)
            {
               _loc6_ = _loc6_ - this.uiApi.me().getConstant("spell_size");
               _loc3_.x = _loc6_;
               _loc3_.y = _loc7_;
               _loc6_ = _loc6_ - this.uiApi.me().getConstant("spell_offset_horizontal");
            }
            this.tx_background.width = _loc5_ + 2 * this.uiApi.me().getConstant("spell_offset_horizontal") + this.btn_decoRight.width + this._backgroundWidthModifier;
            this.expandedCtr.width = 0;
            this.btn_decoRight.reset();
            this.refreshBuffTooltips();
         }
         this.buffsCtr.x = this.anchorCtr.x - this.tx_background.width + 6;
         this.buffsCtr.y = this.anchorCtr.y + 6;
         this.btn_decoRight.x = this.tx_background.width - 20;
         this.uiApi.me().render();
      }
      
      private function updateBuff(param1:uint) : void
      {
         var _loc3_:String = null;
         var _loc4_:BuffItem = null;
         var _loc5_:String = null;
         var _loc2_:Object = this.fightApi.getBuffById(param1,this._nPlayerId);
         if(_loc2_)
         {
            if(_loc2_.hasOwnProperty("isSilent") && _loc2_.isSilent)
            {
               return;
            }
            if(_loc2_.effect && !_loc2_.effect.visibleInBuffUi)
            {
               return;
            }
            _loc3_ = BuffItem.getKey(_loc2_);
            _loc4_ = this._buffItems[_loc3_];
            if(!_loc4_)
            {
               _loc5_ = BuffItem.getKey(_loc2_,true);
               _loc4_ = this._buffItems[_loc5_];
               if(!_loc4_)
               {
                  this.sysApi.log(16,"Failed to update unknown buff with key " + _loc3_);
                  return;
               }
               delete this._buffItems[_loc5_];
               this._buffItems[_loc3_] = _loc4_;
               _loc4_.btn_buff.name = "buff_" + _loc3_;
            }
            else
            {
               _loc4_.update(_loc2_);
               this.updateUi();
            }
         }
      }
      
      private function internalAddBuff(param1:Object) : void
      {
         var _loc4_:BuffItem = null;
         var _loc5_:Object = null;
         if(param1 && param1.hasOwnProperty("isSilent") && param1.isSilent)
         {
            return;
         }
         var _loc2_:String = BuffItem.getKey(param1);
         if(this._buffItems.hasOwnProperty(_loc2_))
         {
            this._buffItems[_loc2_].addBuff(param1);
         }
         else
         {
            _loc4_ = this.newBuffItem(param1);
            this._buffItems[_loc2_] = _loc4_;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._durationSort.length)
         {
            _loc5_ = this._durationSort[_loc3_];
            if(_loc5_.duration < param1.effect.duration)
            {
               break;
            }
            _loc3_++;
         }
         this._durationSort.splice(_loc3_,0,param1.effect);
      }
      
      private function addBuff(param1:uint) : void
      {
         var _loc2_:Object = this.fightApi.getBuffById(param1,this._nPlayerId);
         if(_loc2_.effect && !_loc2_.effect.visibleInBuffUi)
         {
            return;
         }
         this.internalAddBuff(_loc2_);
         this.updateUi();
      }
      
      private function removeBuff(param1:*) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc2_:Object = param1 is uint?this.fightApi.getBuffById(param1,this._nPlayerId):param1;
         if(_loc2_ && _loc2_.hasOwnProperty("isSilent") && _loc2_.isSilent)
         {
            return;
         }
         if(_loc2_.effect && !_loc2_.effect.visibleInBuffUi)
         {
            return;
         }
         this.removeBuffItem(_loc2_);
         var _loc3_:int = 0;
         while(_loc3_ < this._durationSort.length)
         {
            _loc4_ = this._durationSort[_loc3_];
            if(_loc4_ == _loc2_.effect)
            {
               this._durationSort.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         if(this._rollOverTarget)
         {
            _loc5_ = this._rollOverTarget.name.substr(5,this._rollOverTarget.name.length);
            if(BuffItem.getKey(_loc2_) == _loc5_)
            {
               this.uiApi.hideTooltip();
            }
         }
         this.updateUi();
      }
      
      private function removeBuffItem(param1:Object) : void
      {
         var _loc2_:Boolean = param1.hasOwnProperty("delay");
         var _loc3_:String = BuffItem.getKey(param1,_loc2_);
         var _loc4_:BuffItem = this._buffItems[_loc3_];
         if(_loc2_ && !_loc4_)
         {
            _loc3_ = BuffItem.getKey(param1,true,-1);
            _loc4_ = this._buffItems[_loc3_];
            if(!_loc4_)
            {
               _loc3_ = BuffItem.getKey(param1,true,1);
               _loc4_ = this._buffItems[_loc3_];
               if(!_loc4_)
               {
                  _loc3_ = BuffItem.getKey(param1);
                  _loc4_ = this._buffItems[_loc3_];
               }
            }
         }
         if(_loc4_)
         {
            _loc4_.removeBuff(param1);
            if(_loc4_.buffs.length == 0)
            {
               _loc4_.btn_buff.visible = false;
               delete this._buffItems[_loc3_];
            }
         }
         else
         {
            this.sysApi.log(16,"removeBuffItem() failed to remove buff with key " + _loc3_ + " as no matching buffItem has been found.");
         }
      }
      
      private function refreshBuffTooltips() : void
      {
         var _loc1_:String = null;
         var _loc2_:BuffItem = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:EffectsWrapper = null;
         if(this._rollOverTarget)
         {
            _loc1_ = this._rollOverTarget.name.substr(5,this._rollOverTarget.name.length);
            _loc2_ = this._buffItems[_loc1_];
            if(_loc2_)
            {
               _loc3_ = new Array();
               this._casterId = -1;
               for each(_loc4_ in _loc2_.buffs)
               {
                  _loc5_ = {};
                  _loc6_ = describeType(_loc4_.effect);
                  for each(_loc7_ in _loc6_..accessor.@name)
                  {
                     _loc5_[_loc7_] = _loc4_.effect[_loc7_];
                  }
                  _loc5_.description = _loc4_.effect.description;
                  _loc5_.theoreticalDescription = _loc4_.effect.theoreticalDescription;
                  _loc5_.durationString = _loc4_.effect.durationString;
                  _loc5_.category = _loc4_.effect.category;
                  _loc5_.order = _loc4_.effect.order;
                  _loc5_.bonusType = _loc4_.effect.bonusType;
                  _loc5_.oppositeId = _loc4_.effect.oppositeId;
                  _loc5_.showInSet = _loc4_.effect.showInSet;
                  _loc5_.parameter0 = _loc4_.effect.parameter0;
                  _loc5_.parameter1 = _loc4_.effect.parameter1;
                  _loc5_.parameter2 = _loc4_.effect.parameter2;
                  _loc5_.parameter3 = _loc4_.effect.parameter3;
                  _loc5_.parameter4 = _loc4_.effect.parameter4;
                  _loc5_.visibleInTooltip = true;
                  _loc3_.push(_loc5_);
                  this._casterId = _loc4_.source;
               }
               if(this.fightApi)
               {
                  _loc8_ = this.fightApi.getFighterName(this._casterId);
                  _loc9_ = this.fightApi.createEffectsWrapper(_loc2_.spell,_loc3_,_loc8_);
                  if(this._casterId != -1)
                  {
                     this.sysApi.sendAction(new TimelineEntityOver(this._casterId,false));
                  }
                  this.uiApi.showTooltip(_loc9_,this._rollOverTarget,false,"standard",LocationEnum.POINT_BOTTOMRIGHT,LocationEnum.POINT_TOPRIGHT,10,null,null,null,null,false,5);
               }
            }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:BuffItem = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:* = null;
         if(param1 == this.btn_decoRight)
         {
            this.folded = this.buffListCtr.visible;
            return;
         }
         if(this.uiApi.keyIsDown(Keyboard.ALTERNATE) && param1.name.indexOf("buff_") == 0)
         {
            _loc2_ = (param1.name as String).slice(5);
            _loc3_ = this._buffItems[_loc2_];
            _loc4_ = _loc3_.spell.name;
            _loc5_ = "";
            if(this._nPlayerId == this.playerApi.id())
            {
               if(_loc3_.cooldown == -1000)
               {
                  _loc5_ = this.uiApi.getText("ui.fightAutomsg.buff.endless.me",_loc4_);
               }
               else
               {
                  _loc6_ = _loc3_.delay;
                  if(_loc6_ > 0)
                  {
                     _loc5_ = this.uiApi.getText("ui.fightAutomsg.buff.trigger.me",_loc4_,_loc6_);
                  }
                  else
                  {
                     _loc5_ = this.uiApi.getText("ui.fightAutomsg.buff.me",_loc4_,_loc3_.cooldown);
                  }
               }
            }
            else
            {
               _loc7_ = "{entity," + this._nPlayerId + "," + 1 + "}";
               if(_loc3_.cooldown == -1000)
               {
                  _loc5_ = this.uiApi.getText("ui.fightAutomsg.buff.endless.target",_loc7_,_loc4_);
               }
               else
               {
                  _loc6_ = _loc3_.delay;
                  if(_loc6_ > 0)
                  {
                     _loc5_ = this.uiApi.getText("ui.fightAutomsg.buff.trigger.target",_loc7_,_loc4_,_loc6_);
                  }
                  else
                  {
                     _loc5_ = this.uiApi.getText("ui.fightAutomsg.buff.target",_loc7_,_loc4_,_loc3_.cooldown);
                  }
               }
            }
            if(_loc5_ != "")
            {
               this.sysApi.sendAction(new ChatTextOutput(_loc5_,ChatActivableChannelsEnum.CHANNEL_TEAM,null,null));
            }
         }
      }
      
      public function get expanded() : Boolean
      {
         return this._expanded;
      }
      
      public function set expanded(param1:Boolean) : void
      {
         if(param1 != this._expanded)
         {
            this._expanded = param1;
            if(this._expanded)
            {
               this.buffListCtr.visible = false;
               this.tx_background.visible = false;
               this.updateUi();
            }
            else
            {
               this.buffListCtr.visible = true;
               this.tx_background.visible = true;
               this.uiApi.hideTooltip("effectsDuration");
               this.uiApi.unloadUi("tooltip_effectDuration");
               this.updateUi();
            }
         }
      }
      
      public function onUiLoaded(param1:String) : void
      {
         var _loc2_:* = undefined;
         if(param1 == "tooltip_effectsDuration")
         {
            _loc2_ = this.uiApi.getUi(param1);
            _loc2_.x = 0;
            _loc2_.y = 0;
            this.expandedCtr.width = _loc2_.width;
            if(_loc2_.height > 500)
            {
               this.expandedCtr.height = 500;
            }
            else
            {
               this.expandedCtr.height = _loc2_.height;
            }
            this.expandedCtr.addContent(_loc2_);
            _loc2_.x = -_loc2_.width + 5;
            _loc2_.y = -_loc2_.height + 45;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1.name.substr(0,4) == "buff")
         {
            this._rollOverTarget = param1;
            this.refreshBuffTooltips();
         }
         else if(param1 == this.btn_decoRight || param1 == this.tx_button_minimize_bgLeft)
         {
            _loc2_ = this.fightApi.getAllBuffEffects(this._nPlayerId);
            if(_loc2_ != null && _loc2_.categories.length > 0)
            {
               this.uiApi.showTooltip(_loc2_,param1,false,"standard",this.sysApi.getEnum("com.ankamagames.berilia.types.LocationEnum").POINT_BOTTOMRIGHT);
            }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         if(this._casterId != -1)
         {
            if(this.sysApi)
            {
               this.sysApi.sendAction(new TimelineEntityOut(this._casterId));
            }
         }
         this._rollOverTarget = null;
         if(this.uiApi)
         {
            this.uiApi.hideTooltip();
         }
      }
      
      public function onBuffUpdate(param1:uint, param2:Number) : void
      {
         if(param2 == this._nPlayerId)
         {
            this.updateBuff(param1);
         }
      }
      
      public function onBuffAdd(param1:uint, param2:Number) : void
      {
         if(param2 == this._nPlayerId)
         {
            this.addBuff(param1);
         }
      }
      
      public function onBuffRemove(param1:*, param2:Number, param3:String) : void
      {
         if(param2 == this._nPlayerId)
         {
            this.removeBuff(param1);
         }
      }
      
      public function onGameFightTurnStart(param1:Number, param2:int, param3:uint, param4:Object) : void
      {
         var _loc5_:BuffItem = null;
         if(param1 == this.playerApi.id())
         {
            this._lastWasPlayer = true;
         }
         else if(this._lastWasPlayer)
         {
            for each(_loc5_ in this._buffItems)
            {
               _loc5_.updateCooldown();
            }
            this._lastWasPlayer = false;
         }
      }
   }
}
