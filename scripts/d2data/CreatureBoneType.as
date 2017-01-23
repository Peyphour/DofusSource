package d2data
{
   import utils.ReadOnlyData;
   
   public class CreatureBoneType extends ReadOnlyData
   {
       
      
      public function CreatureBoneType(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get creatureBoneId() : int
      {
         return _target.creatureBoneId;
      }
   }
}
