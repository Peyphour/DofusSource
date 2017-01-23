package d2network
{
   import utils.ReadOnlyData;
   
   public class HumanInformations extends ReadOnlyData
   {
       
      
      public function HumanInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get restrictions() : ActorRestrictionsInformations
      {
         return secure(_target.restrictions);
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get options() : Object
      {
         return secure(_target.options);
      }
   }
}
