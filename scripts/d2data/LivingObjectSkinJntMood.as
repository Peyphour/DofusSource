package d2data
{
   import utils.ReadOnlyData;
   
   public class LivingObjectSkinJntMood extends ReadOnlyData
   {
       
      
      public function LivingObjectSkinJntMood(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get skinId() : int
      {
         return _target.skinId;
      }
      
      public function get moods() : Object
      {
         return secure(_target.moods);
      }
   }
}
