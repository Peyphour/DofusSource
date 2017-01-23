package d2data
{
   import utils.ReadOnlyData;
   
   public class TreasureHuntStepWrapper extends ReadOnlyData
   {
       
      
      public function TreasureHuntStepWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get index() : uint
      {
         return _target.index;
      }
      
      public function get type() : uint
      {
         return _target.type;
      }
      
      public function get direction() : int
      {
         return _target.direction;
      }
      
      public function get mapId() : int
      {
         return _target.mapId;
      }
      
      public function get poiLabel() : uint
      {
         return _target.poiLabel;
      }
      
      public function get flagState() : int
      {
         return _target.flagState;
      }
      
      public function get count() : uint
      {
         return _target.count;
      }
   }
}
