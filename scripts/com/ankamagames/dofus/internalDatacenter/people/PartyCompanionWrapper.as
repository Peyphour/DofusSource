package com.ankamagames.dofus.internalDatacenter.people
{
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class PartyCompanionWrapper extends PartyMemberWrapper implements IDataCenter
   {
       
      
      public var companionGenericId:uint = 0;
      
      public var index:uint = 0;
      
      public var masterName:String = "";
      
      public function PartyCompanionWrapper(param1:Number, param2:String, param3:int, param4:Boolean, param5:int = 0, param6:EntityLook = null, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0)
      {
         var _loc12_:String = null;
         var _loc13_:String = Companion.getCompanionById(param3).name;
         if(param1 != PlayedCharacterManager.getInstance().id)
         {
            _loc12_ = I18n.getUiText("ui.common.belonging",[_loc13_,param2]);
         }
         else
         {
            _loc12_ = _loc13_;
         }
         super(param1,_loc12_,0,param4,false,param5,param6,param7,param8,param9,param10,0,param11,0,0,0,0,0,0,null);
         this.companionGenericId = param3;
         this.masterName = param2;
      }
      
      override public function get initiative() : int
      {
         return maxInitiative;
      }
   }
}
