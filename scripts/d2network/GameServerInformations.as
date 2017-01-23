package d2network
{
   import utils.ReadOnlyData;
   
   public class GameServerInformations extends ReadOnlyData
   {
       
      
      public function GameServerInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get type() : int
      {
         return _target.type;
      }
      
      public function get status() : uint
      {
         return _target.status;
      }
      
      public function get completion() : uint
      {
         return _target.completion;
      }
      
      public function get isSelectable() : Boolean
      {
         return _target.isSelectable;
      }
      
      public function get charactersCount() : uint
      {
         return _target.charactersCount;
      }
      
      public function get charactersSlots() : uint
      {
         return _target.charactersSlots;
      }
      
      public function get date() : Number
      {
         return _target.date;
      }
   }
}
