package com.ankamagames.dofus.network.types.game.prism
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   
   public class AllianceInsiderPrismInformation extends PrismInformation
   {
       
      
      public function AllianceInsiderPrismInformation()
      {
         super();
      }
      
      public function get lastTimeSlotModificationDate() : uint
      {
         return new uint();
      }
      
      public function get lastTimeSlotModificationAuthorGuildId() : uint
      {
         return new uint();
      }
      
      public function get lastTimeSlotModificationAuthorId() : Number
      {
         return new Number();
      }
      
      public function get lastTimeSlotModificationAuthorName() : String
      {
         return new String();
      }
      
      public function get modulesObjects() : Vector.<ObjectItem>
      {
         return new Vector.<ObjectItem>();
      }
   }
}
