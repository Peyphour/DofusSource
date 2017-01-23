package d2network
{
   import utils.ReadOnlyData;
   
   public class GameContextActorInformations extends ReadOnlyData
   {
       
      
      public function GameContextActorInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get contextualId() : Number
      {
         return _target.contextualId;
      }
      
      public function get look() : EntityLook
      {
         return secure(_target.look);
      }
      
      public function get disposition() : EntityDispositionInformations
      {
         return secure(_target.disposition);
      }
   }
}
