/**
 * Created by zachaustin on 2019-04-30.
 */

trigger TC_equipmentDescriptionToFinPacCodeon on Equipment__c (before insert, before update) {
    for (Equipment__c e: Trigger.new) {

        if (e.Equipment_Code_Description__c == 'VEHICLE-Auto'){ e.Equipment_Code_FP__c ='001.001';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Van/Box/Delivery'){ e.Equipment_Code_FP__c ='001.002';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Truck/Tractor w/Sleeper'){ e.Equipment_Code_FP__c ='001.003';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Special Purpose'){ e.Equipment_Code_FP__c ='001.011';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Dump Truck'){ e.Equipment_Code_FP__c ='001.016';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Garbage Truck'){ e.Equipment_Code_FP__c ='001.017';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Limousine'){ e.Equipment_Code_FP__c ='001.019';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Other'){ e.Equipment_Code_FP__c ='001.021';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Passanger Van/Bus'){ e.Equipment_Code_FP__c ='001.023';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Pickup/Flatbed'){ e.Equipment_Code_FP__c ='001.024';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Sweeper(Titled)'){ e.Equipment_Code_FP__c ='001.026';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Tow Truck'){ e.Equipment_Code_FP__c ='001.027';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Truck/Tractor w/o Sleeper'){ e.Equipment_Code_FP__c ='001.029';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Bucket/Crane Truck'){ e.Equipment_Code_FP__c ='001.030';}
        else if (e.Equipment_Code_Description__c == 'VEHICLE-Water Truck'){ e.Equipment_Code_FP__c ='001.031';}
        else if (e.Equipment_Code_Description__c == 'OFFICE EQUIPMENT'){ e.Equipment_Code_FP__c ='002.001';}
        else if (e.Equipment_Code_Description__c == 'COPIER'){ e.Equipment_Code_FP__c ='002.002';}
        else if (e.Equipment_Code_Description__c == 'OFFICE FURNITURE'){ e.Equipment_Code_FP__c ='002.016';}
        else if (e.Equipment_Code_Description__c == 'MAILING EQUIPMENT'){ e.Equipment_Code_FP__c ='002.019';}
        else if (e.Equipment_Code_Description__c == 'CHIROPRACTIC EQUIPMENT'){ e.Equipment_Code_FP__c ='003.012';}
        else if (e.Equipment_Code_Description__c == 'DENTAL EQUIPMENT'){ e.Equipment_Code_FP__c ='003.013';}
        else if (e.Equipment_Code_Description__c == 'HOME HEALTH CARE EQUIP'){ e.Equipment_Code_FP__c ='003.018';}
        else if (e.Equipment_Code_Description__c == 'ULTRASOUND EQUIP'){ e.Equipment_Code_FP__c ='003.019';}
        else if (e.Equipment_Code_Description__c == 'LAB TEST EQUIPMENT'){ e.Equipment_Code_FP__c ='003.021';}
        else if (e.Equipment_Code_Description__c == 'OPTICAL EQUIPMENT'){ e.Equipment_Code_FP__c ='003.023';}
        else if (e.Equipment_Code_Description__c == 'PHYSICAL THERAPY EQUIP'){ e.Equipment_Code_FP__c ='003.025';}
        else if (e.Equipment_Code_Description__c == 'X-RAY EQUIPMENT'){ e.Equipment_Code_FP__c ='003.026';}
        else if (e.Equipment_Code_Description__c == 'PHYSICIANS MEDICAL EQUIP'){ e.Equipment_Code_FP__c ='003.027';}
        else if (e.Equipment_Code_Description__c == 'LASERS - MEDICAL/COSMETIC'){ e.Equipment_Code_FP__c ='003.029';}
        else if (e.Equipment_Code_Description__c == 'KITCHEN EQUIPMENT'){ e.Equipment_Code_FP__c ='004.001';}
        else if (e.Equipment_Code_Description__c == 'ESPRESSO MACHINES'){ e.Equipment_Code_FP__c ='004.003';}
        else if (e.Equipment_Code_Description__c == 'FOOD & BEVERAGE SERVERS'){ e.Equipment_Code_FP__c ='004.012';}
        else if (e.Equipment_Code_Description__c == 'HOOD/FIRE SUPPRESSION SYSTEMS'){ e.Equipment_Code_FP__c ='004.014';}
        else if (e.Equipment_Code_Description__c == 'RESTAURANT FURNITURE'){ e.Equipment_Code_FP__c ='004.016';}
        else if (e.Equipment_Code_Description__c == 'TELEPHONE SYSTEM'){ e.Equipment_Code_FP__c ='005.001';}
        else if (e.Equipment_Code_Description__c == 'COMMUNICATION EQUIPMENT'){ e.Equipment_Code_FP__c ='005.020';}
        else if (e.Equipment_Code_Description__c == 'INDUSTRIAL EQUIPMENT'){ e.Equipment_Code_FP__c ='009.001';}
        else if (e.Equipment_Code_Description__c == 'CONSTRUCTION YELLOW IRON'){ e.Equipment_Code_FP__c ='009.012';}
        else if (e.Equipment_Code_Description__c == 'CONCRETE FORMING EQUIP'){ e.Equipment_Code_FP__c ='009.016';}
        else if (e.Equipment_Code_Description__c == 'AIR COMPRESSOR'){ e.Equipment_Code_FP__c ='009.028';}
        else if (e.Equipment_Code_Description__c == 'LIGHTING - PORTABLE'){ e.Equipment_Code_FP__c ='009.029';}
        else if (e.Equipment_Code_Description__c == 'GENERATOR / EMISSION CONTROL'){ e.Equipment_Code_FP__c ='009.030';}
        else if (e.Equipment_Code_Description__c == 'STORAGE TANKS'){ e.Equipment_Code_FP__c ='009.031';}
        else if (e.Equipment_Code_Description__c == 'SCAFFOLDING'){ e.Equipment_Code_FP__c ='009.033';}
        else if (e.Equipment_Code_Description__c == 'LOGGING/SKIDDER NO TITLE'){ e.Equipment_Code_FP__c ='009.035';}
        else if (e.Equipment_Code_Description__c == 'SURVEY / ENGINEERING EQ'){ e.Equipment_Code_FP__c ='009.036';}
        else if (e.Equipment_Code_Description__c == 'CONSTRUCTION-Other Equipment'){ e.Equipment_Code_FP__c ='009.044';}
        else if (e.Equipment_Code_Description__c == 'COMPUTER HW/ROUTER/SERVER'){ e.Equipment_Code_FP__c ='010.001';}
        else if (e.Equipment_Code_Description__c == 'SOFTWARE ONLY'){ e.Equipment_Code_FP__c ='010.002';}
        else if (e.Equipment_Code_Description__c == 'PRINTER/PLOTTER/SCANNER'){ e.Equipment_Code_FP__c ='010.003';}
        else if (e.Equipment_Code_Description__c == 'COMPUTER LCD DISPLAY CA'){ e.Equipment_Code_FP__c ='010.006';}
        else if (e.Equipment_Code_Description__c == 'COMPUTER SYSTEM HW/SW PKG'){ e.Equipment_Code_FP__c ='010.015';}
        else if (e.Equipment_Code_Description__c == 'SIGN MAKING EQUIPMENT'){ e.Equipment_Code_FP__c ='010.016';}
        else if (e.Equipment_Code_Description__c == 'COMPUTER TESTING & REPAIR'){ e.Equipment_Code_FP__c ='010.017';}
        else if (e.Equipment_Code_Description__c == 'POINT OF SALE EQUIPMENT'){ e.Equipment_Code_FP__c ='011.002';}
        else if (e.Equipment_Code_Description__c == 'CARD VERIFICATION EQUIP'){ e.Equipment_Code_FP__c ='011.014';}
        else if (e.Equipment_Code_Description__c == 'CARNIVAL/AMUSEMENT RIDES'){ e.Equipment_Code_FP__c ='013.011';}
        else if (e.Equipment_Code_Description__c == 'ENTERTAINMENT EQUIPMENT'){ e.Equipment_Code_FP__c ='013.015';}
        else if (e.Equipment_Code_Description__c == 'PLAYGROUND EQUIPMENT'){ e.Equipment_Code_FP__c ='013.021';}
        else if (e.Equipment_Code_Description__c == 'SPORTS & REC - FIXED'){ e.Equipment_Code_FP__c ='013.028';}
        else if (e.Equipment_Code_Description__c == 'INFLATE AMUSEMENT EQUIP'){ e.Equipment_Code_FP__c ='013.032';}
        else if (e.Equipment_Code_Description__c == 'PRINT & DUPLICATE EQUIP'){ e.Equipment_Code_FP__c ='014.018';}
        else if (e.Equipment_Code_Description__c == 'AG-Harvest & Planting Equipment'){ e.Equipment_Code_FP__c ='015.014';}
        else if (e.Equipment_Code_Description__c == 'AG-Farm Tractor'){ e.Equipment_Code_FP__c ='015.021';}
        else if (e.Equipment_Code_Description__c == 'AG-Other Equipment'){ e.Equipment_Code_FP__c ='015.023';}
        else if (e.Equipment_Code_Description__c == 'AUTOMOTIVE TESTING EQUIP'){ e.Equipment_Code_FP__c ='016.002';}
        else if (e.Equipment_Code_Description__c == 'AUTOMOTIVE-Car Wash'){ e.Equipment_Code_FP__c ='016.015';}
        else if (e.Equipment_Code_Description__c == 'AUTOMOTIVE-Hoist/Lifts'){ e.Equipment_Code_FP__c ='016.022';}
        else if (e.Equipment_Code_Description__c == 'AUTOMOTIVE-Paint Booth'){ e.Equipment_Code_FP__c ='016.024';}
        else if (e.Equipment_Code_Description__c == 'PIPE BENDERS'){ e.Equipment_Code_FP__c ='016.027';}
        else if (e.Equipment_Code_Description__c == 'TRUCK MOUNTED LIFT/RACK'){ e.Equipment_Code_FP__c ='016.033';}
        else if (e.Equipment_Code_Description__c == 'TRUCK SCALE'){ e.Equipment_Code_FP__c ='016.034';}
        else if (e.Equipment_Code_Description__c == 'AUTOMOTIVE REPAIR EQUIP'){ e.Equipment_Code_FP__c ='016.038';}
        else if (e.Equipment_Code_Description__c == 'EXERCISE/FITNESS EQUIP'){ e.Equipment_Code_FP__c ='017.013';}
        else if (e.Equipment_Code_Description__c == 'GYMNASTICS EQUIPMENT'){ e.Equipment_Code_FP__c ='017.014';}
        else if (e.Equipment_Code_Description__c == 'SALON FIXTURES'){ e.Equipment_Code_FP__c ='017.016';}
        else if (e.Equipment_Code_Description__c == 'TANNING BED BULB'){ e.Equipment_Code_FP__c ='017.018';}
        else if (e.Equipment_Code_Description__c == 'OTHER HEALTH/BEAUTY EQUIP'){ e.Equipment_Code_FP__c ='017.019';}
        else if (e.Equipment_Code_Description__c == 'MICRODERMABRASION EQUIP'){ e.Equipment_Code_FP__c ='017.020';}
        else if (e.Equipment_Code_Description__c == 'TANNING BOOTH SPRAY-ON'){ e.Equipment_Code_FP__c ='017.021';}
        else if (e.Equipment_Code_Description__c == 'MOLDS/FORMS/DIES'){ e.Equipment_Code_FP__c ='018.016';}
        else if (e.Equipment_Code_Description__c == 'SEWING & EMBROIDERY EQUIP'){ e.Equipment_Code_FP__c ='018.018';}
        else if (e.Equipment_Code_Description__c == 'PACKAGE/SHRINK WRAP EQUIP'){ e.Equipment_Code_FP__c ='018.019';}
        else if (e.Equipment_Code_Description__c == 'SILK SCREENING EQUIPMENT'){ e.Equipment_Code_FP__c ='018.020';}
        else if (e.Equipment_Code_Description__c == 'MANUFACTURING EQUIPMENT'){ e.Equipment_Code_FP__c ='018.023';}
        else if (e.Equipment_Code_Description__c == 'FUEL DISPENSERS'){ e.Equipment_Code_FP__c ='019.012';}
        else if (e.Equipment_Code_Description__c == 'HEATING, VENTILATION & AC'){ e.Equipment_Code_FP__c ='019.021';}
        else if (e.Equipment_Code_Description__c == 'SIGNS & AWNINGS'){ e.Equipment_Code_FP__c ='019.027';}
        else if (e.Equipment_Code_Description__c == 'CONTAINERS & DRY STORAGE'){ e.Equipment_Code_FP__c ='019.029';}
        else if (e.Equipment_Code_Description__c == 'WATER SYS-NON IRRIGATION'){ e.Equipment_Code_FP__c ='019.032';}
        else if (e.Equipment_Code_Description__c == 'FURNISHINGS'){ e.Equipment_Code_FP__c ='019.034';}
        else if (e.Equipment_Code_Description__c == 'DRY CLEANING EQUIPMENT'){ e.Equipment_Code_FP__c ='020.015';}
        else if (e.Equipment_Code_Description__c == 'LAUNDRY EQUIPMENT'){ e.Equipment_Code_FP__c ='020.017';}
        else if (e.Equipment_Code_Description__c == 'ENGRAVER'){ e.Equipment_Code_FP__c ='021.014';}
        else if (e.Equipment_Code_Description__c == 'MACHINE TOOLS'){ e.Equipment_Code_FP__c ='021.023';}
        else if (e.Equipment_Code_Description__c == 'CARPET CLEANING MACHINE'){ e.Equipment_Code_FP__c ='022.013';}
        else if (e.Equipment_Code_Description__c == 'DUCT CLEANING MACHINE'){ e.Equipment_Code_FP__c ='022.015';}
        else if (e.Equipment_Code_Description__c == 'JANITORIAL EQUIPMENT'){ e.Equipment_Code_FP__c ='022.016';}
        else if (e.Equipment_Code_Description__c == 'LANDSCAPING & MOWERS'){ e.Equipment_Code_FP__c ='022.017';}
        else if (e.Equipment_Code_Description__c == 'PRESSURE WASHER'){ e.Equipment_Code_FP__c ='022.019';}
        else if (e.Equipment_Code_Description__c == 'SPRAY COATING MACHINE'){ e.Equipment_Code_FP__c ='022.020';}
        else if (e.Equipment_Code_Description__c == 'OTHER MAINTENANCE EQUIP'){ e.Equipment_Code_FP__c ='022.022';}
        else if (e.Equipment_Code_Description__c == 'CONVEYOR SYSTEM'){ e.Equipment_Code_FP__c ='023.012';}
        else if (e.Equipment_Code_Description__c == 'FORKLIFT'){ e.Equipment_Code_FP__c ='023.015';}
        else if (e.Equipment_Code_Description__c == 'PALLET DISMANTLER'){ e.Equipment_Code_FP__c ='023.016';}
        else if (e.Equipment_Code_Description__c == 'PLATFORM/MAN LIFT'){ e.Equipment_Code_FP__c ='023.019';}
        else if (e.Equipment_Code_Description__c == 'OTHER MATERIAL HANDLING'){ e.Equipment_Code_FP__c ='023.020';}
        else if (e.Equipment_Code_Description__c == 'MINING & DRILLING EQUIP'){ e.Equipment_Code_FP__c ='024.012';}
        else if (e.Equipment_Code_Description__c == 'SURVEILLANCE EQUIPMENT'){ e.Equipment_Code_FP__c ='025.014';}
        else if (e.Equipment_Code_Description__c == 'CAMERA & PHOTO PROCESSING'){ e.Equipment_Code_FP__c ='026.012';}
        else if (e.Equipment_Code_Description__c == 'TV/MOVIE/SOUND EQUIPMENT'){ e.Equipment_Code_FP__c ='026.022';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Dump/Chip/Grain'){ e.Equipment_Code_FP__c ='027.011';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Dry Van'){ e.Equipment_Code_FP__c ='027.012';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Low Boy'){ e.Equipment_Code_FP__c ='027.013';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Flat Bed'){ e.Equipment_Code_FP__c ='027.014';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Log'){ e.Equipment_Code_FP__c ='027.015';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Office/Titled'){ e.Equipment_Code_FP__c ='027.016';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Pup/Transfer'){ e.Equipment_Code_FP__c ='027.017';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Car Hauling'){ e.Equipment_Code_FP__c ='027.018';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Refrigerated'){ e.Equipment_Code_FP__c ='027.019';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Travel'){ e.Equipment_Code_FP__c ='027.020';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Tank'){ e.Equipment_Code_FP__c ='027.021';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Utility'){ e.Equipment_Code_FP__c ='027.022';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Other'){ e.Equipment_Code_FP__c ='027.023';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Goose Neck'){ e.Equipment_Code_FP__c ='027.024';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Drop Neck'){ e.Equipment_Code_FP__c ='027.025';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Concession'){ e.Equipment_Code_FP__c ='027.027';}
        else if (e.Equipment_Code_Description__c == 'TRAILER-Chipper'){ e.Equipment_Code_FP__c ='027.028';}
        else if (e.Equipment_Code_Description__c == 'VENDING EQUIPMENT'){ e.Equipment_Code_FP__c ='028.014';}
        else if (e.Equipment_Code_Description__c == 'VIDEO GAMES'){ e.Equipment_Code_FP__c ='028.015';}
        else if (e.Equipment_Code_Description__c == 'WASTE/RECYCLE CONTAINERS'){ e.Equipment_Code_FP__c ='029.012';}
        else if (e.Equipment_Code_Description__c == 'TOILETS (PORTABLE)'){ e.Equipment_Code_FP__c ='029.016';}
        else if (e.Equipment_Code_Description__c == 'WASTE OIL FURNACE'){ e.Equipment_Code_FP__c ='029.019';}
        else if (e.Equipment_Code_Description__c == 'OTHER WASTE/RECYCLE EQUIP'){ e.Equipment_Code_FP__c ='029.020';}
        else if (e.Equipment_Code_Description__c == 'WOODWORKING EQUIPMENT'){ e.Equipment_Code_FP__c ='030.022';}



    }
}