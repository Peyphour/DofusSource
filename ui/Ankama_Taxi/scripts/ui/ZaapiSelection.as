package ui
{
   import com.ankamagames.dofus.internalDatacenter.taxi.TeleportDestinationWrapper;
   import d2actions.TeleportRequest;
   
   public class ZaapiSelection extends ZaapSelection
   {
       
      
      private var _currentZaapiCoord:String;
      
      public function ZaapiSelection()
      {
         super();
      }
      
      override public function main(param1:Array) : void
      {
         lbl_btn_tab1.text = uiApi.getText("ui.map.craftHouse");
         lbl_btn_tab2.text = uiApi.getText("ui.map.bidHouse");
         lbl_btn_tab3.text = uiApi.getText("ui.common.misc");
         lbl_title.text = uiApi.getText("ui.zaap.zaapi");
         lbl_noDestination.visible = false;
         super.main(param1);
         btn_showUnknowZaap.visible = false;
         tx_currentRespawn.visible = false;
         btn_save.visible = false;
      }
      
      private function validateZaapChoice() : void
      {
         var _loc1_:TeleportDestinationWrapper = gd_zaap.selectedItem;
         if(!_loc1_)
         {
            return;
         }
         sysApi.sendAction(new TeleportRequest(1,_loc1_.mapId,_loc1_.cost));
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case btn_tab1:
               _tab1List = sortZaap(_tab1List,"name");
               gd_zaap.dataProvider = _tab1List;
               break;
            case btn_tab2:
               _tab2List = sortZaap(_tab2List,"name");
               gd_zaap.dataProvider = _tab2List;
               break;
            case btn_tab3:
               _tab3List = sortZaap(_tab3List,"name");
               gd_zaap.dataProvider = _tab3List;
         }
         super.onRelease(param1);
      }
      
      override public function onZaapList(param1:Object) : void
      {
         var _loc2_:* = undefined;
         _tab1List = new Array();
         _tab2List = new Array();
         _tab3List = new Array();
         _fullZaapList = new Array();
         for(_loc2_ in param1)
         {
            _fullZaapList.push(param1[_loc2_]);
            if(param1[_loc2_].mapId == playerApi.currentMap().mapId)
            {
               _currentZaapName = param1[_loc2_].name;
               this._currentZaapiCoord = param1[_loc2_].coord;
               lbl_title.text = uiApi.getText("ui.zaap.zaapi") + " " + param1[_loc2_].subArea.name;
            }
            else if(param1[_loc2_].category == 3)
            {
               _tab1List.push(param1[_loc2_]);
            }
            else if(param1[_loc2_].category == 2)
            {
               _tab2List.push(param1[_loc2_]);
            }
            else
            {
               _tab3List.push(param1[_loc2_]);
            }
         }
         if(_favoriteZaap && _favoriteZaap.indexOf(_currentZaapName) != -1)
         {
            tx_fav.uri = _uriYellowStar;
         }
         else
         {
            tx_fav.uri = _uriEmptyStar;
         }
         if(_tab1List.length == 0)
         {
            btn_tab1.disabled = true;
         }
         else
         {
            _tab1List = sortZaap(_tab1List,"name");
         }
         if(_tab2List.length == 0)
         {
            btn_tab2.disabled = true;
         }
         else
         {
            btn_tab2.disabled = false;
            _tab2List = sortZaap(_tab2List,"name");
         }
         if(_tab3List.length == 0)
         {
            btn_tab3.disabled = true;
         }
         else
         {
            btn_tab3.disabled = false;
            _tab3List = sortZaap(_tab3List,"name");
         }
         if(!btn_tab1.disabled)
         {
            uiApi.setRadioGroupSelectedItem("tabHGroup",btn_tab1,uiApi.me());
            btn_tab1.selected = true;
            gd_zaap.dataProvider = _tab1List;
            _currentdataProvider = _tab1List.concat();
         }
         else if(!btn_tab2.disabled)
         {
            uiApi.setRadioGroupSelectedItem("tabHGroup",btn_tab2,uiApi.me());
            btn_tab2.selected = true;
            gd_zaap.dataProvider = _tab2List;
            _currentdataProvider = _tab2List.concat();
         }
         else if(!btn_tab3.disabled)
         {
            uiApi.setRadioGroupSelectedItem("tabHGroup",btn_tab3,uiApi.me());
            btn_tab3.selected = true;
            gd_zaap.dataProvider = _tab3List;
            _currentdataProvider = _tab3List.concat();
         }
      }
   }
}
