package d2network
{
   public class AllianceInsiderPrismInformation extends PrismInformation
   {
       
      
      public function AllianceInsiderPrismInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get lastTimeSlotModificationDate() : uint
      {
         return _target.lastTimeSlotModificationDate;
      }
      
      public function get lastTimeSlotModificationAuthorGuildId() : uint
      {
         return _target.lastTimeSlotModificationAuthorGuildId;
      }
      
      public function get lastTimeSlotModificationAuthorId() : Number
      {
         return _target.lastTimeSlotModificationAuthorId;
      }
      
      public function get lastTimeSlotModificationAuthorName() : String
      {
         return _target.lastTimeSlotModificationAuthorName;
      }
      
      public function get modulesObjects() : Object
      {
         return secure(_target.modulesObjects);
      }
   }
}
