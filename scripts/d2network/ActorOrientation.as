package d2network
{
   import utils.ReadOnlyData;
   
   public class ActorOrientation extends ReadOnlyData
   {
       
      
      public function ActorOrientation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
      
      public function get direction() : uint
      {
         return _target.direction;
      }
   }
}
