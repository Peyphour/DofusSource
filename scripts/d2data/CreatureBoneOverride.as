package d2data
{
   import utils.ReadOnlyData;
   
   public class CreatureBoneOverride extends ReadOnlyData
   {
       
      
      public function CreatureBoneOverride(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get boneId() : int
      {
         return _target.boneId;
      }
      
      public function get creatureBoneId() : int
      {
         return _target.creatureBoneId;
      }
   }
}
