package d2data
{
   import utils.ReadOnlyData;
   
   public class InfoMessage extends ReadOnlyData
   {
       
      
      public function InfoMessage(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get typeId() : uint
      {
         return _target.typeId;
      }
      
      public function get messageId() : uint
      {
         return _target.messageId;
      }
      
      public function get textId() : uint
      {
         return _target.textId;
      }
   }
}
