package d2data
{
   import utils.ReadOnlyData;
   
   public class NpcMessage extends ReadOnlyData
   {
       
      
      public function NpcMessage(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get messageId() : uint
      {
         return _target.messageId;
      }
   }
}
