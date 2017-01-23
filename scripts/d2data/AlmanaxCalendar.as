package d2data
{
   import utils.ReadOnlyData;
   
   public class AlmanaxCalendar extends ReadOnlyData
   {
       
      
      public function AlmanaxCalendar(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get nameId() : uint
      {
         return _target.nameId;
      }
      
      public function get descId() : uint
      {
         return _target.descId;
      }
      
      public function get npcId() : int
      {
         return _target.npcId;
      }
      
      public function get bonusesIds() : Object
      {
         return secure(_target.bonusesIds);
      }
   }
}
