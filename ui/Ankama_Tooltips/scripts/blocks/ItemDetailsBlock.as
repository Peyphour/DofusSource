package blocks
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.BuildTypeEnum;
   
   public class ItemDetailsBlock
   {
       
      
      private var _content:String;
      
      private var _contextual:Boolean = false;
      
      private var _item:ItemWrapper;
      
      private var _weapon:WeaponWrapper;
      
      private var _block:Object;
      
      private var _params:Object;
      
      private var sysApi:SystemApi;
      
      private var playerApi:PlayedCharacterApi;
      
      private var uiApi:UiApi;
      
      public function ItemDetailsBlock(param1:Object, param2:Object, param3:String = "chunks")
      {
         super();
         this.addApis();
         this._item = param1 as ItemWrapper;
         this._weapon = param1 as WeaponWrapper;
         if(param2 is Boolean)
         {
            this._params = null;
         }
         else
         {
            this._params = param2;
         }
         if(param2.hasOwnProperty("contextual"))
         {
            this._contextual = param2.contextual;
         }
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         var _loc4_:Array = [Api.tooltip.createChunkData("details",param3 + "/item/details.txt"),Api.tooltip.createChunkData("p",param3 + "/text/p.txt")];
         if(this._item.itemSetId != -1)
         {
            _loc4_.push(Api.tooltip.createChunkData("set",param3 + "/item/set.txt"));
         }
         this._block.initChunk(_loc4_);
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc3_:Object = null;
         this._content = "";
         if(this._item.itemSetId != -1)
         {
            _loc1_ = {"set":this._item.itemSet.name};
            this._content = this._content + this._block.getChunk("set").processContent(_loc1_);
         }
         _loc1_ = this.getItemDetailsChunkParams(this._item);
         this._content = this._content + this._block.getChunk("details").processContent(_loc1_);
         if(this._item.type && this._item.type.id == 93)
         {
            _loc2_ = "";
            for each(_loc3_ in this._item.effects)
            {
               if(_loc3_.effectId == 812)
               {
                  _loc2_ = _loc3_.description;
                  break;
               }
            }
            if(_loc2_)
            {
               this._content = this._content + this._block.getChunk("p").processContent({"text":_loc2_});
            }
         }
         if(this.sysApi.isInGame() && this._params.averagePrice && this._item.exchangeable)
         {
            this._content = this._content + this._block.getChunk("p").processContent({"text":Api.averagePrices.getItemAveragePriceString(this._item,false," <span class=\'value\'>","</span>")});
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
      
      private function getItemDetailsChunkParams(param1:Item) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.category = param1.type.name;
         if(this.sysApi.getBuildType() >= BuildTypeEnum.INTERNAL && param1.type.id)
         {
            _loc2_.category = _loc2_.category + (" (" + param1.type.id + ")");
         }
         if(param1.twoHanded)
         {
            _loc2_.category = _loc2_.category + " ( [ui.common.twoHandsWeapon] )";
         }
         if(param1.weight > 1)
         {
            _loc2_.weight = this.uiApi.processText(this.uiApi.getText("ui.common.short.weight",this._item.weight),"m",false);
         }
         else
         {
            _loc2_.weight = this.uiApi.processText(this.uiApi.getText("ui.common.short.weight",this._item.weight),"m",true);
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
