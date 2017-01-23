package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   
   public class UtilApi
   {
       
      
      public function UtilApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function callWithParameters(param1:Function, param2:Array) : void
      {
      }
      
      [Untrusted]
      public function callConstructorWithParameters(param1:Class, param2:Array) : *
      {
         return null;
      }
      
      [Untrusted]
      public function callRWithParameters(param1:Function, param2:Array) : *
      {
         return null;
      }
      
      [Untrusted]
      public function kamasToString(param1:Number, param2:String = "-") : String
      {
         return null;
      }
      
      [Untrusted]
      public function formateIntToString(param1:Number, param2:int = 2) : String
      {
         return null;
      }
      
      [Untrusted]
      public function stringToKamas(param1:String, param2:String = "-") : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getTextWithParams(param1:int, param2:Array, param3:String = "%") : String
      {
         return null;
      }
      
      [Untrusted]
      public function applyTextParams(param1:String, param2:Array, param3:String = "%") : String
      {
         return null;
      }
      
      [Trusted]
      public function noAccent(param1:String) : String
      {
         return null;
      }
      
      [Trusted]
      public function getAllIndexOf(param1:String, param2:String) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function changeColor(param1:Object, param2:Number, param3:int, param4:Boolean = false) : void
      {
      }
      
      [Untrusted]
      public function sortOnString(param1:*, param2:String = "", param3:Boolean = true) : void
      {
      }
      
      [Untrusted]
      public function sort(param1:*, param2:String, param3:Boolean = true, param4:Boolean = false) : *
      {
         return null;
      }
      
      [Untrusted]
      public function filter(param1:*, param2:*, param3:String) : *
      {
         return null;
      }
      
      [Untrusted]
      public function getTiphonEntityLook(param1:Number) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getRealTiphonEntityLook(param1:Number, param2:Boolean = false) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getLookFromContext(param1:Number, param2:Boolean = false) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getLookFromContextInfos(param1:GameContextActorInformations, param2:Boolean = false) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function isCreature(param1:Number) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isCreatureFromLook(param1:Object) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isIncarnation(param1:Number) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isIncarnationFromLook(param1:Object) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isCreatureMode() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getCreatureLook(param1:Number) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getGfxUri(param1:int) : String
      {
         return null;
      }
      
      [Untrusted]
      public function encodeToJson(param1:*) : String
      {
         return null;
      }
      
      [Untrusted]
      public function decodeJson(param1:String) : *
      {
         return null;
      }
      
      [Untrusted]
      public function getObjectsUnderPoint() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function isCharacteristicSpell(param1:SpellWrapper, param2:int, param3:Boolean = false) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getSpellBoost(param1:SpellWrapper, param2:int) : Object
      {
         return null;
      }
   }
}
