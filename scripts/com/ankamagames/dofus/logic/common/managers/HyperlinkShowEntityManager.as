package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.TextTooltipInfo;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.messages.Frame;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class HyperlinkShowEntityManager
   {
       
      
      public function HyperlinkShowEntityManager()
      {
         super();
      }
      
      public static function showEntity(param1:Number, param2:int = 0) : Sprite
      {
         var _loc4_:Rectangle = null;
         var _loc3_:DisplayObject = DofusEntities.getEntity(param1) as DisplayObject;
         if(_loc3_)
         {
            if(param2)
            {
               HyperlinkShowCellManager.showCell((_loc3_ as IEntity).position.cellId);
               return null;
            }
            _loc4_ = _loc3_.getRect(Berilia.getInstance().docMain);
            return HyperlinkDisplayArrowManager.showAbsoluteArrow(new Rectangle(int(_loc4_.x),int(_loc4_.y),0,0));
         }
         return null;
      }
      
      public static function getEntityName(param1:Number, param2:int = 0) : String
      {
         var _loc3_:Frame = Kernel.getWorker().getFrame(FightContextFrame);
         if(!_loc3_)
         {
            return "???";
         }
         var _loc4_:String = (_loc3_ as FightContextFrame).getFighterName(param1);
         return _loc4_;
      }
      
      public static function rollOver(param1:int, param2:int, param3:Number, param4:int = 0) : void
      {
         var _loc5_:Rectangle = new Rectangle(param1,param2,10,10);
         var _loc6_:TextTooltipInfo = new TextTooltipInfo(I18n.getUiText("ui.tooltip.chat.whereAreYou"));
         TooltipManager.show(_loc6_,_loc5_,UiModuleManager.getInstance().getModule("Ankama_GameUiCore"),false,"HyperLink",6,2,3,true,null,null,null,null,false,StrataEnum.STRATA_TOOLTIP,1);
      }
   }
}
