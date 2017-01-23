package d2data
{
   import utils.ReadOnlyData;
   
   public class CensoredWord extends ReadOnlyData
   {
       
      
      public function CensoredWord(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get listId() : uint
      {
         return _target.listId;
      }
      
      public function get language() : String
      {
         return _target.language;
      }
      
      public function get word() : String
      {
         return _target.word;
      }
      
      public function get deepLooking() : Boolean
      {
         return _target.deepLooking;
      }
   }
}
