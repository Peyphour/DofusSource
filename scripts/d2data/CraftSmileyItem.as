package d2data
{
   import utils.ReadOnlyData;
   
   public class CraftSmileyItem extends ReadOnlyData
   {
       
      
      public function CraftSmileyItem(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get playerId() : Number
      {
         return _target.playerId;
      }
      
      public function get iconId() : int
      {
         return _target.iconId;
      }
      
      public function get craftResult() : uint
      {
         return _target.craftResult;
      }
   }
}
