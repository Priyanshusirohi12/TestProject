public with sharing class TC_CheckRecursiveRelationshipPriority {

  private static boolean run = true;

  public static boolean runOnce () {
    if (run) {
      run = false;
      return true;
    } else {
      return run;
    }
    
  }
}