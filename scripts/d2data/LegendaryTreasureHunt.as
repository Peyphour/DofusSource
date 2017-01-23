package d2data
{
   import utils.ReadOnlyData;
   
   public class LegendaryTreasureHunt extends ReadOnlyData
   {
       
      
      public function LegendaryTreasureHunt(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get chestId() : uint
      {
         return _target.chestId;
      }
      
      public function get monsterId() : uint
      {
         return _target.monsterId;
      }
      
      public function get mapItemId() : uint
      {
         return _target.mapItemId;
      }
      
      public function get xpRatio() : Number
      {
         return _target.xpRatio;
      }
   }
}
