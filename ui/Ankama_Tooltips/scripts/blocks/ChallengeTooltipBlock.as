package blocks
{
   public class ChallengeTooltipBlock
   {
       
      
      private var _challenge:Object;
      
      private var _content:String;
      
      private var _block:Object;
      
      public function ChallengeTooltipBlock(param1:Object)
      {
         super();
         this._challenge = param1;
         this._block = Api.tooltip.createTooltipBlock(this.onAllChunkLoaded,this.getContent);
         this._block.initChunk([Api.tooltip.createChunkData("header","chunks/challenge/header.txt")]);
      }
      
      public function onAllChunkLoaded() : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:Object = Api.ui;
         var _loc2_:Object = Api.data;
         var _loc3_:Object = Api.fight;
         switch(this._challenge.result)
         {
            case 0:
               _loc4_ = _loc1_.getText("ui.fight.challenge.inProgress");
               _loc5_ = "p";
               break;
            case 1:
               _loc4_ = _loc1_.getText("ui.fight.challenge.complete");
               _loc5_ = "bonus";
               break;
            case 2:
               _loc4_ = _loc1_.getText("ui.fight.challenge.failed");
               _loc5_ = "malus";
         }
         this._content = this._block.getChunk("header").processContent({
            "loot":_loc1_.getText("ui.common.loot") + " +" + this._challenge.dropBonus + "%",
            "experience":_loc1_.getText("ui.common.xp") + " +" + this._challenge.xpBonus + "%",
            "state":_loc4_,
            "cssClass":_loc5_
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
