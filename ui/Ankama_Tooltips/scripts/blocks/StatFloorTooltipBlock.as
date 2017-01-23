package blocks
{
   public class StatFloorTooltipBlock
   {
       
      
      private var _content:String;
      
      private var _block:Object;
      
      private var _floor:uint;
      
      private var _statInterval:String;
      
      private var _statCost:String;
      
      public function StatFloorTooltipBlock(param1:uint, param2:String, param3:String)
      {
         super();
         this._floor = param1;
         this._statInterval = param2;
         this._statCost = param3;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk([Api.tooltip.createChunkData("content","chunks/stats/statFloor.txt")]);
      }
      
      public function onAllChunkLoaded() : void
      {
         this._content = this._block.getChunk("content").processContent({
            "floor":this._floor,
            "statInterval":this._statInterval,
            "statCost":this._statCost
         });
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
