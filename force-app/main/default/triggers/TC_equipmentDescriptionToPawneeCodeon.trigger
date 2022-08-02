/**
 * Created by zachaustin on 2019-05-14.
 */

trigger TC_equipmentDescriptionToPawneeCodeon on Equipment__c (before insert, before update) {


    for (Equipment__c e: Trigger.new) {

        if (e.Pawnee_Equipment_Code_Description__c == 'AIR COMPRESSOR'){e.Equipment_Code_Pawnee__c = '700';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'APU (Auxiliary Power Units)'){e.Equipment_Code_Pawnee__c = '485';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'AQUA MASSAGE'){e.Equipment_Code_Pawnee__c = '265';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'ART'){e.Equipment_Code_Pawnee__c = '460';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'ATM MACHINES (NON-ROUTE)'){e.Equipment_Code_Pawnee__c = '1';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'AUDIO/VIDEO EQUIPMENT'){e.Equipment_Code_Pawnee__c = '10';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'AUTO - EMISSIONS / SMOG TESTING'){e.Equipment_Code_Pawnee__c = '340';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'AUTO - SPRAY BOOTHS'){e.Equipment_Code_Pawnee__c = '370';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'AUTO REPAIR EQUIPMENT'){e.Equipment_Code_Pawnee__c = '20';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'BEAUTY SALON EQUIP'){e.Equipment_Code_Pawnee__c = '40';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'BEVERAGE MFG EQUIP'){e.Equipment_Code_Pawnee__c = '161';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'BODY COMPOSITION'){e.Equipment_Code_Pawnee__c = '275';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'CAR WASH EQUIPMENT'){e.Equipment_Code_Pawnee__c = '365';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'CARPET CLEANING'){e.Equipment_Code_Pawnee__c = '65';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'CHILDCARE EQUIPMENT'){e.Equipment_Code_Pawnee__c = '532';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'CLEANING EQUIPMENT'){e.Equipment_Code_Pawnee__c = '60';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'COMMUNICATION / RADIO / TV'){e.Equipment_Code_Pawnee__c = '550';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'COMPUTER EQUIPMENT'){e.Equipment_Code_Pawnee__c = '70';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'CONCESSION TRUCK/TRAILER'){e.Equipment_Code_Pawnee__c = '425';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'CONCRETE EQUIPMENT'){e.Equipment_Code_Pawnee__c = '80';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'CONSTRUCTION EQUIP'){e.Equipment_Code_Pawnee__c = '90';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'CONTAINER / COMMERCIAL / ROLL-OFF'){e.Equipment_Code_Pawnee__c = '581';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'CONTAINERS / RESIDENTAL / WASTE'){e.Equipment_Code_Pawnee__c = '580';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'COPIERS'){e.Equipment_Code_Pawnee__c = '30';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'DENTAL EQUIPMENT'){e.Equipment_Code_Pawnee__c = '640';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'DISPLAY / SHOW CASES'){e.Equipment_Code_Pawnee__c = '660';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'DRY CLEANING EQUIP'){e.Equipment_Code_Pawnee__c = '110';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'ELECTRICAL EQUIPMENT'){e.Equipment_Code_Pawnee__c = '121';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'EMBROIDERY / SEWING EQUIP'){e.Equipment_Code_Pawnee__c = '130';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'ENERGY EQUIPMENT'){e.Equipment_Code_Pawnee__c = '347';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'ENGRAVING EQUIPMENT'){e.Equipment_Code_Pawnee__c = '470';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'ENVIRONMENTAL EQUIPMENT'){e.Equipment_Code_Pawnee__c = '346';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'FIRE SUPRESSION'){e.Equipment_Code_Pawnee__c = '481';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'FITNESS EQUIP / MATS'){e.Equipment_Code_Pawnee__c = '150';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'FOOD MFG EQUIP'){e.Equipment_Code_Pawnee__c = '160';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'FORKLIFTS'){e.Equipment_Code_Pawnee__c = '170';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'FURNITURE'){e.Equipment_Code_Pawnee__c = '190';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'GAS PUMPS / PETROLEUM'){e.Equipment_Code_Pawnee__c = '670';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'GENERATORS (NOT APU)'){e.Equipment_Code_Pawnee__c = '486';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'GYMNASTICS EQUIPMENT'){e.Equipment_Code_Pawnee__c = '151';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'HVAC / HEATING / COOLING EQUIP'){e.Equipment_Code_Pawnee__c = '480';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'INFLATABLES'){e.Equipment_Code_Pawnee__c = '535';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'LANDSCAPE / HORICULTURE'){e.Equipment_Code_Pawnee__c = '230';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'LIGHTING - INSIDE/OUTSIDE'){e.Equipment_Code_Pawnee__c = '120';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'MANUFACTURE / MACHINE TOOLS'){e.Equipment_Code_Pawnee__c = '220';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'MANUFACTURING - OTHER EQUIP.'){e.Equipment_Code_Pawnee__c = '221';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'MEDICAL EQUIP'){e.Equipment_Code_Pawnee__c = '270';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'MUSICAL INSTRUMENTS'){e.Equipment_Code_Pawnee__c = '210';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'OFFICE EQUIPMENT'){e.Equipment_Code_Pawnee__c = '280';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'OTHER - PLEASE DESCRIBE'){e.Equipment_Code_Pawnee__c = '750';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'PHONE SYSTEMS'){e.Equipment_Code_Pawnee__c = '290';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'PHOTOGRAPHY EQUIPMENT'){e.Equipment_Code_Pawnee__c = '11';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'PLAYGROUND EQUIPMENT'){e.Equipment_Code_Pawnee__c = '531';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'PORTABLE TOILETS'){e.Equipment_Code_Pawnee__c = '520';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'POS (Point of Sale) System'){e.Equipment_Code_Pawnee__c = '300';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'POWER WASHERS'){e.Equipment_Code_Pawnee__c = '360';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'PRINTING EQUIP'){e.Equipment_Code_Pawnee__c = '310';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'RECREATION / SPORTS EQUIPMENT'){e.Equipment_Code_Pawnee__c = '530';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'REFRIGERATION - WALK-IN/STRUC.'){e.Equipment_Code_Pawnee__c = '100';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'RESTAURANT / BAR EQUIP'){e.Equipment_Code_Pawnee__c = '320';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'SCREEN PRINT EQUIP'){e.Equipment_Code_Pawnee__c = '610';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'SECURITY SYS / CAMERAS'){e.Equipment_Code_Pawnee__c = '600';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'SIGNAGE'){e.Equipment_Code_Pawnee__c = '330';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'SOFTWARE -  BUILT IN W/ EQUIP'){e.Equipment_Code_Pawnee__c = '351';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'SOFTWARE - OFF SHELF'){e.Equipment_Code_Pawnee__c = '350';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'STORAGE UNIT / PALLETS'){e.Equipment_Code_Pawnee__c = '510';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'TANNING BED/SPRAY'){e.Equipment_Code_Pawnee__c = '570';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'TITLED - BRUSH-CHIPPER'){e.Equipment_Code_Pawnee__c = '620';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'TITLED - TRAILER LIGHT-DUTY'){e.Equipment_Code_Pawnee__c = '390';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'TITLED - TRAILERS HEAVY-DUTY'){e.Equipment_Code_Pawnee__c = '400';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'TITLED - TRUCKS / CLASS 1-2'){e.Equipment_Code_Pawnee__c = '420';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'TITLED - TRUCKS / CLASS 3-5'){e.Equipment_Code_Pawnee__c = '710';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'TITLED - TRUCKS / CLASS 6-7'){e.Equipment_Code_Pawnee__c = '440';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'TITLED - TRUCKS / CLASS 8'){e.Equipment_Code_Pawnee__c = '720';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'TRAILERS (NON-TITLED)'){e.Equipment_Code_Pawnee__c = '410';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'VETERINARIAN EQUIPMENT'){e.Equipment_Code_Pawnee__c = '490';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'WASHER / DRYER / LAUNDRY'){e.Equipment_Code_Pawnee__c = '240';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'WATER COOLER'){e.Equipment_Code_Pawnee__c = '545';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'WATER TREATMENT'){e.Equipment_Code_Pawnee__c = '540';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'WELDING / METAL WORKING'){e.Equipment_Code_Pawnee__c = '200';}
        else if (e.Pawnee_Equipment_Code_Description__c == 'WOODWORKING EQUIPMENT'){e.Equipment_Code_Pawnee__c = '650';}


    }

}