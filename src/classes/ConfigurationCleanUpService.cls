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
    
    public String apexClassJson{get; set;}
    
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
        List<ApexClass> lstAllAPexClasses=new List<ApexClass>();
        lstAllAPexClasses=Configurationcleanupselector.getApexCsasses();
        apexClassJson = ConfigurationCleanUpServiceHandler.generateJsonForApexPage(lstAllAPexClasses);
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
    public void CleanConfigurations(){
    	/*System.debug('ConfigName - '+ConfigName);
    	if(ConfigName == 'Trigger'){
    		List<String> triggersToDelete = new List<String>();
    		for(String details:ConfigurationList.split(',')){
    			triggersToDelete.add(details.split('\\$')[2]);
    		}
        	TriggerService.deleteTrigger(triggersToDelete);
    	}
    	else if(ConfigName == 'ApexPage'){
    		List<String> ApexPageToDelete = new List<String>();
    		for(String details:ConfigurationList.split(',')){
    			ApexPageToDelete.add(details.split('\\$')[0]);
    		}
        	//ApexPageService.deleteApexPages(ApexPageToDelete);
    	}
    	else if(ConfigName == 'WorkflowRules'){
    		List<String> WorkflowRuleToDelete = new List<String>();
    		for(String details:ConfigurationList.split(',')){
    			WorkflowRuleToDelete.add(details.split('\\$')[0]+'.'+details.split('\\$')[2]);
    		}
            System.debug('WorkflowRuleToDelete - ' + WorkflowRuleToDelete);
    		WorkflowService.deleteWorkflows(WorkflowRuleToDelete);
    	}
        else if(ConfigName == 'ValidationRules'){
    		List<String> ValidationRuleToDelete = new List<String>();
    		for(String details:ConfigurationList.split(',')){
    			ValidationRuleToDelete.add(details.split('\\$')[0]+'.'+details.split('\\$')[2]);
    		}
            ValidationRuleService.deleteValidationRules(ValidationRuleToDelete);
            System.debug('ValidationRuleToDelete - ' + ValidationRuleToDelete);
        	//ApexPageService.deleteApexPages(ValidationRuleToDelete);
    	}*/
    }
}