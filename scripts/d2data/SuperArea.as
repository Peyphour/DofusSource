package d2data
{
   import utils.ReadOnlyData;
   
   public class SuperArea extends ReadOnlyData
   {
       
      
      public function SuperArea(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get worldmapId() : uint
      {
         return _target.worldmapId;
      }
      
      public function get hasWorldMap() : Boolean
      {
         return _target.hasWorldMap;
      }
   }
}
