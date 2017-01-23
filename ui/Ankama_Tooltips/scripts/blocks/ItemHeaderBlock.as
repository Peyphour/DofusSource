package blocks
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   
   public class ItemHeaderBlock
   {
       
      
      private var _content:String;
      
      private var _block:Object;
      
      private var _item:ItemWrapper;
      
      private var _weapon:WeaponWrapper;
      
      private var _contextual:Boolean = false;
      
      private var _showTitleAndIcon:Boolean = true;
      
      private var sysApi:SystemApi;
      
      private var playerApi:PlayedCharacterApi;
      
      private var uiApi:UiApi;
      
      public function ItemHeaderBlock(param1:Item, param2:Object, param3:String = "chunks")
      {
         super();
         this.addApis();
         this._item = param1 as ItemWrapper;
         this._weapon = param1 as WeaponWrapper;
         if(param2.hasOwnProperty("contextual"))
         {
            this._contextual = param2.contextual;
         }
         if(param2.hasOwnProperty("header"))
         {
            this._showTitleAndIcon = param2.header;
         }
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         var _loc4_:Array = [Api.tooltip.createChunkData("separator",param3 + "/base/separator.txt")];
         if(this._showTitleAndIcon)
         {
            _loc4_.push(Api.tooltip.createChunkData("header",param3 + "/item/header.txt"));
         }
         if(this._weapon)
         {
            _loc4_.push(Api.tooltip.createChunkData("weaponDetails",param3 + "/item/weaponDetails.txt"));
         }
         if(this._item.etheral)
         {
            _loc4_.push(Api.tooltip.createChunkData("p",param3 + "/text/p.txt"));
         }
         this._block.initChunk(_loc4_);
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc2_:Object = null;
         var _loc1_:Object = this.getItemHeaderChunkParams(this._item);
         this._content = "";
         if(this._showTitleAndIcon)
         {
            this._content = this._content + this._block.getChunk("header").processContent(_loc1_);
         }
         if(this._weapon)
         {
            if(this._content)
            {
               this._content = this._content + this._block.getChunk("separator").processContent({});
            }
            _loc1_ = this.getWeaponDetailsChunkParams(this._weapon);
            this._content = this._content + this._block.getChunk("weaponDetails").processContent(_loc1_);
         }
         if(this._item.etheral)
         {
            for each(_loc2_ in this._item.effects)
            {
               if(_loc2_.effectId == 812)
               {
                  this._content = this._content + this._block.getChunk("p").processContent({"text":"[ui.common.ethereal], " + _loc2_.description});
                  break;
               }
            }
         }
         this.removeApis();
      }
      
      public function getContent() : String
      {
         return this._content;
      }
      
      public function get block() : Object
      {
         return this._block;
      }
      
      private function getItemHeaderChunkParams(param1:Item) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.name = this._item.name;
         if(this.sysApi.getPlayerManager().hasRights)
         {
            _loc2_.name = _loc2_.name + (" (" + this._item.objectGID + ")");
         }
         _loc2_.level = this._item.level;
         var _loc3_:* = this.playerApi.getPlayedCharacterInfo();
         var _loc4_:String = "headerp";
         var _loc5_:* = this._item.category == 2;
         if(!_loc5_ && _loc3_ && _loc3_.level < this._item.level)
         {
            _loc4_ = "headermalus";
         }
         _loc2_.cssLvl = _loc4_;
         return _loc2_;
      }
      
      private function getWeaponDetailsChunkParams(param1:WeaponWrapper) : Object
      {
         var _loc4_:String = null;
         var _loc5_:CharacterCharacteristicsInformations = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Object = new Object();
         _loc2_.apCost = param1.apCost;
         var _loc3_:String = param1.minRange == param1.range?param1.range.toString():param1.minRange + " - " + param1.range;
         _loc2_.range = _loc3_;
         _loc2_.critical = "";
         if(param1.criticalFailureProbability || param1.criticalHitProbability)
         {
            if(param1.criticalHitProbability)
            {
               if(param1.criticalHitBonus > 0)
               {
                  _loc4_ = "+";
               }
               else if(param1.criticalHitBonus < 0)
               {
                  _loc4_ = "-";
               }
               _loc5_ = this.playerApi.characteristics();
               if(!this._contextual || !_loc5_)
               {
                  _loc2_.critical = _loc2_.critical + (param1.criticalHitProbability + "%");
               }
               else
               {
                  _loc6_ = _loc5_.criticalHit;
                  _loc7_ = _loc6_.alignGiftBonus + _loc6_.base + _loc6_.contextModif + _loc6_.objectsAndMountBonus;
                  _loc8_ = 55 - param1.criticalHitProbability - _loc7_;
                  if(_loc8_ > 54)
                  {
                     _loc8_ = 54;
                  }
                  _loc9_ = 55 - 1 / (1 / _loc8_);
                  if(_loc9_ > 100)
                  {
                     _loc9_ = 100;
                  }
                  _loc2_.critical = _loc2_.critical + (_loc9_ + "%");
               }
               if(_loc4_)
               {
                  _loc2_.critical = _loc2_.critical + (" ( " + _loc4_ + param1.criticalHitBonus + " " + this.uiApi.getText("ui.stats.damagesBonus") + " )");
               }
            }
         }
         else
         {
            _loc2_.critical = _loc2_.critical + "-";
         }
         if(param1.maxCastPerTurn)
         {
            _loc2_.useLimits = this.uiApi.processText(this.uiApi.getText("ui.item.usePerTurn","<span class=\'value\'>" + param1.maxCastPerTurn + "</span>"),"n",param1.maxCastPerTurn <= 1);
         }
         return _loc2_;
      }
      
      private function addApis() : void
      {
         this.sysApi = Api.system;
         this.playerApi = Api.player;
         this.uiApi = Api.ui;
      }
      
      private function removeApis() : void
      {
         this.sysApi = null;
         this.playerApi = null;
         this.uiApi = null;
      }
   }
}
