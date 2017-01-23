package com.ankamagames.dofus.internalDatacenter.guild
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.BasicGuildInformations;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemGenericQuantity;
   import com.ankamagames.dofus.network.types.game.guild.tax.AdditionalTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   
   public class TaxCollectorWrapper
   {
       
      
      public function TaxCollectorWrapper()
      {
         super();
      }
      
      public function get uniqueId() : int
      {
         return new int();
      }
      
      public function get guild() : BasicGuildInformations
      {
         return new BasicGuildInformations();
      }
      
      public function get firstName() : String
      {
         return new String();
      }
      
      public function get lastName() : String
      {
         return new String();
      }
      
      public function get entityLook() : EntityLook
      {
         return new EntityLook();
      }
      
      public function get tiphonEntityLook() : Object
      {
         return new Object();
      }
      
      public function get additionalInformation() : AdditionalTaxCollectorInformations
      {
         return new AdditionalTaxCollectorInformations();
      }
      
      public function get mapWorldX() : int
      {
         return new int();
      }
      
      public function get mapWorldY() : int
      {
         return new int();
      }
      
      public function get subareaId() : int
      {
         return new int();
      }
      
      public function get state() : int
      {
         return new int();
      }
      
      public function get fightTime() : Number
      {
         return new Number();
      }
      
      public function get waitTimeForPlacement() : Number
      {
         return new Number();
      }
      
      public function get nbPositionPerTeam() : uint
      {
         return new uint();
      }
      
      public function get kamas() : int
      {
         return new int();
      }
      
      public function get experience() : int
      {
         return new int();
      }
      
      public function get pods() : int
      {
         return new int();
      }
      
      public function get itemsValue() : int
      {
         return new int();
      }
      
      public function get collectedItems() : Vector.<ObjectItemGenericQuantity>
      {
         return new Vector.<ObjectItemGenericQuantity>();
      }
      
      public function get callerId() : Number
      {
         return new Number();
      }
      
      public function get callerName() : String
      {
         return new String();
      }
   }
}
