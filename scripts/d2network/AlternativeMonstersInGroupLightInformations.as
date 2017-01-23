package d2network
{
   import utils.ReadOnlyData;
   
   public class AlternativeMonstersInGroupLightInformations extends ReadOnlyData
   {
       
      
      public function AlternativeMonstersInGroupLightInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get playerCount() : int
      {
         return _target.playerCount;
      }
      
      public function get monsters() : Object
      {
         return secure(_target.monsters);
      }
   }
}
