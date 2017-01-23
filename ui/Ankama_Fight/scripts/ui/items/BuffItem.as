package ui.items
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import d2enums.StatesEnum;
   import flash.geom.ColorTransform;
   
   public class BuffItem
   {
       
      
      private var _key:String;
      
      private var _buffs:Array;
      
      private var _spell:Spell;
      
      private var _parentBoostUid:int = 0;
      
      private var _cooldown:int = 0;
      
      private var _textureUri:Object;
      
      private var _ctr:Object;
      
      private var _size:int;
      
      private var tx_buff:Texture;
      
      private var lbl_cooldown_buff:Label;
      
      public var btn_buff:ButtonContainer;
      
      public function BuffItem(param1:int, param2:Number, param3:uint, param4:int, param5:uint, param6:String, param7:Object)
      {
         super();
         if(param4 > 0)
         {
            this._key = param1 + "#" + param2 + "#" + param3 + "#" + param4;
         }
         else
         {
            this._key = param1 + "#" + param2 + "#" + param3;
         }
         this._buffs = new Array();
         this._spell = Api.dataApi.getSpell(param1);
         this._ctr = param7;
         this._size = param5;
         var _loc8_:SpellWrapper = Api.dataApi.getSpellWrapper(param1);
         var _loc9_:String = _loc8_.iconUri.toString();
         this.btn_buff = Api.uiApi.createContainer("ButtonContainer") as ButtonContainer;
         this.btn_buff.width = param5;
         this.btn_buff.height = param5;
         this.btn_buff.name = "buff_" + this.key;
         this.tx_buff = Api.uiApi.createComponent("Texture") as Texture;
         this.tx_buff.width = param5;
         this.tx_buff.height = param5;
         this.tx_buff.x = 0;
         this.tx_buff.y = 0;
         this.tx_buff.name = "tx_buff";
         this.tx_buff.uri = Api.uiApi.createUri(_loc9_);
         if(_loc8_.spell.typeId == 40)
         {
            this.tx_buff.transform.colorTransform = new ColorTransform(100,1,1,1,-76,-10,33,0);
         }
         this.tx_buff.finalize();
         this.lbl_cooldown_buff = Api.uiApi.createComponent("Label") as Label;
         this.lbl_cooldown_buff.height = 19;
         this.lbl_cooldown_buff.width = 19;
         this.lbl_cooldown_buff.fixedWidth = false;
         this.lbl_cooldown_buff.bgColor = Api.sysApi.getConfigEntry("colors.ui.shadow");
         this.lbl_cooldown_buff.bgAlpha = 0.6;
         this.lbl_cooldown_buff.x = 0;
         this.lbl_cooldown_buff.y = 0;
         this.lbl_cooldown_buff.css = Api.uiApi.createUri(param6);
         this.lbl_cooldown_buff.cssClass = "quantity";
         this.lbl_cooldown_buff.text = "+";
         this.lbl_cooldown_buff.fullWidth();
         this.cooldown = this._cooldown;
         this.btn_buff.addChild(this.tx_buff);
         this.btn_buff.addChild(this.lbl_cooldown_buff);
         var _loc10_:Array = new Array();
         _loc10_[StatesEnum.STATE_OVER] = new Array();
         _loc10_[StatesEnum.STATE_OVER][this.tx_buff.name] = new Array();
         _loc10_[StatesEnum.STATE_OVER][this.tx_buff.name]["luminosity"] = 1.5;
         this.btn_buff.changingStateData = _loc10_;
         param7.addChild(this.btn_buff);
      }
      
      public static function getKey(param1:Object, param2:Boolean = false, param3:int = 0) : String
      {
         var _loc4_:String = param1.castingSpell.spell.id + "#" + param1.castingSpell.casterId + "#" + param1.parentBoostUid;
         if(param2 || param1.effect && param1.effect.delay > 0)
         {
            _loc4_ = _loc4_ + ("#" + (getEndDelayTurn(param1) + param3));
         }
         return _loc4_;
      }
      
      public static function getEndDelayTurn(param1:Object) : int
      {
         if(param1.effect && param1.effect.hasOwnProperty("delay"))
         {
            return Api.fightApi.getTurnsCount() + param1.effect.delay;
         }
         return Api.fightApi.getTurnsCount();
      }
      
      public function hasUid(param1:String) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._buffs)
         {
            if(_loc2_.uid == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function set cooldown(param1:int) : void
      {
         this._cooldown = param1;
         if(this.lbl_cooldown_buff)
         {
            if(this._cooldown == -1)
            {
               this.lbl_cooldown_buff.text = "+";
               this.lbl_cooldown_buff.visible = true;
            }
            else if(this._cooldown == 0 || this._cooldown == uint.MAX_VALUE)
            {
               this.lbl_cooldown_buff.text = "";
               this.lbl_cooldown_buff.visible = false;
            }
            else if(this._cooldown < -1)
            {
               this.lbl_cooldown_buff.text = "∞";
               this.lbl_cooldown_buff.visible = true;
            }
            else
            {
               this.lbl_cooldown_buff.text = this._cooldown.toString();
               this.lbl_cooldown_buff.visible = true;
            }
         }
      }
      
      public function get cooldown() : int
      {
         return this._cooldown;
      }
      
      public function get maxCooldown() : int
      {
         var _loc2_:Object = null;
         if(this._cooldown != -1)
         {
            return this._cooldown;
         }
         var _loc1_:int = 0;
         for each(_loc2_ in this._buffs)
         {
            if(_loc2_.duration > _loc1_ || _loc2_.duration < -1)
            {
               _loc1_ = _loc2_.duration;
            }
         }
         return _loc1_;
      }
      
      public function get delay() : int
      {
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._buffs)
         {
            if(_loc1_ == 0 || _loc2_.effect.delay < _loc1_)
            {
               _loc1_ = _loc2_.effect.delay;
            }
         }
         return _loc1_;
      }
      
      public function get trigger() : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._buffs)
         {
            if(_loc1_.trigger)
            {
               return true;
            }
         }
         return false;
      }
      
      public function set textureUri(param1:Object) : void
      {
         this._textureUri = param1;
         if(this.tx_buff)
         {
            this.tx_buff.uri = this._textureUri;
         }
      }
      
      public function set x(param1:int) : void
      {
         this.btn_buff.x = param1;
      }
      
      public function get x() : int
      {
         return this.btn_buff.x;
      }
      
      public function set y(param1:int) : void
      {
         this.btn_buff.y = param1;
      }
      
      public function get y() : int
      {
         return this.btn_buff.y;
      }
      
      public function get width() : int
      {
         return this.btn_buff.width;
      }
      
      public function get height() : int
      {
         return this.btn_buff.height;
      }
      
      public function get key() : String
      {
         return this._key;
      }
      
      public function get buffs() : Array
      {
         return this._buffs;
      }
      
      public function get spell() : Spell
      {
         return this._spell;
      }
      
      public function get unusableNextTurn() : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._buffs)
         {
            if(!_loc1_.unusableNextTurn)
            {
               return false;
            }
         }
         return true;
      }
      
      public function addBuff(param1:Object) : void
      {
         this._buffs.push(param1);
         if(param1.parentBoostUid != 0)
         {
            this._parentBoostUid = param1.parentBoostUid;
         }
         this.updateCooldown();
      }
      
      public function get parentBoostUid() : int
      {
         return this._parentBoostUid;
      }
      
      public function update(param1:Object) : void
      {
         this.updateCooldown();
      }
      
      public function removeBuff(param1:Object) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._buffs.length)
         {
            if(this._buffs[_loc2_] == param1)
            {
               this._buffs.splice(_loc2_,1);
               this.updateCooldown();
               break;
            }
            _loc2_++;
         }
         if(this._buffs.length == 0)
         {
            this.remove();
         }
      }
      
      public function remove() : void
      {
         if(this.btn_buff && !this.btn_buff)
         {
            if(this._ctr.contains(this.btn_buff))
            {
               this._ctr.removeChild(this.btn_buff);
            }
            this.btn_buff.remove();
         }
      }
      
      public function updateCooldown() : void
      {
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc2_:Boolean = false;
         for each(_loc4_ in this._buffs)
         {
            if(_loc2_ && _loc1_ != _loc4_.duration)
            {
               this.cooldown = -1;
            }
            if(_loc3_ == 0 || _loc4_.effect.delay < _loc3_)
            {
               _loc3_ = _loc4_.effect.delay;
            }
            _loc1_ = _loc4_.duration;
            _loc2_ = true;
         }
         if(_loc3_ > 0)
         {
            this.cooldown = _loc3_;
         }
         else
         {
            this.cooldown = _loc1_;
         }
         if(this.unusableNextTurn)
         {
            this.tx_buff.disabled = true;
         }
      }
   }
}
