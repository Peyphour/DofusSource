package ui.timeline
{
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import d2enums.StatesEnum;
   import flash.display.Sprite;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.utils.getTimer;
   
   public class Fighter
   {
      
      private static const SUMMONED_SCALE:Number = 0.8;
      
      private static var _framePool:Object = new Array();
      
      private static var _freeFrameId:uint = 0;
       
      
      private var _id:Number;
      
      private var _alive:Boolean = true;
      
      private var _isCurrentPlayer:Boolean = false;
      
      private var _summoned:Boolean;
      
      private var _lifePoints:int;
      
      private var _shieldPoints:int;
      
      private var _risen:Boolean = false;
      
      private var _highlighted:Boolean = false;
      
      private var _clockStart:int;
      
      private var _turnDuration:int;
      
      private var _turnElapsedTime:uint;
      
      private var _timelineUi:Object;
      
      private var _selected:Boolean = false;
      
      private var _frame:ButtonContainer;
      
      private var _txSelected:Texture;
      
      private var _teamBackground:Texture;
      
      private var _teamDarkBackground:Texture;
      
      private var _teamTimeBackground:Texture;
      
      private var _timeMask:Sprite;
      
      private var _gfx:EntityDisplayer;
      
      private var _gfxMask:Sprite;
      
      private var _pdvGauge:ProgressBar;
      
      private var _shieldGauge:ProgressBar;
      
      private var _lbl_number:Label;
      
      private var _lbl_waveNumber:Label;
      
      private var _timeGauge:Texture;
      
      private var _frameTexture:Texture;
      
      public function Fighter(param1:Number, param2:Object, param3:uint)
      {
         super();
         this._id = param1;
         var _loc4_:Object = Api.fightApi.getFighterInformations(param1);
         this._summoned = _loc4_.summoner != 0 && _loc4_.summoned;
         this._timelineUi = param2;
         this._frame = this.createFrame(this._summoned);
         this.displayFighter(param1,param3);
      }
      
      private static function nextFrameName() : String
      {
         return "frame" + _freeFrameId++;
      }
      
      public static function cleanFramesPool() : void
      {
         _framePool = new Array();
      }
      
      public function get id() : Number
      {
         return this._id;
      }
      
      public function get alive() : Boolean
      {
         return this._alive;
      }
      
      public function set alive(param1:Boolean) : void
      {
         if(param1 != this._alive)
         {
            this.setAlive(param1);
         }
      }
      
      public function get summoned() : Boolean
      {
         return this._summoned;
      }
      
      public function get frame() : ButtonContainer
      {
         return this._frame;
      }
      
      public function get timeGauge() : Texture
      {
         return this.frame.getChildByName("tx_timeGauge") as Texture;
      }
      
      public function get look() : Object
      {
         return this._gfx.look;
      }
      
      public function set look(param1:Object) : void
      {
         this._gfx.look = param1;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected != param1)
         {
            if(param1)
            {
               this._txSelected.visible = true;
            }
            else
            {
               this._txSelected.visible = false;
            }
         }
         this._selected = param1;
      }
      
      public function destroy(param1:Boolean = false) : void
      {
         if(this._summoned || param1)
         {
            this._frame.visible = false;
            this._timeGauge.dispatchMessages = false;
            this._lifePoints = 0;
         }
         Api.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      public function refreshPdv() : void
      {
         var _loc1_:Object = Api.fightApi.getFighterInformations(this._id);
         if(_loc1_ && this._alive)
         {
            this.setPdv(_loc1_.lifePoints);
         }
      }
      
      public function setPdv(param1:int) : void
      {
         var _loc2_:Object = Api.fightApi.getFighterInformations(this._id);
         if(param1 < 0)
         {
            param1 = 0;
         }
         this._lifePoints = param1;
         var _loc3_:Number = param1 / _loc2_.maxLifePoints;
         this._pdvGauge.value = _loc3_;
      }
      
      public function addPdv(param1:int) : void
      {
         this.setPdv(this._lifePoints + param1);
      }
      
      public function removePdv(param1:int) : void
      {
         this.setPdv(this._lifePoints - param1);
      }
      
      public function refreshShield() : void
      {
         var _loc1_:Object = Api.fightApi.getFighterInformations(this._id);
         if(_loc1_)
         {
            this.setShield(_loc1_.shieldPoints);
         }
      }
      
      public function setShield(param1:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc2_:int = this._timelineUi.getConstant("mask_height");
         var _loc3_:Object = Api.fightApi.getFighterInformations(this._id);
         this._shieldPoints = param1;
         if(this._shieldPoints < 0)
         {
            this._shieldPoints = 0;
         }
         if(this._shieldPoints == 0)
         {
            this._shieldGauge.visible = false;
            this._gfxMask.height = _loc2_;
         }
         else
         {
            this._shieldGauge.visible = true;
            _loc4_ = this._shieldPoints / _loc3_.maxLifePoints;
            this._shieldGauge.value = _loc4_;
            _loc5_ = _loc2_ - this._shieldGauge.height;
            this._gfxMask.height = _loc5_;
         }
      }
      
      public function startCountDown(param1:int, param2:uint) : void
      {
         this._turnDuration = param1;
         this._clockStart = getTimer();
         this._turnElapsedTime = param1 - param2;
         Api.sysApi.addEventListener(this.onEnterFrame,"Timeline");
         this._isCurrentPlayer = true;
         var _loc3_:GlowFilter = new GlowFilter(uint(Api.sysApi.getConfigEntry("colors.timeline.border_current_fighter")),1,this._timelineUi.getConstant("frame_glow_width"),this._timelineUi.getConstant("frame_glow_width"),2,BitmapFilterQuality.HIGH);
         this._timeGauge.filters = [_loc3_];
         this._teamBackground.visible = false;
         this._timeMask.y = 0;
         var _loc4_:GlowFilter = new GlowFilter(16777215,0,1,1,2,BitmapFilterQuality.HIGH);
         this._gfx.filters = [_loc4_];
      }
      
      public function stopCountDown() : void
      {
         Api.sysApi.removeEventListener(this.onEnterFrame);
         this._isCurrentPlayer = false;
         this._timeGauge.filters = [];
         this.updateTime(0);
         this._teamBackground.visible = true;
         this._timeMask.y = -this._teamTimeBackground.height;
         var _loc1_:GlowFilter = new GlowFilter(16777215,0.2,20,20,2,BitmapFilterQuality.HIGH);
         this._gfx.filters = [_loc1_];
      }
      
      public function updateTime(param1:Number = 0) : void
      {
         var _loc2_:Number = NaN;
         if(this.alive)
         {
            _loc2_ = param1 * this._teamTimeBackground.height;
         }
         else
         {
            _loc2_ = this._teamTimeBackground.height;
         }
         this._timeMask.y = -_loc2_;
      }
      
      public function updateSprite() : void
      {
         var _loc1_:Object = Api.fightApi.getFighterInformations(this.id);
         this._gfx.look = _loc1_.look;
      }
      
      public function set risen(param1:Boolean) : void
      {
         this._risen = param1;
         if(param1)
         {
            this._frame.y = 0;
         }
         else
         {
            this._frame.y = this._timelineUi.getConstant("frame_offset_vertical");
         }
         this._gfx.finalize();
      }
      
      public function get risen() : Boolean
      {
         return this._risen;
      }
      
      public function set highlight(param1:Boolean) : void
      {
         this._highlighted = param1;
         if(param1)
         {
            this._teamBackground.luminosity = 1.5;
            this._teamDarkBackground.luminosity = 1.5;
            this._teamTimeBackground.luminosity = 1.5;
         }
         else
         {
            this._teamBackground.luminosity = 1;
            this._teamDarkBackground.luminosity = 1;
            this._teamTimeBackground.luminosity = 1;
         }
      }
      
      public function get highlight() : Boolean
      {
         return this._highlighted;
      }
      
      public function updateNumber(param1:uint) : void
      {
         if(Api.configApi.getConfigProperty("dofus","orderFighters") && this._alive)
         {
            this._lbl_number.text = param1.toString();
         }
         else
         {
            this._lbl_number.text = "";
         }
      }
      
      public function get isCurrentPlayer() : Boolean
      {
         return this._isCurrentPlayer;
      }
      
      private function displayFighter(param1:Number, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = 1;
         _loc3_ = this._timelineUi.getConstant("mask_height");
         _loc4_ = this._timelineUi.getConstant("mask_x");
         _loc5_ = this._timelineUi.getConstant("mask_y");
         _loc6_ = this._timelineUi.getConstant("mask_width");
         _loc7_ = this._timelineUi.getConstant("mask_corner");
         if(this._summoned)
         {
            _loc3_ = _loc3_ * SUMMONED_SCALE;
            _loc4_ = _loc4_ * SUMMONED_SCALE;
            _loc5_ = _loc5_ * SUMMONED_SCALE;
            _loc6_ = _loc6_ * SUMMONED_SCALE;
            _loc7_ = _loc7_ * SUMMONED_SCALE;
            _loc8_ = _loc8_ * SUMMONED_SCALE;
         }
         var _loc9_:Object = Api.fightApi.getFighterInformations(param1);
         this._gfx = Api.uiApi.createComponent("EntityDisplayer") as EntityDisplayer;
         this._gfx.width = _loc6_;
         this._gfx.height = _loc3_;
         this._gfx.view = "timeline";
         this._gfx.setAnimationAndDirection("AnimArtwork",1);
         this._gfx.look = _loc9_.look;
         this._frame.addChild(this._gfx);
         var _loc10_:GlowFilter = new GlowFilter(16777215,0.2,20,20,2,BitmapFilterQuality.HIGH);
         this._gfx.filters = [_loc10_];
         this._gfxMask = new Sprite();
         this._gfxMask.graphics.beginFill(16733440);
         this._gfxMask.graphics.drawRect(_loc4_,_loc5_,_loc6_,_loc3_);
         this._gfxMask.graphics.endFill();
         this._frame.addChild(this._gfxMask);
         this._gfx.mask = this._gfxMask;
         if(!this._pdvGauge.finalized)
         {
            this._pdvGauge.finalize();
         }
         if(!this._shieldGauge.finalized)
         {
            this._shieldGauge.finalize();
         }
         if(_loc9_.team == "challenger")
         {
            this._teamBackground.uri = Api.uiApi.createUri(this._timelineUi.getConstant("texture_bg_challenger"));
            this._teamDarkBackground.uri = Api.uiApi.createUri(this._timelineUi.getConstant("texture_bg_dark_challenger"));
            this._teamTimeBackground.uri = Api.uiApi.createUri(this._timelineUi.getConstant("texture_bg_highlight_challenger"));
            this._teamBackground.finalize();
            this._teamDarkBackground.finalize();
            this._teamTimeBackground.finalize();
         }
         else
         {
            this._teamBackground.uri = Api.uiApi.createUri(this._timelineUi.getConstant("texture_bg_defender"));
            this._teamDarkBackground.uri = Api.uiApi.createUri(this._timelineUi.getConstant("texture_bg_dark_defender"));
            this._teamTimeBackground.uri = Api.uiApi.createUri(this._timelineUi.getConstant("texture_bg_highlight_defender"));
            this._teamBackground.finalize();
            this._teamDarkBackground.finalize();
            this._teamTimeBackground.finalize();
         }
         this._txSelected.finalize();
         this._lbl_number = Api.uiApi.createComponent("Label") as Label;
         this._lbl_number.width = 20;
         this._lbl_number.height = 16;
         this._lbl_number.x = _loc6_ - 19;
         this._lbl_number.y = -2;
         this._lbl_number.cssClass = "right";
         this._lbl_number.css = Api.uiApi.createUri(this._timelineUi.getConstant("css") + "small2.css");
         if(Api.configApi.getConfigProperty("dofus","orderFighters") && _loc9_.isAlive)
         {
            this._lbl_number.text = param2.toString();
         }
         else
         {
            this._lbl_number.text = "";
         }
         var _loc11_:GlowFilter = new GlowFilter(Api.sysApi.getConfigEntry("colors.text.glow.dark"),0.8,2,2,6,3);
         this._lbl_number.filters = [_loc11_];
         this._frame.addChild(this._lbl_number);
         this._lbl_waveNumber = Api.uiApi.createComponent("Label") as Label;
         this._lbl_waveNumber.width = 20;
         this._lbl_waveNumber.height = 16;
         this._lbl_waveNumber.x = -2;
         this._lbl_waveNumber.y = -2;
         this._lbl_waveNumber.css = Api.uiApi.createUri(this._timelineUi.getConstant("css") + "small2.css");
         if(_loc9_.wave > 0)
         {
            this._lbl_waveNumber.text = _loc9_.wave;
         }
         else
         {
            this._lbl_waveNumber.text = "";
         }
         this._lbl_waveNumber.filters = [_loc11_];
         this._frame.addChild(this._lbl_waveNumber);
         this.setPdv(_loc9_.lifePoints);
         this.updateTime(0);
      }
      
      private function createFrame(param1:Boolean) : ButtonContainer
      {
         var _loc2_:ButtonContainer = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         if(param1 && _framePool.length > 0)
         {
            this._pdvGauge = _loc2_.getChildByName("pb_pdvGauge") as ProgressBar;
            this._shieldGauge = _loc2_.getChildByName("pb_shieldGauge") as ProgressBar;
            this._timeGauge = _loc2_.getChildByName("tx_timeGauge") as Texture;
            this._teamBackground = _loc2_.getChildByName("tx_background") as Texture;
            this._teamDarkBackground = _loc2_.getChildByName("tx_darkBackground") as Texture;
            this._teamTimeBackground = _loc2_.getChildByName("tx_timeBackground") as Texture;
            this._timeMask = _loc2_.getChildByName("time_mask") as Sprite;
            this._txSelected = _loc2_.getChildByName("tx_selected") as Texture;
            _loc2_ = _framePool.pop();
            _loc2_.visible = true;
            this._timeGauge.dispatchMessages = true;
         }
         else
         {
            _loc2_ = Api.uiApi.createContainer("ButtonContainer") as ButtonContainer;
            if(param1)
            {
               _loc2_.width = this._timelineUi.getConstant("frame_summon_width");
               _loc2_.height = this._timelineUi.getConstant("frame_summon_height");
            }
            else
            {
               _loc2_.width = this._timelineUi.getConstant("frame_char_width");
               _loc2_.height = this._timelineUi.getConstant("frame_char_height");
            }
            _loc2_.name = nextFrameName();
            _loc2_.y = this._timelineUi.getConstant("frame_offset_vertical");
            this._teamBackground = Api.uiApi.createComponent("Texture") as Texture;
            this._teamBackground.width = _loc2_.width;
            this._teamBackground.height = _loc2_.height;
            this._teamBackground.name = "tx_background";
            this._teamBackground.dispatchMessages = true;
            this._teamDarkBackground = Api.uiApi.createComponent("Texture") as Texture;
            this._teamDarkBackground.width = _loc2_.width;
            this._teamDarkBackground.height = _loc2_.height;
            this._teamDarkBackground.name = "tx_darkBackground";
            this._teamDarkBackground.dispatchMessages = true;
            this._teamTimeBackground = Api.uiApi.createComponent("Texture") as Texture;
            this._teamTimeBackground.width = _loc2_.width;
            this._teamTimeBackground.height = _loc2_.height;
            this._teamTimeBackground.name = "tx_timeBackground";
            this._teamTimeBackground.dispatchMessages = true;
            this._timeMask = new Sprite();
            this._timeMask.name = "time_mask";
            this._timeMask.graphics.beginFill(16733440);
            this._timeMask.graphics.drawRect(0,_loc2_.height,_loc2_.width,_loc2_.height);
            this._timeMask.graphics.endFill();
            this._txSelected = Api.uiApi.createComponent("Texture") as Texture;
            this._txSelected.x = 0;
            this._txSelected.y = 0;
            this._txSelected.width = _loc2_.width;
            this._txSelected.height = _loc2_.height + 2;
            this._txSelected.uri = Api.uiApi.createUri(this._timelineUi.getConstant("texture_selection"));
            this._txSelected.name = "tx_selected";
            this._txSelected.visible = false;
            this._timeGauge = Api.uiApi.createComponent("Texture") as Texture;
            this._timeGauge.uri = Api.uiApi.createUri(this._timelineUi.getConstant("texture_time"));
            this._timeGauge.width = _loc2_.width;
            this._timeGauge.height = _loc2_.height;
            this._timeGauge.name = "tx_timeGauge";
            this._timeGauge.dispatchMessages = true;
            this._timeGauge.visible = false;
            this._timeGauge.finalize();
            this._frameTexture = Api.uiApi.createComponent("Texture") as Texture;
            this._frameTexture.uri = Api.uiApi.createUri(this._timelineUi.getConstant("texture_frame"));
            this._frameTexture.name = "tx_frame";
            this._frameTexture.width = _loc2_.width;
            this._frameTexture.height = _loc2_.height;
            this._frameTexture.visible = false;
            this._frameTexture.finalize();
            this._pdvGauge = Api.uiApi.createComponent("ProgressBar") as ProgressBar;
            this._pdvGauge.name = "pb_pdvGauge";
            this._pdvGauge.barColor = Api.sysApi.getConfigEntry("colors.progressbar.lifePoints");
            if(param1)
            {
               this._pdvGauge.width = this._timelineUi.getConstant("pdv_summon_width");
               this._pdvGauge.height = this._timelineUi.getConstant("pdv_summon_height");
               this._pdvGauge.x = this._timelineUi.getConstant("pdv_summon_x");
               this._pdvGauge.y = this._timelineUi.getConstant("pdv_summon_y");
            }
            else
            {
               this._pdvGauge.width = this._timelineUi.getConstant("pdv_width");
               this._pdvGauge.height = this._timelineUi.getConstant("pdv_height");
               this._pdvGauge.x = this._timelineUi.getConstant("pdv_x");
               this._pdvGauge.y = this._timelineUi.getConstant("pdv_y");
            }
            this._pdvGauge.finalize();
            this._shieldGauge = Api.uiApi.createComponent("ProgressBar") as ProgressBar;
            this._shieldGauge.name = "pb_shieldGauge";
            this._shieldGauge.barColor = Api.sysApi.getConfigEntry("colors.progressbar.shieldPoints");
            if(param1)
            {
               this._shieldGauge.width = this._timelineUi.getConstant("pdv_summon_width");
               this._shieldGauge.height = this._timelineUi.getConstant("pdv_summon_height");
               this._shieldGauge.x = this._timelineUi.getConstant("shield_summon_x");
               this._shieldGauge.y = this._timelineUi.getConstant("shield_summon_y");
            }
            else
            {
               this._shieldGauge.width = this._timelineUi.getConstant("pdv_width");
               this._shieldGauge.height = this._timelineUi.getConstant("pdv_height");
               this._shieldGauge.x = this._timelineUi.getConstant("shield_x");
               this._shieldGauge.y = this._timelineUi.getConstant("shield_y");
            }
            this._shieldGauge.visible = false;
            this._shieldGauge.finalize();
            _loc2_.addChild(this._teamDarkBackground);
            _loc2_.addChild(this._teamTimeBackground);
            _loc2_.addChild(this._timeMask);
            this._teamTimeBackground.mask = this._timeMask;
            _loc2_.addChild(this._teamBackground);
            _loc2_.addChild(this._timeGauge);
            _loc2_.addChild(this._frameTexture);
            _loc2_.addChild(this._txSelected);
            _loc2_.addChild(this._shieldGauge);
            _loc2_.addChild(this._pdvGauge);
            _loc3_ = new Array();
            _loc4_ = StatesEnum.STATE_OVER;
            _loc3_[_loc4_] = new Array();
            _loc3_[_loc4_][this._timeGauge.name] = new Array();
            _loc3_[_loc4_][this._timeGauge.name]["luminosity"] = 1.5;
            _loc3_[_loc4_][this._pdvGauge.name] = new Array();
            _loc3_[_loc4_][this._pdvGauge.name]["luminosity"] = 1.5;
            _loc3_[_loc4_][this._shieldGauge.name] = new Array();
            _loc3_[_loc4_][this._shieldGauge.name]["luminosity"] = 1.5;
            _loc2_.changingStateData = _loc3_;
         }
         return _loc2_;
      }
      
      private function setAlive(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         var _loc3_:GlowFilter = null;
         this._alive = param1;
         if(this._alive)
         {
            _loc2_ = Api.fightApi.getFighterInformations(this._id);
            this.setPdv(_loc2_.lifePoints);
            this._gfx.transform.colorTransform = new ColorTransform();
            _loc3_ = new GlowFilter(16777215,0.2,20,20,2,BitmapFilterQuality.HIGH);
            this._gfx.filters = [_loc3_];
         }
         else
         {
            this.setPdv(0);
            this.setShield(0);
            this._gfx.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,0.7);
            this._gfx.filters = new Array();
         }
         this.updateTime(0);
      }
      
      private function onEnterFrame() : void
      {
         var _loc1_:uint = getTimer();
         var _loc2_:Number = (_loc1_ - this._clockStart + this._turnElapsedTime) / this._turnDuration;
         if(this._isCurrentPlayer)
         {
            this.updateTime(_loc2_);
         }
      }
   }
}
