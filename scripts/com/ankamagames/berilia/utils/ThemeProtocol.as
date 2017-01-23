package com.ankamagames.berilia.utils
{
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.resources.IResourceObserver;
   import com.ankamagames.jerakine.resources.protocols.IProtocol;
   import com.ankamagames.jerakine.resources.protocols.impl.FileProtocol;
   import com.ankamagames.jerakine.types.Uri;
   
   public class ThemeProtocol extends FileProtocol implements IProtocol
   {
      
      private static var _themePath:String;
       
      
      public function ThemeProtocol()
      {
         super();
      }
      
      override protected function loadDirectly(param1:Uri, param2:IResourceObserver, param3:Boolean, param4:Class) : void
      {
         var _loc5_:String = null;
         getAdapter(param1,param4);
         if(!_themePath)
         {
            _themePath = XmlConfig.getInstance().getEntry("config.ui.skin");
         }
         if(param1.protocol == "theme")
         {
            _loc5_ = _themePath + param1.path;
         }
         else
         {
            _loc5_ = param1.path;
         }
         _adapter.loadDirectly(param1,extractPath(_loc5_.split("file://").join("")),param2,param3);
      }
   }
}
