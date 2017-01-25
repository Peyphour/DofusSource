package com.ankamagames.dofus.internalDatacenter.items
{
   import com.ankamagames.dofus.datacenter.communication.Smiley#7797;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.SmileyWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.EmoticonFrame;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.interfaces.ISlotData;
   import com.ankamagames.jerakine.interfaces.ISlotDataHolder;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Uri;
   import flash.system.LoaderContext;
   import flash.utils.Proxy;
   import flash.utils.flash_proxy;
   import flash.utils.getQualifiedClassName;
   
   public class ShortcutWrapper extends Proxy implements ISlotData, IDataCenter
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(ShortcutWrapper));
      
      private static const TYPE_ITEM_WRAPPER:int = 0;
      
      private static const TYPE_PRESET_WRAPPER:int = 1;
      
      private static const TYPE_SPELL_WRAPPER:int = 2;
      
      private static const TYPE_SMILEY_WRAPPER:int = 3;
      
      private static const TYPE_EMOTE_WRAPPER:int = 4;
      
      private static const TYPE_IDOLS_PRESET_WRAPPER:int = 5;
      
      private static var _errorIconUri:Uri;
      
      private static var _uriLoaderContext:LoaderContext;
      
      private static var _properties:Array;
       
      
      private var _uri:Uri;
      
      private var _uriFullsize:Uri;
      
      private var _backGroundIconUri:Uri;
      
      private var _active:Boolean = true;
      
      private var _setCount:int = 0;
      
      public var slot:uint = 0;
      
      public var id:int = 0;
      
      public var gid:int = 0;
      
      public var type:int = 0;
      
      public var quantity:int = 0;
      
      public function ShortcutWrapper()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint = 0, param4:uint = 0) : ShortcutWrapper
      {
         var _loc6_:ItemWrapper = null;
         var _loc7_:EmoteWrapper = null;
         var _loc8_:EmoticonFrame = null;
         var _loc9_:Smiley = null;
         var _loc10_:SmileyWrapper = null;
         var _loc5_:ShortcutWrapper = new ShortcutWrapper();
         _loc5_.slot = param1;
         _loc5_.id = param2;
         _loc5_.type = param3;
         _loc5_.gid = param4;
         if(param3 == TYPE_ITEM_WRAPPER)
         {
            if(param2 != 0)
            {
               _loc6_ = InventoryManager.getInstance().inventory.getItem(param2);
            }
            else
            {
               _loc6_ = ItemWrapper.create(0,0,param4,0,null,false);
            }
            if(_loc6_)
            {
               _loc5_.quantity = _loc6_.quantity;
            }
            if(_loc5_.quantity == 0)
            {
               _loc5_.active = false;
            }
            else
            {
               _loc5_.active = true;
            }
         }
         if(param3 == TYPE_EMOTE_WRAPPER)
         {
            _loc7_ = EmoteWrapper.create(_loc5_.id,_loc5_.slot);
            _loc8_ = Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
            if(_loc8_.isKnownEmote(_loc5_.id))
            {
               _loc5_.active = true;
            }
            else
            {
               _loc5_.active = false;
            }
         }
         if(param3 == TYPE_SMILEY_WRAPPER && !SmileyWrapper.getSmileyWrapperById(param2))
         {
            _loc9_ = Smiley#7797.getSmileyById(param2);
            if(_loc9_)
            {
               _loc10_ = SmileyWrapper.create(_loc9_.id,_loc9_.gfxId,0,_loc9_.categoryId);
            }
         }
         return _loc5_;
      }
      
      public function get iconUri() : Uri
      {
         return this.getIconUri(true);
      }
      
      public function get fullSizeIconUri() : Uri
      {
         return this.getIconUri(false);
      }
      
      public function get backGroundIconUri() : Uri
      {
         if(!this._backGroundIconUri)
         {
            this._backGroundIconUri = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin").concat("texture/slot/emptySlot.png"));
         }
         return this._backGroundIconUri;
      }
      
      public function set backGroundIconUri(param1:Uri) : void
      {
         this._backGroundIconUri = param1;
      }
      
      public function get errorIconUri() : Uri
      {
         if(!_errorIconUri)
         {
            _errorIconUri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path.item.bitmap").concat("error.png"));
         }
         return _errorIconUri;
      }
      
      public function get info1() : String
      {
         var _loc1_:SpellWrapper = null;
         if(this.type == TYPE_ITEM_WRAPPER)
         {
            return this.quantity.toString();
         }
         if(this.type == TYPE_SPELL_WRAPPER)
         {
            _loc1_ = SpellWrapper.getSpellWrapperById(this.id,this.getCharaId());
            return !!_loc1_?_loc1_.info1:"";
         }
         return "";
      }
      
      public function get startTime() : int
      {
         var _loc1_:EmoteWrapper = null;
         if(this.type == TYPE_EMOTE_WRAPPER)
         {
            _loc1_ = EmoteWrapper.getEmoteWrapperById(this.id);
            return !!_loc1_?int(_loc1_.startTime):0;
         }
         return 0;
      }
      
      public function get endTime() : int
      {
         var _loc1_:EmoteWrapper = null;
         if(this.type == TYPE_EMOTE_WRAPPER)
         {
            _loc1_ = EmoteWrapper.getEmoteWrapperById(this.id);
            return !!_loc1_?int(_loc1_.endTime):0;
         }
         return 0;
      }
      
      public function set endTime(param1:int) : void
      {
         var _loc2_:EmoteWrapper = null;
         if(this.type == TYPE_EMOTE_WRAPPER)
         {
            _loc2_ = EmoteWrapper.getEmoteWrapperById(this.id);
            if(_loc2_)
            {
               _loc2_.endTime = param1;
            }
         }
      }
      
      public function get timer() : int
      {
         var _loc1_:EmoteWrapper = null;
         if(this.type == TYPE_EMOTE_WRAPPER)
         {
            _loc1_ = EmoteWrapper.getEmoteWrapperById(this.id);
            return !!_loc1_?int(_loc1_.timer):0;
         }
         return 0;
      }
      
      public function get active() : Boolean
      {
         var _loc1_:SpellWrapper = null;
         var _loc2_:EmoticonFrame = null;
         if(this.type == TYPE_SPELL_WRAPPER)
         {
            _loc1_ = SpellWrapper.getSpellWrapperById(this.id,this.getCharaId());
            return !!_loc1_?Boolean(_loc1_.active):false;
         }
         if(this.type == TYPE_EMOTE_WRAPPER)
         {
            _loc2_ = Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
            return _loc2_.isKnownEmote(this.id);
         }
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
      }
      
      public function get realItem() : ISlotData
      {
         var _loc1_:ItemWrapper = null;
         var _loc2_:Vector.<IdolsPresetWrapper> = null;
         var _loc3_:IdolsPresetWrapper = null;
         if(this.type == TYPE_ITEM_WRAPPER)
         {
            if(this.id != 0)
            {
               _loc1_ = InventoryManager.getInstance().inventory.getItem(this.id);
            }
            else
            {
               _loc1_ = ItemWrapper.create(0,0,this.gid,0,null,false);
            }
            return _loc1_;
         }
         if(this.type == TYPE_PRESET_WRAPPER)
         {
            return InventoryManager.getInstance().presets[this.id];
         }
         if(this.type == TYPE_SPELL_WRAPPER)
         {
            return SpellWrapper.getSpellWrapperById(this.id,this.getCharaId());
         }
         if(this.type == TYPE_EMOTE_WRAPPER)
         {
            return EmoteWrapper.getEmoteWrapperById(this.id);
         }
         if(this.type == TYPE_SMILEY_WRAPPER)
         {
            return SmileyWrapper.getSmileyWrapperById(this.id);
         }
         if(this.type == TYPE_IDOLS_PRESET_WRAPPER)
         {
            _loc2_ = PlayedCharacterManager.getInstance().idolsPresets;
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.id == this.id)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         var itemWrapper:ItemWrapper = null;
         var presetWrapper:PresetWrapper = null;
         var emoteWrapper:EmoteWrapper = null;
         var spellWrapper:SpellWrapper = null;
         var name:* = param1;
         if(isAttribute(name))
         {
            return this[name];
         }
         if(this.type == TYPE_ITEM_WRAPPER)
         {
            if(this.id != 0)
            {
               itemWrapper = InventoryManager.getInstance().inventory.getItem(this.id);
            }
            else
            {
               itemWrapper = ItemWrapper.create(0,0,this.gid,0,null,false);
            }
            if(!itemWrapper)
            {
               _log.debug("Null item " + this.id + " - " + this.gid);
            }
            else
            {
               try
               {
                  return itemWrapper[name];
               }
               catch(e:Error)
               {
                  if(e.getStackTrace())
                  {
                     _log.error("Item " + id + " " + gid + " " + name + " : " + e.getStackTrace());
                  }
                  return "Error_on_item_" + name;
               }
            }
         }
         else if(this.type == TYPE_PRESET_WRAPPER)
         {
            presetWrapper = InventoryManager.getInstance().presets[this.id];
            if(!presetWrapper)
            {
               _log.debug("Null preset " + this.id + " - " + this.gid);
            }
            else
            {
               try
               {
                  return presetWrapper[name];
               }
               catch(e:Error)
               {
                  if(e.getStackTrace())
                  {
                     _log.error("Preset " + id + " " + name + " : " + e.getStackTrace());
                  }
                  return "Error_on_preset_" + name;
               }
            }
         }
         else if(this.type == TYPE_EMOTE_WRAPPER)
         {
            emoteWrapper = EmoteWrapper.getEmoteWrapperById(this.id);
            if(!emoteWrapper)
            {
               _log.debug("Null emote " + this.id);
            }
            else
            {
               try
               {
                  return emoteWrapper[name];
               }
               catch(e:Error)
               {
                  if(e.getStackTrace())
                  {
                     _log.error("Emote " + id + " " + name + " : " + e.getStackTrace());
                  }
                  return "Error_on_emote_" + name;
               }
            }
         }
         else if(this.type == TYPE_SPELL_WRAPPER)
         {
            spellWrapper = SpellWrapper.getSpellWrapperById(this.id,this.getCharaId());
            if(!spellWrapper)
            {
               _log.debug("Null preset " + this.id + " - " + this.gid);
            }
            else
            {
               try
               {
                  return presetWrapper[name];
               }
               catch(e:Error)
               {
                  if(e.getStackTrace())
                  {
                     _log.error("Preset " + id + " " + name + " : " + e.getStackTrace());
                  }
                  return "Error_on_preset_" + name;
               }
            }
         }
         return "Error on getProperty " + name;
      }
      
      override flash_proxy function callProperty(param1:*, ... rest) : *
      {
         var _loc3_:* = undefined;
         switch(QName(param1).localName)
         {
            case "toString":
               _loc3_ = "[ShortcutWrapper : type " + this.type + ", id " + this.id + ", slot " + this.slot + ", gid " + this.gid + ", quantity " + this.quantity + "]";
               break;
            case "hasOwnProperty":
               _loc3_ = this.hasProperty(param1);
         }
         return _loc3_;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return 0;
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return "nextName";
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         return false;
      }
      
      public function update(param1:uint, param2:uint, param3:uint = 0, param4:uint = 0) : void
      {
         var _loc5_:ItemWrapper = null;
         var _loc6_:EmoticonFrame = null;
         if(this.id != param2 || this.type != param3)
         {
            this._uri = this._uriFullsize = null;
         }
         this.slot = param1;
         this.id = param2;
         this.type = param3;
         this.gid = param4;
         this.active = true;
         if(this.type == TYPE_ITEM_WRAPPER)
         {
            if(this.id != 0)
            {
               _loc5_ = InventoryManager.getInstance().inventory.getItem(this.id);
               if(this._uri && _loc5_.iconUri != this._uri)
               {
                  this._uri = this._uriFullsize = null;
               }
            }
            else
            {
               _loc5_ = ItemWrapper.create(0,0,this.gid,0,null,false);
            }
            if(_loc5_)
            {
               this.quantity = _loc5_.quantity;
            }
            if(this.quantity == 0)
            {
               this.active = false;
            }
         }
         if(this.type == TYPE_PRESET_WRAPPER || this.type == TYPE_IDOLS_PRESET_WRAPPER)
         {
            this._uri = this._uriFullsize = null;
         }
         if(param3 == TYPE_EMOTE_WRAPPER)
         {
            _loc6_ = Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
            if(!_loc6_.isKnownEmote(param2))
            {
               this.active = false;
            }
         }
      }
      
      public function getIconUri(param1:Boolean = true) : Uri
      {
         var _loc2_:ItemWrapper = null;
         var _loc3_:ItemWrapper = null;
         var _loc4_:PresetWrapper = null;
         var _loc5_:SpellWrapper = null;
         var _loc6_:SmileyWrapper = null;
         var _loc7_:EmoteWrapper = null;
         var _loc8_:Vector.<IdolsPresetWrapper> = null;
         var _loc9_:IdolsPresetWrapper = null;
         var _loc10_:Boolean = false;
         if(this.type != TYPE_SPELL_WRAPPER || this.id != 0)
         {
            if(param1 && this._uri)
            {
               return this._uri;
            }
            if(!param1 && this._uriFullsize)
            {
               return this._uriFullsize;
            }
         }
         if(this.type == TYPE_ITEM_WRAPPER)
         {
            if(this.id != 0)
            {
               _loc2_ = InventoryManager.getInstance().inventory.getItem(this.id);
               if(_loc2_)
               {
                  this._uri = _loc2_.iconUri;
                  this._uriFullsize = _loc2_.fullSizeIconUri;
               }
               else
               {
                  this._uri = this._uriFullsize = null;
               }
            }
            else
            {
               _loc3_ = ItemWrapper.create(0,0,this.gid,0,null,false);
               if(_loc3_)
               {
                  this._uri = _loc3_.iconUri;
                  this._uriFullsize = _loc3_.fullSizeIconUri;
               }
               else
               {
                  this._uri = this._uriFullsize = null;
               }
            }
         }
         else if(this.type == TYPE_PRESET_WRAPPER)
         {
            _loc4_ = InventoryManager.getInstance().presets[this.id];
            if(_loc4_)
            {
               this._uri = _loc4_.iconUri;
               this._uriFullsize = _loc4_.fullSizeIconUri;
            }
            else
            {
               this._uri = this._uriFullsize = null;
            }
         }
         else if(this.type == TYPE_SPELL_WRAPPER)
         {
            _loc5_ = SpellWrapper.getSpellWrapperById(this.id,this.getCharaId());
            if(_loc5_)
            {
               this._uri = _loc5_.iconUri;
               this._uriFullsize = _loc5_.fullSizeIconUri;
            }
            else
            {
               this._uri = this._uriFullsize = null;
            }
         }
         else if(this.type == TYPE_SMILEY_WRAPPER)
         {
            _loc6_ = SmileyWrapper.getSmileyWrapperById(this.id);
            if(_loc6_)
            {
               this._uri = _loc6_.iconUri;
               this._uriFullsize = _loc6_.fullSizeIconUri;
            }
            else
            {
               this._uri = this._uriFullsize = null;
            }
         }
         else if(this.type == TYPE_EMOTE_WRAPPER)
         {
            _loc7_ = EmoteWrapper.getEmoteWrapperById(this.id);
            if(_loc7_)
            {
               this._uri = _loc7_.iconUri;
               this._uriFullsize = _loc7_.fullSizeIconUri;
            }
            else
            {
               this._uri = this._uriFullsize = null;
            }
         }
         else if(this.type == TYPE_IDOLS_PRESET_WRAPPER)
         {
            _loc8_ = PlayedCharacterManager.getInstance().idolsPresets;
            for each(_loc9_ in _loc8_)
            {
               if(_loc9_.id == this.id)
               {
                  _loc10_ = true;
                  this._uri = _loc9_.iconUri;
                  this._uriFullsize = _loc9_.fullSizeIconUri;
                  break;
               }
            }
            if(!_loc10_)
            {
               this._uri = this._uriFullsize = null;
            }
         }
         if(param1 && this._uri)
         {
            return this._uri;
         }
         if(!param1 && this._uriFullsize)
         {
            return this._uriFullsize;
         }
         return null;
      }
      
      public function clone() : ShortcutWrapper
      {
         var _loc1_:ShortcutWrapper = new ShortcutWrapper();
         _loc1_.slot = this.slot;
         _loc1_.id = this.id;
         _loc1_.type = this.type;
         _loc1_.gid = this.gid;
         _loc1_.quantity = this.quantity;
         return _loc1_;
      }
      
      public function addHolder(param1:ISlotDataHolder) : void
      {
         var _loc2_:SpellWrapper = null;
         var _loc3_:EmoteWrapper = null;
         if(this.type == TYPE_SPELL_WRAPPER)
         {
            _loc2_ = SpellWrapper.getSpellWrapperById(this.id,this.getCharaId());
            if(_loc2_)
            {
               _loc2_.addHolder(param1);
               _loc2_.setLinkedSlotData(this);
            }
         }
         else if(this.type == TYPE_EMOTE_WRAPPER)
         {
            _loc3_ = EmoteWrapper.getEmoteWrapperById(this.id);
            if(_loc3_)
            {
               _loc3_.addHolder(param1);
               _loc3_.setLinkedSlotData(this);
            }
         }
      }
      
      public function removeHolder(param1:ISlotDataHolder) : void
      {
      }
      
      private function getCharaId() : Number
      {
         if(CurrentPlayedFighterManager.getInstance().currentFighterId != 0)
         {
            return CurrentPlayedFighterManager.getInstance().currentFighterId;
         }
         return PlayedCharacterManager.getInstance().id;
      }
   }
}
