package com.ankamagames.dofus.internalDatacenter.items
{
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   import com.ankamagames.jerakine.types.Uri;
   
   public class IdolsPresetWrapper extends PresetWrapper implements IDataCenter
   {
       
      
      public var idolsIds:Vector.<uint>;
      
      public function IdolsPresetWrapper()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:Vector.<uint>) : IdolsPresetWrapper
      {
         var _loc4_:IdolsPresetWrapper = new IdolsPresetWrapper();
         _loc4_.id = param1;
         _loc4_.gfxId = param2;
         _loc4_.idolsIds = param3;
         return _loc4_;
      }
      
      override public function getIconUri(param1:Boolean = true) : Uri
      {
         return new Uri(XmlConfig.getInstance().getEntry("config.gfx.path") + ("presets/idols.swf|icon_" + gfxId));
      }
   }
}
