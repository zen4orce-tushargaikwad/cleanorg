public with sharing class ConfigurationCleanUpService {
    
    public List<List<String>> lstlstvf {get;set;}
    public Map<string, List<String>> apexTriggerList {get; set;}
    Public List<ApexTrigger> triggerList=new List<ApexTrigger>();
    public List<ApexPage> visualforcePageList {get; set;}
    public Map<string, List<String>> workflowList {get; set;}
    public Map<string, List<String>> validationRuleList {get; set;}
    
    public Map<String, List<String>> typeWiseMap;
    public List<String> selectedApexTriggerList {get; set;}
    public List<String> selectedVisualforcePageList {get; set;}
    public List<String> selectedWorkflowList {get; set;}
    public List<String> selectedValidationRuleList {get; set;}
    
    public ConfigurationCleanUpService(){
    	/*visualforcePageList = VisualforcePageSelector.getVisualforcePages();
        lstlstvf=new List<List<String>>();
        List<String> lstvf;
        for(ApexPage a:visualforcePageList)
        {
            lstvf=new List<String>();
            lstvf.add('"'+a.Name+'"');
            lstlstvf.add(lstvf);
        }*/
    }
    //Get list of triggers
    public void getTriggers(){
     	triggerList = Configurationcleanupselector.selectTriggers();
    }
    //Get list of visiualforcepages
    public void getVisualforcePages(){      
        visualforcePageList = Configurationcleanupselector.selectVisualforcePages();
       
        system.debug(lstlstvf);
    }
   
    /*public void getWorkflows(){
    	workflowList = ConfigurationCleanUpServiceHandler.getWorkflows();
    	System.debug('workflowList - '  + workflowList);
    }*/
    public void deleteclasses(List<String> lstClassesToDelete)
    {
    	
    }
}