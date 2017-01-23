package com.ankamagames.dofus.datacenter.mounts
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class MountFamily implements IDataCenter
   {
      
      private static var MODULE:String = "MountFamily";
       
      
      public var id:uint;
      
      public var nameId:uint;
      
      public var headUri:String;
      
      private var _name:String;
      
      public function MountFamily()
      {
         super();
      }
      
      public static function getMountFamilyById(param1:uint) : MountFamily
      {
         return GameData.getObject(MODULE,param1) as MountFamily;
      }
      
      public static function getMountFamilies() : Array
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
