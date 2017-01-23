package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.fight.FighterInformations;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.TimelineEntityClick;
   import d2actions.TimelineEntityOut;
   import d2actions.TimelineEntityOver;
   import d2enums.ComponentHookList;
   import d2enums.TeamEnum;
   import d2hooks.BuffAdd;
   import d2hooks.BuffDispell;
   import d2hooks.BuffRemove;
   import d2hooks.BuffUpdate;
   import d2hooks.FightEvent;
   import d2hooks.FighterInfoUpdate;
   import d2hooks.FighterSelected;
   import d2hooks.FightersListUpdated;
   import d2hooks.FoldAll;
   import d2hooks.GameFightTurnEnd;
   import d2hooks.GameFightTurnStart;
   import d2hooks.HideDeadFighters;
   import d2hooks.HideSummonedFighters;
   import d2hooks.OrderFightersSwitched;
   import d2hooks.TurnCountUpdated;
   import d2hooks.UpdatePreFightersList;
   import d2hooks.WaveUpdated;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.utils.Dictionary;
   import ui.timeline.Fighter;
   
   public class Timeline
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var fightApi:FightApi;
      
      private var _fighters:Array;
      
      private var _hiddenFighters:Array;
      
      private var _fightersId:Object;
      
      private var _foldAllStatus:Boolean = false;
      
      private var _hideDeadGuys:Boolean = false;
      
      private var _hideSummonedStuff:Boolean = false;
      
      private var _selectedFighter:Fighter = null;
      
      private var _turnOf:Fighter = null;
      
      private var _timelineMask:Sprite;
      
      private var _screenWidth:int;
      
      private var _charCtrOffset:int;
      
      private var _turnCount:uint = 1;
      
      private var _waveCountAttackers:uint = 0;
      
      private var _turnCountBeforeNextWaveAttackers:int = -1;
      
      private var _waveCountDefenders:uint = 0;
      
      private var _turnCountBeforeNextWaveDefenders:int = -1;
      
      private var _topDisplayMode:Boolean;
      
      private var _rollOverMe:Boolean = false;
      
      private var _prefightPhase:Boolean = true;
      
      public var timelineCtr:GraphicContainer;
      
      public var charCtr:GraphicContainer;
      
      public var charFrames:GraphicContainer;
      
      public var ctr_timeline:GraphicContainer;
      
      public var ctr_buffs:GraphicContainer;
      
      public var lbl_turnCount:Label;
      
      public var btn_minimArrow:ButtonContainer;
      
      public var btn_rightArrow:ButtonContainer;
      
      public var btn_leftArrow:ButtonContainer;
      
      public var btn_up:ButtonContainer;
      
      public var btn_down:ButtonContainer;
      
      public var tx_currentArrow:Texture;
      
      public var ctr_background:GraphicContainer;
      
      public var ctr_inviBounds:GraphicContainer;
      
      public var tx_wave:Texture;
      
      public function Timeline()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(GameFightTurnEnd,this.onGameFightTurnEnd);
         this.sysApi.addHook(FightersListUpdated,this.onGameFightTurnListUpdated);
         this.sysApi.addHook(UpdatePreFightersList,this.onUpdatePreFightersList);
         this.sysApi.addHook(GameFightTurnStart,this.onGameFightTurnStart);
         this.sysApi.addHook(FightEvent,this.onFightEvent);
         this.sysApi.addHook(FoldAll,this.onFoldAll);
         this.sysApi.addHook(FighterSelected,this.onFighterSelected);
         this.sysApi.addHook(BuffAdd,this.onBuffAdd);
         this.sysApi.addHook(BuffDispell,this.onBuffDispell);
         this.sysApi.addHook(BuffRemove,this.onBuffRemove);
         this.sysApi.addHook(BuffUpdate,this.onBuffUpdate);
         this.sysApi.addHook(TurnCountUpdated,this.onTurnCountUpdated);
         this.sysApi.addHook(OrderFightersSwitched,this.onOrderFightersSwitched);
         this.sysApi.addHook(HideDeadFighters,this.onHideDeadFighters);
         this.sysApi.addHook(HideSummonedFighters,this.onHideSummonedFighters);
         this.sysApi.addHook(WaveUpdated,this.onWaveUpdated);
         this.sysApi.addHook(FighterInfoUpdate,this.onFighterMouseAction);
         this.uiApi.addComponentHook(this.lbl_turnCount,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_turnCount,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_wave,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_wave,ComponentHookList.ON_ROLL_OUT);
         this._fighters = new Array();
         this._hiddenFighters = new Array();
         this.tx_currentArrow.visible = false;
         var _loc2_:GlowFilter = new GlowFilter(Api.sysApi.getConfigEntry("colors.text.glow.dark"),0.8,2,2,6,3);
         this.lbl_turnCount.filters = [_loc2_];
         this._screenWidth = this.uiApi.getStageWidth();
         this._charCtrOffset = int(this.uiApi.me().getConstant("char_ctr_offset"));
         this._topDisplayMode = this.sysApi.getData("topDisplayTimeline");
         this._hideDeadGuys = this.sysApi.getOption("hideDeadFighters","dofus");
         this._hideSummonedStuff = this.sysApi.getOption("hideSummonedFighters","dofus");
         this._timelineMask = new Sprite();
         this._timelineMask.graphics.beginFill(16733440);
         this._timelineMask.graphics.drawRect(-this._screenWidth + 170,0,this._screenWidth - 110,this.timelineCtr.height);
         this._timelineMask.graphics.endFill();
         this.timelineCtr.addChild(this._timelineMask);
         this._timelineMask.visible = false;
         this.replaceTimeline();
      }
      
      public function unload() : void
      {
         var _loc2_:Fighter = null;
         Fighter.cleanFramesPool();
         var _loc1_:int = 0;
         while(_loc1_ < this._fighters.length)
         {
            _loc2_ = this._fighters[_loc1_];
            _loc2_.destroy();
            _loc1_++;
         }
         this._fighters = null;
         this._hiddenFighters = null;
      }
      
      public function set folded(param1:Boolean) : void
      {
         var _loc2_:Boolean = this.isTimelineExtended();
         this.btn_leftArrow.visible = !param1 && _loc2_;
         this.btn_rightArrow.visible = !param1 && _loc2_;
         this.charFrames.visible = !param1;
         if(!this._prefightPhase)
         {
            this.tx_currentArrow.visible = !param1;
         }
         this.ctr_background.visible = !param1;
         this.lbl_turnCount.visible = !param1;
         this.tx_wave.visible = !param1 && (this._waveCountAttackers > 0 || this._waveCountDefenders > 0);
         this.fightApi.setSwapPositionRequestsIconsVisibility(!param1);
      }
      
      public function get folded() : Boolean
      {
         return !this.charFrames.visible;
      }
      
      public function moveLeft() : void
      {
         var _loc1_:int = this.charCtr.contentWidth - this._timelineMask.width - this._charCtrOffset;
         if(this.charFrames.x + this._charCtrOffset + 300 < this._timelineMask.x + _loc1_)
         {
            this.charFrames.x = this.charFrames.x + 300;
         }
         else
         {
            this.charFrames.x = this._timelineMask.x + _loc1_;
         }
         this.updateTurnOfArrow();
      }
      
      public function moveRight() : void
      {
         if(this.charFrames.x + this._charCtrOffset > this._timelineMask.x + 300)
         {
            this.charFrames.x = this.charFrames.x - 300;
         }
         else
         {
            this.charFrames.x = this._timelineMask.x;
         }
         this.updateTurnOfArrow();
      }
      
      public function refreshMoveOffset() : void
      {
         if(this.charCtr.contentWidth <= this._timelineMask.width)
         {
            this.charFrames.x = -this.charFrames.width;
         }
         else if(this.charFrames.x + this._charCtrOffset < this._timelineMask.x)
         {
            this.charFrames.x = this._timelineMask.x;
         }
         else if(this.charFrames.x + this._charCtrOffset - this.charCtr.contentWidth > this._timelineMask.x - this._timelineMask.width)
         {
            this.charFrames.x = this._timelineMask.x - this._timelineMask.width + this.charCtr.contentWidth;
         }
      }
      
      private function createFighter(param1:Number, param2:uint) : Fighter
      {
         var _loc3_:Fighter = new Fighter(param1,this.uiApi.me(),param2);
         this.uiApi.addComponentHook(_loc3_.frame,"onRelease");
         this.uiApi.addComponentHook(_loc3_.frame,"onRollOver");
         this.uiApi.addComponentHook(_loc3_.frame,"onRollOut");
         this.charCtr.addChild(_loc3_.frame);
         return _loc3_;
      }
      
      private function refreshTimeline() : void
      {
         var _loc2_:Fighter = null;
         var _loc3_:Fighter = null;
         var _loc7_:Number = NaN;
         var _loc8_:FighterInformations = null;
         var _loc9_:Boolean = false;
         var _loc10_:Number = NaN;
         var _loc1_:Dictionary = new Dictionary();
         for each(_loc3_ in this._fighters)
         {
            _loc1_[_loc3_.id] = _loc3_;
         }
         this._fightersId = this.fightApi.getFighters();
         if(!this._fightersId)
         {
            this._fightersId = new Array();
         }
         var _loc4_:Object = this.fightApi.getDeadFighters();
         if(!_loc4_)
         {
            _loc4_ = new Array();
         }
         this._fighters = new Array();
         this._hiddenFighters = new Array();
         var _loc5_:uint = this._fightersId.length - _loc4_.length;
         var _loc6_:int = this._fightersId.length - 1;
         while(_loc6_ >= 0)
         {
            _loc7_ = this._fightersId[_loc6_];
            _loc8_ = Api.fightApi.getFighterInformations(_loc7_);
            _loc9_ = true;
            for each(_loc10_ in _loc4_)
            {
               if(_loc10_ == _loc7_)
               {
                  _loc9_ = false;
                  break;
               }
            }
            if(_loc1_[_loc7_])
            {
               if((!this._hideDeadGuys || _loc9_) && (!this._hideSummonedStuff || !_loc1_[_loc7_].summoned))
               {
                  _loc2_ = _loc1_[_loc7_];
                  _loc2_.alive = _loc9_;
                  _loc2_.updateNumber(_loc5_);
                  if(!_loc2_.alive)
                  {
                     _loc5_++;
                  }
                  _loc1_[_loc7_] = null;
                  this._fighters.push(_loc2_);
               }
               else
               {
                  this._hiddenFighters[_loc7_] = {
                     "id":_loc7_,
                     "alive":_loc9_,
                     "summoned":_loc1_[_loc7_].summoned
                  };
                  this.charCtr.removeChild(_loc1_[_loc7_].frame);
                  _loc1_[_loc7_].destroy(true);
                  _loc2_ = null;
                  if(!_loc9_)
                  {
                     _loc5_++;
                  }
               }
            }
            else
            {
               _loc8_ = Api.fightApi.getFighterInformations(_loc7_);
               if(_loc8_ && (!this._hideDeadGuys || _loc9_) && (!this._hideSummonedStuff || !_loc8_.summoned))
               {
                  _loc2_ = this.createFighter(_loc7_,_loc5_);
                  _loc2_.alive = _loc9_;
                  if(!_loc2_.alive)
                  {
                     _loc5_++;
                  }
                  this.charCtr.addChild(_loc2_.frame);
                  this._fighters.push(_loc2_);
               }
               else
               {
                  if(!_loc9_)
                  {
                     _loc5_++;
                  }
                  if(_loc8_)
                  {
                     this._hiddenFighters[_loc7_] = {
                        "id":_loc7_,
                        "alive":_loc9_,
                        "summoned":_loc8_.summoned
                     };
                  }
               }
            }
            _loc5_--;
            _loc6_--;
         }
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_)
            {
               _loc2_.frame.removeFromParent();
               if(_loc4_.length > 0)
               {
                  _loc2_.destroy();
               }
               else
               {
                  _loc2_.destroy(true);
               }
            }
         }
         this.resizeTimeline();
      }
      
      private function selectFighter(param1:Fighter) : void
      {
         if(this._selectedFighter)
         {
            this._selectedFighter.selected = false;
         }
         if(this._selectedFighter != param1)
         {
            this._selectedFighter = param1;
            param1.selected = true;
         }
         else
         {
            this._selectedFighter = null;
         }
      }
      
      private function setTurnOf(param1:Fighter, param2:int, param3:uint) : void
      {
         this._turnOf = param1;
         if(!param1.risen)
         {
            param1.risen = true;
         }
         param1.startCountDown(param2,param3);
         this.updateTurnOfArrow();
      }
      
      private function updateTurnOfArrow() : void
      {
         if(this._turnOf)
         {
            if(!this.tx_currentArrow.visible)
            {
               this.tx_currentArrow.visible = true;
               this._prefightPhase = false;
            }
            this.tx_currentArrow.x = this._turnOf.frame.x + int(this._turnOf.frame.width / 2) - this.tx_currentArrow.height / 2 - 7;
         }
      }
      
      private function unsetTurnOf(param1:Fighter) : void
      {
         if(this._turnOf == param1)
         {
            this._turnOf = null;
         }
         param1.risen = false;
         param1.stopCountDown();
      }
      
      private function getFighterByFrame(param1:Object) : Fighter
      {
         var _loc2_:Fighter = null;
         for each(_loc2_ in this._fighters)
         {
            if(_loc2_.frame == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getFighterById(param1:Number) : Fighter
      {
         var _loc2_:Fighter = null;
         for each(_loc2_ in this._fighters)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function resizeTimeline() : void
      {
         var _loc4_:Fighter = null;
         var _loc5_:int = 0;
         var _loc1_:int = this.uiApi.me().getConstant("frame_offset_horizontal");
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < this._fighters.length)
         {
            _loc4_ = this._fighters[_loc5_];
            if(_loc4_)
            {
               if(_loc5_ != 0)
               {
                  _loc2_ = _loc2_ + (_loc4_.frame.width + _loc1_);
               }
               _loc3_ = _loc3_ + (_loc4_.frame.width + _loc1_);
               _loc4_.frame.x = -_loc2_;
            }
            _loc5_++;
         }
         var _loc6_:int = this.uiApi.me().getConstant("bg_margin_right");
         var _loc7_:int = this.uiApi.me().getConstant("bg_margin_left");
         this.ctr_background.width = _loc3_ + _loc6_ + _loc7_;
         if(this.ctr_background.width > this._screenWidth - 20)
         {
            this.ctr_background.width = this._screenWidth - 20;
         }
         this.refreshMoveOffset();
         if(this.isTimelineExtended())
         {
            this.btn_leftArrow.x = -this.ctr_background.width + int(this.uiApi.me().getConstant("bg_margin_left_to_arrow"));
            this.btn_leftArrow.visible = true;
            this.btn_rightArrow.visible = true;
            this._timelineMask.visible = true;
            this.charFrames.mask = this._timelineMask;
         }
         else
         {
            this.btn_leftArrow.visible = false;
            this.btn_rightArrow.visible = false;
            this._timelineMask.visible = false;
            this.charFrames.mask = null;
         }
         this.uiApi.me().render();
         this.updateTurnOfArrow();
      }
      
      private function isTimelineExtended() : Boolean
      {
         var _loc5_:Fighter = null;
         var _loc6_:* = false;
         var _loc1_:int = 0;
         var _loc2_:int = this.uiApi.me().getConstant("frame_offset_horizontal");
         var _loc3_:int = this.uiApi.me().getConstant("bg_margin_right");
         var _loc4_:int = this.uiApi.me().getConstant("bg_margin_left");
         for each(_loc5_ in this._fighters)
         {
            _loc1_ = _loc1_ + (_loc5_.frame.width + _loc2_);
         }
         _loc6_ = _loc1_ > this._screenWidth - _loc3_ - this.btn_minimArrow.width - _loc4_;
         return _loc6_;
      }
      
      private function updateBuff(param1:*, param2:Number) : void
      {
         var _loc3_:Fighter = this.getFighterById(param2);
         if(_loc3_)
         {
            _loc3_.refreshPdv();
            _loc3_.refreshShield();
         }
      }
      
      private function updateFightersSprite(param1:Number) : void
      {
         var _loc2_:Fighter = null;
         for each(_loc2_ in this._fighters)
         {
            if(_loc2_.id == param1)
            {
               _loc2_.updateSprite();
               _loc2_.refreshPdv();
            }
         }
      }
      
      private function replaceTimeline() : void
      {
         this.refreshTimeline();
         this.fightApi.updateSwapPositionRequestsIcons();
      }
      
      private function onGameFightTurnListUpdated() : void
      {
         this.refreshTimeline();
      }
      
      private function onUpdatePreFightersList(param1:Number = 0) : void
      {
         this.refreshTimeline();
         this.updateFightersSprite(param1);
      }
      
      private function onGameFightTurnStart(param1:Number, param2:int, param3:uint, param4:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc5_:Fighter = this.getFighterById(param1);
         if(_loc5_)
         {
            if(_loc5_.alive)
            {
               this.setTurnOf(_loc5_,param2,param3);
            }
         }
         else
         {
            _loc6_ = this._fightersId.indexOf(param1) - 1;
            while(_loc6_ > 0)
            {
               _loc5_ = this.getFighterById(this._fightersId[_loc6_]);
               if(_loc5_)
               {
                  this.setTurnOf(_loc5_,param2,param3);
                  break;
               }
               _loc6_--;
            }
         }
      }
      
      private function onGameFightTurnEnd(param1:Number) : void
      {
         var _loc2_:Fighter = this.getFighterById(param1);
         if(_loc2_ && _loc2_.alive)
         {
            this.unsetTurnOf(_loc2_);
         }
      }
      
      private function onFightEvent(param1:String, param2:Object, param3:Object = null) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Fighter = null;
         var _loc8_:int = 0;
         var _loc9_:* = null;
         if(param3 == null)
         {
            param3 = new Array();
            if(param2.length)
            {
               param3[0] = param2[0];
            }
         }
         var _loc4_:int = param3.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = param3[_loc5_];
            _loc7_ = this.getFighterById(_loc6_);
            switch(param1)
            {
               case "fighterLifeGain":
               case "fighterLifeLoss":
                  if(_loc7_)
                  {
                     _loc7_.refreshPdv();
                  }
                  break;
               case "fighterShieldLoss":
                  if(_loc7_)
                  {
                     _loc7_.refreshShield();
                  }
                  break;
               case "fighterGotDispelled":
               case "fighterTemporaryBoosted":
                  if(_loc7_)
                  {
                     _loc7_.refreshShield();
                     _loc7_.refreshPdv();
                  }
                  break;
               case "fighterDeath":
               case "fighterLeave":
                  if(_loc7_)
                  {
                     if(this._hideDeadGuys)
                     {
                        for(_loc9_ in this._fighters)
                        {
                           if(this._fighters[_loc9_].id == _loc7_.id)
                           {
                              _loc8_ = int(_loc9_);
                              break;
                           }
                        }
                        this._fighters.splice(_loc8_,1);
                        this._hiddenFighters[_loc7_.id] = {
                           "id":_loc7_.id,
                           "alive":false,
                           "summoned":_loc7_.summoned
                        };
                        _loc7_.destroy(true);
                        this.charCtr.removeChild(_loc7_.frame);
                        this.resizeTimeline();
                        this.onOrderFightersSwitched(true);
                     }
                     else
                     {
                        _loc7_.alive = false;
                        this.onOrderFightersSwitched(true);
                        this.unsetTurnOf(_loc7_);
                     }
                  }
                  break;
               case "fighterChangeLook":
                  if(_loc7_)
                  {
                     _loc7_.look = param2[1];
                  }
                  break;
               case "fighterSummoned":
            }
            _loc5_++;
         }
      }
      
      private function onFoldAll(param1:Boolean) : void
      {
         if(param1)
         {
            this._foldAllStatus = this.folded;
            this.folded = true;
         }
         else
         {
            this.folded = this._foldAllStatus;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Fighter = null;
         switch(param1)
         {
            case this.btn_minimArrow:
               this.folded = !this.folded;
               break;
            case this.btn_leftArrow:
               this.moveLeft();
               break;
            case this.btn_rightArrow:
               this.moveRight();
               break;
            case this.btn_down:
               this._topDisplayMode = false;
               this.sysApi.setData("topDisplayTimeline",this._topDisplayMode);
               this.replaceTimeline();
               break;
            case this.btn_up:
               this._topDisplayMode = true;
               this.sysApi.setData("topDisplayTimeline",this._topDisplayMode);
               this.replaceTimeline();
               break;
            default:
               _loc2_ = this.getFighterByFrame(param1);
               if(!_loc2_)
               {
                  break;
               }
               if(this.fightApi.isCastingSpell())
               {
                  if(_loc2_.alive)
                  {
                     Api.sysApi.sendAction(new TimelineEntityClick(_loc2_.id));
                  }
               }
               else
               {
                  this.sysApi.dispatchHook(FighterSelected,_loc2_.id);
               }
               break;
         }
      }
      
      public function onFighterSelected(param1:Number) : void
      {
         var _loc2_:Fighter = this.getFighterById(param1);
         this.selectFighter(_loc2_);
      }
      
      public function onBuffAdd(param1:uint, param2:Number) : void
      {
         this.updateBuff(param1,param2);
      }
      
      public function onBuffRemove(param1:*, param2:Number, param3:String) : void
      {
         this.updateBuff(param1,param2);
      }
      
      public function onBuffUpdate(param1:uint, param2:Number) : void
      {
         this.updateBuff(param1,param2);
      }
      
      public function onBuffDispell(param1:Number) : void
      {
         var _loc2_:Fighter = this.getFighterById(param1);
         if(_loc2_)
         {
            _loc2_.refreshPdv();
            _loc2_.refreshShield();
         }
      }
      
      public function onOrderFightersSwitched(param1:Boolean) : void
      {
         var _loc2_:Fighter = null;
         var _loc7_:Number = NaN;
         var _loc8_:Object = null;
         var _loc3_:Object = this.fightApi.getFighters();
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc7_ = _loc3_[_loc6_];
            _loc4_ = _loc4_ + 1;
            _loc5_ = false;
            for each(_loc2_ in this._fighters)
            {
               if(_loc7_ == _loc2_.id)
               {
                  if(!_loc2_.alive)
                  {
                     _loc4_--;
                  }
                  _loc2_.updateNumber(_loc4_);
                  _loc5_ = true;
               }
            }
            if(!_loc5_)
            {
               _loc8_ = this._hiddenFighters[_loc7_];
               if(_loc8_ && !_loc8_.alive && !_loc8_.summoned)
               {
                  _loc4_--;
               }
            }
            _loc6_++;
         }
      }
      
      public function onHideDeadFighters(param1:Boolean) : void
      {
         if(this._hideDeadGuys != param1)
         {
            this._hideDeadGuys = param1;
            this.refreshTimeline();
         }
      }
      
      public function onHideSummonedFighters(param1:Boolean) : void
      {
         if(this._hideSummonedStuff != param1)
         {
            this._hideSummonedStuff = param1;
            this.refreshTimeline();
            this.onOrderFightersSwitched(true);
         }
      }
      
      public function onTurnCountUpdated(param1:uint) : void
      {
         this._turnCount = param1;
         this.lbl_turnCount.text = this._turnCount.toString();
         if(this._turnCountBeforeNextWaveAttackers > -1)
         {
            this._turnCountBeforeNextWaveAttackers--;
         }
         if(this._turnCountBeforeNextWaveDefenders > -1)
         {
            this._turnCountBeforeNextWaveDefenders--;
         }
      }
      
      public function onWaveUpdated(param1:int, param2:int, param3:int) : void
      {
         if(param2 == 1)
         {
            param3--;
         }
         if(param1 == TeamEnum.TEAM_CHALLENGER)
         {
            this._waveCountAttackers = param2;
            this._turnCountBeforeNextWaveAttackers = param3;
         }
         else if(param1 == TeamEnum.TEAM_DEFENDER)
         {
            this._waveCountDefenders = param2;
            this._turnCountBeforeNextWaveDefenders = param3;
         }
         this.tx_wave.visible = true;
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Fighter = null;
         this._rollOverMe = true;
         if(param1 == this.lbl_turnCount)
         {
            _loc2_ = this.uiApi.getText("ui.fight.turnNumber",this._turnCount);
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,0,null,null,null,"TextInfo");
         }
         else if(param1 == this.tx_wave && (this._waveCountAttackers > 0 || this._waveCountDefenders > 0))
         {
            _loc3_ = "";
            if(this._waveCountAttackers > 0)
            {
               _loc3_ = _loc3_ + (this.uiApi.getText("ui.common.attackers") + "\n   " + this.uiApi.getText("ui.common.wave") + " " + this._waveCountAttackers);
               if(this._turnCountBeforeNextWaveAttackers == 0)
               {
                  _loc3_ = _loc3_ + ("\n   " + this.uiApi.getText("ui.fight.newWaveIncoming"));
               }
               else if(this._turnCountBeforeNextWaveAttackers > 0)
               {
                  _loc3_ = _loc3_ + ("\n   " + this.uiApi.processText(this.uiApi.getText("ui.fight.turnsBeforeNextWave",this._turnCountBeforeNextWaveAttackers),"",this._turnCountBeforeNextWaveAttackers == 1));
               }
            }
            if(this._waveCountDefenders > 0)
            {
               _loc3_ = _loc3_ + (this.uiApi.getText("ui.common.defenders") + "\n   " + this.uiApi.getText("ui.common.wave") + " " + this._waveCountDefenders);
               if(this._turnCountBeforeNextWaveDefenders == 0)
               {
                  _loc3_ = _loc3_ + ("\n   " + this.uiApi.getText("ui.fight.newWaveIncoming"));
               }
               else if(this._turnCountBeforeNextWaveDefenders > 0)
               {
                  _loc3_ = _loc3_ + ("\n   " + this.uiApi.processText(this.uiApi.getText("ui.fight.turnsBeforeNextWave",this._turnCountBeforeNextWaveDefenders),"",this._turnCountBeforeNextWaveDefenders == 1));
               }
            }
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param1,false,"standard",7,1,0,null,null,null,"TextInfo");
         }
         else
         {
            _loc4_ = this.getFighterByFrame(param1);
            if(_loc4_)
            {
               this.sysApi.sendAction(new TimelineEntityOver(_loc4_.id,true));
            }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         var _loc2_:Fighter = null;
         this._rollOverMe = false;
         if(param1 == this.lbl_turnCount || param1 == this.tx_wave)
         {
            this.uiApi.hideTooltip();
         }
         else
         {
            _loc2_ = this.getFighterByFrame(param1);
            if(_loc2_)
            {
               this.sysApi.sendAction(new TimelineEntityOut(_loc2_.id));
            }
         }
      }
      
      private function onFighterMouseAction(param1:Object = null) : void
      {
         var _loc2_:Fighter = null;
         if(param1)
         {
            _loc2_ = this.getFighterById(param1.contextualId);
            if(_loc2_ != null && _loc2_.alive)
            {
               _loc2_.highlight = true;
               if(!this._rollOverMe)
               {
                  _loc2_.risen = true;
               }
            }
         }
         else
         {
            for each(_loc2_ in this._fighters)
            {
               if(!_loc2_.isCurrentPlayer)
               {
                  _loc2_.risen = false;
               }
               _loc2_.highlight = false;
            }
         }
         this.fightApi.updateSwapPositionRequestsIcons();
      }
   }
}
