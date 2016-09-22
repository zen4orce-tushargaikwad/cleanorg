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
    public string dependentClassesJson{get; set;}
    public string dependentPagesJson{get; set;}
    public string dependentTriggersJson{get; set;}
    
    public List<String> lstDependentPages{get;set;}
   	public List<String> lstDependentClasses{get;set;}
   	public List<String> lstDependentTriggers{get;set;}
    
    
    public List<List<String>> lstlstPages{get;set;}
    public List<List<String>> lstlstClasses{get;set;}
    public List<List<String>> lstlstTriggers{get;set;}
    
    public List<String> selectedClasses;
    public String ConfigurationList{get;set;}
    public string ConfigName{get;set;}
    
    public ConfigurationCleanUpService(){
    	lstlstPages = new List<List<String>>();
    	lstlstClasses=new List<List<String>>();
    	lstlstTriggers=new List<List<String>>();
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
        System.debug('apexClassJson='+apexClassJson);
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
   
   	public void dependents(){
   		//ConfigurationList=new List<String>();
   		//System.debug('ConfigurationList'+ConfigurationList);
   		selectedClasses=new List<String>();
   		for(String s:ConfigurationList.split(','))
   		{
   			selectedClasses.add(s);
   		}
   		//System.debug('selectedClasses='+selectedClasses);
   		lstDependentPages=new List<String>();
   		lstDependentClasses = new List<String>();
   		lstDependentTriggers =  new List<String>();
   		lstDependentPages=ConfigurationCleanUpServiceHandler.SearchInPage(selectedClasses);
   		lstDependentClasses=ConfigurationCleanUpServiceHandler.SearchInClass(selectedClasses);
   		lstDependentTriggers=ConfigurationCleanUpServiceHandler.SearchInTrigger(selectedClasses);
   		
   		dependentClassesJson=ConfigurationCleanUpServiceHandler.generateJson(lstDependentClasses);
   		dependentPagesJson=ConfigurationCleanUpServiceHandler.generateJson(lstDependentPages);
   		dependentTriggersJson=ConfigurationCleanUpServiceHandler.generateJson(lstDependentTriggers);
   		//System.debug('dependentClassesJson='+dependentClassesJson);
   		//System.debug('dependentPagesJson='+dependentPagesJson);
   		//System.debug('dependentTriggersJson'+dependentTriggersJson);
   		
   		//System.debug('lstDependentPages='+lstDependentPages);
   		//System.debug('lstDependentClasses='+lstDependentClasses);
   		//System.debug('lstDependentTriggers='+lstDependentTriggers);
   		List<List<String>> someList = new List<List<String>>();
   		lstlstPages=new List<List<String>>();
   		lstlstClasses=new List<List<String>>();
   		lstlstTriggers=new List<List<String>>();
        List<String> someOtherList;// = new List<String>();
        lstlstPages = new List<List<String>>();
   	}
   
    /*public void getWorkflows(){
    	workflowList = ConfigurationCleanUpServiceHandler.getWorkflows();
    	System.debug('workflowList - '  + workflowList);
    }*/
    public void deleteclasses()
    {
    	ConfigurationCleanUpServiceHandler.deleteclasses(selectedClasses,lstDependentClasses,lstDependentTriggers,lstDependentPages);
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