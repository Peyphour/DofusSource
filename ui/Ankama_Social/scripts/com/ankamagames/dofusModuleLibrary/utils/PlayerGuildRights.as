package com.ankamagames.dofusModuleLibrary.utils
{
   public class PlayerGuildRights
   {
       
      
      public function PlayerGuildRights()
      {
         super();
      }
      
      public static function isBoss(param1:uint) : Boolean
      {
         return (1 & param1) > 0;
      }
      
      public static function manageGuildBoosts(param1:uint) : Boolean
      {
         return isBoss(param1) || (2 & param1) > 0;
      }
      
      public static function manageRights(param1:uint) : Boolean
      {
         return isBoss(param1) || (4 & param1) > 0;
      }
      
      public static function inviteNewMembers(param1:uint) : Boolean
      {
         return isBoss(param1) || (8 & param1) > 0;
      }
      
      public static function banMembers(param1:uint) : Boolean
      {
         return isBoss(param1) || (16 & param1) > 0;
      }
      
      public static function manageXPContribution(param1:uint) : Boolean
      {
         return isBoss(param1) || (32 & param1) > 0;
      }
      
      public static function manageRanks(param1:uint) : Boolean
      {
         return isBoss(param1) || (64 & param1) > 0;
      }
      
      public static function manageMyXpContribution(param1:uint) : Boolean
      {
         return isBoss(param1) || (128 & param1) > 0;
      }
      
      public static function hireTaxCollector(param1:uint) : Boolean
      {
         return isBoss(param1) || (256 & param1) > 0;
      }
      
      public static function collect(param1:uint) : Boolean
      {
         return isBoss(param1) || (512 & param1) > 0;
      }
      
      public static function manageLightRights(param1:uint) : Boolean
      {
         return isBoss(param1) || (1024 & param1) > 0;
      }
      
      public static function useFarms(param1:uint) : Boolean
      {
         return isBoss(param1) || (4096 & param1) > 0;
      }
      
      public static function organizeFarms(param1:uint) : Boolean
      {
         return isBoss(param1) || (8192 & param1) > 0;
      }
      
      public static function takeOthersRidesInFarm(param1:uint) : Boolean
      {
         return isBoss(param1) || (16384 & param1) > 0;
      }
   }
}
