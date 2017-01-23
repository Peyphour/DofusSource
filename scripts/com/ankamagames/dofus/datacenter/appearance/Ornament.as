package com.ankamagames.dofus.datacenter.appearance
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class Ornament implements IDataCenter
   {
      
      public static const MODULE:String = "Ornaments";
       
      
      public var id:int;
      
      public var nameId:uint;
      
      public var visible:Boolean;
      
      public var assetId:int;
      
      public var iconId:int;
      
      public var rarity:int;
      
      public var order:int;
      
      private var _name:String;
      
      public function Ornament()
      {
         super();
      }
      
      public static function getOrnamentById(param1:int) : Ornament
      {
         return GameData.getObject(MODULE,param1) as Ornament;
      }
      
      public static function getAllOrnaments() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public function get name() : String
      {
         if(!this._name)
         {
            this._name = I18n.getText(this.nameId);
         }
         return this._name;
      }
   }
}
