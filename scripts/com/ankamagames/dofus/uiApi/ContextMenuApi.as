package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.interfaces.IMenuMaker;
   import com.ankamagames.berilia.types.data.ContextMenuData;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.jerakine.utils.misc.CheckCompatibility;
   
   [InstanciedApi]
   public class ContextMenuApi implements IApi
   {
       
      
      public function ContextMenuApi()
      {
         super();
      }
      
      [Untrusted]
      public function registerMenuMaker(param1:String, param2:Class) : void
      {
         if(CheckCompatibility.isCompatible(IMenuMaker,param2))
         {
            MenusFactory.registerMaker(param1,param2);
            return;
         }
         throw new ApiError(param1 + " maker class is not compatible with IMenuMaker");
      }
      
      [Untrusted]
      public function create(param1:*, param2:String = null, param3:Array = null) : ContextMenuData
      {
         var _loc4_:ContextMenuData = MenusFactory.create(param1,param2,param3);
         return _loc4_;
      }
      
      [NoBoxing]
      [Untrusted]
      public function getMenuMaker(param1:String) : Object
      {
         return MenusFactory.getMenuMaker(param1);
      }
   }
}
