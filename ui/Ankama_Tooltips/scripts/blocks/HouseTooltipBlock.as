package blocks
{
   public class HouseTooltipBlock
   {
       
      
      private var _content:String;
      
      private var _infos:Object;
      
      private var _block:Object;
      
      public function HouseTooltipBlock(param1:Object, param2:int)
      {
         super();
         this._infos = param1;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         if(param2 == 0)
         {
            this._block.initChunk([Api.tooltip.createChunkData("content","chunks/world/house/house.txt")]);
         }
         else if(param2 == 1)
         {
            this._block.initChunk([Api.tooltip.createChunkData("content","chunks/world/house/housePrice.txt")]);
         }
         else if(param2 == 2)
         {
            this._block.initChunk([Api.tooltip.createChunkData("content","chunks/world/house/houseGuild.txt")]);
         }
         else if(param2 == 3)
         {
            this._block.initChunk([Api.tooltip.createChunkData("content","chunks/world/house/housePriceLocked.txt")]);
         }
      }
      
      public function onAllChunkLoaded() : void
      {
         this._content = this._block.getChunk("content").processContent(this._infos);
      }
      
      public function getContent() : String
      {
         return this._content;
      }
      
      public function get block() : Object
      {
         return this._block;
      }
   }
}
