public with sharing class NewConfigurationCleanupService {
	
    public List<ApexPage> visualforcePageList {get; set;}
    public List<ApexClass> apexClassList {get; set;}
    public Map<string, List<List<string>>> apexTriggerDetailMap = new Map<string, List<List<string>>>();
    public Map<string, List<List<string>>> workflowDetailMap = new Map<string, List<List<string>>>();
    public Map<string, List<List<String>>> validationRuleDetailMap = new Map<string, List<List<string>>>();
    
    public String triggersJson{get; set;}
    public String apexPageJson{get; set;}
    public String workflowJson{get; set;}
    
    public string dependentClassesJson{get; set;}
    public string dependentPagesJson{get; set;}
    public string dependentTriggersJson{get; set;}
    
    public String validationRuleJson{get; set;}
    public String apexClassJson{get; set;}
    
    public String ConfigurationList{get; set;}
    public String ConfigName {get; set;}
    public String CurrentConfig {get; set;}
    public List<String> triggerParentList {get;set;}
    public Boolean IsTrigger {get; set;}
    public Boolean IsApexPage {get; set;}
    public Boolean IsWorkflowRule {get; set;}
    public Boolean IsValidationRule {get; set;}
    public Boolean IsApexClass {get; set;}
    
    public List<String> lstDependentClasses {get; set;}
    public List<String> lstDependentPages {get; set;}
    public List<String> lstDependentTriggers {get; set;}
    public List<ApexClass> lstclasses {get; set;}
    public List<String> selectedClasses;
    		 
    public PageReference Dashboard(){
        return Page.OrgCleanerDashboard;
    }
    
    public NewConfigurationCleanupService(){
    	System.debug('Inside comstructor');
		//List<ApexClass> lstAllAPexClasses=new List<ApexClass>();
        //lstAllAPexClasses=Configurationcleanupselector.getApexCsasses();
        //getApexClass();
        //apexClassJson = ConfigurationCleanUpServiceHandler.generateJsonForApexPage(lstAllAPexClasses);    
        system.debug('**************************apexClassJson - ' + apexClassJson);    
    }
    
    public void GetConfigDetails(){
    	System.debug('IN - ' + CurrentConfig);
    	if(CurrentConfig == 'Trigger'){
    		IsTrigger = true;
    		getTriggersDetails();
    		triggersJson = NewConfigurationCleanUpServiceHandler.generateJsonForTrigger(apexTriggerDetailMap);
    	}
    	else if(CurrentConfig == 'ApexPage'){
    		IsApexPage = true;
    		getVisualforcePages();
    		apexPageJson = NewConfigurationCleanUpServiceHandler.generateJsonForApexPage(visualforcePageList);
    	}
    	else if(CurrentConfig == 'WorkflowRule'){
    		IsWorkflowRule = true;
    		getWorkflows();
    		workflowJson = NewConfigurationCleanUpServiceHandler.generateJsonForTrigger(workflowDetailMap);
    	}
    	else if(CurrentConfig == 'ValidationRule'){
    		IsValidationRule = true;
    		getValidationRules();
  			validationRuleJson = NewConfigurationCleanUpServiceHandler.generateJsonForTrigger(validationRuleDetailMap);
    	}
    	else if(CurrentConfig == 'ApexClass'){
    		System.debug('In ApexClass if loop');
    		IsApexClass = true;
        	//apexClassList=new List<ApexClass>();
        	//apexClassList = ConfigurationSelector.getAllApexClasses();
        	getApexClass();
        	System.debug('apexClassList='+apexClassList);
        	System.debug('apexClassJson=');
        	apexClassJson = NewConfigurationCleanUpServiceHandler.generateJsonForApexClass(apexClassList);
        	System.debug('apexClassJson========================================================================================='+apexClassJson);
    	}
    }
    
    public void GetConfigurationDetails(){
    	System.debug('Latest Call - ' + ConfigName);
    	triggersJson = null;
    }
    public void getTriggersDetails(){
    	apexTriggerDetailMap = TriggerService.getTriggers();
    	triggerParentList = new List<String>();
        triggerParentList.addAll(apexTriggerDetailMap.keySet());
    }
    public void getWorkflows(){
    	workflowDetailMap = WorkflowService.getWorkflows();
    }
    public void getApexClass(){
    	apexClassList=new List<ApexClass>();
        apexClassList = ConfigurationSelector.getAllApexClasses();
    }
    
    public void getVisualforcePages(){      
        visualforcePageList = ConfigurationSelector.getVisualforcePages();
    }
    
    //public void 
    
    public void getValidationRules(){
    	validationRuleDetailMap = ValidationRuleService.getValidationRules();
    	System.debug('validationRuleList - '  + validationRuleDetailMap	);
    }
    
    public void CleanConfigurations(){
    	System.debug('ConfigName  123 - '+ConfigName);
    	if(ConfigName == 'Trigger'){
    		List<String> triggersToDelete = new List<String>();
    		for(String details:ConfigurationList.split(',')){
    			triggersToDelete.add(details.split('\\$')[1]);
    		}
        	TriggerService.deleteTrigger(triggersToDelete);
    	}
    	else if(ConfigName == 'ApexPage'){
    		List<String> ApexPageToDelete = new List<String>();
    		for(String details:ConfigurationList.split(',')){
    			ApexPageToDelete.add(details.split('\\$')[0]);
    		}
        	ApexPageService.deleteApexPages(ApexPageToDelete);
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
    	}
    	else if(ConfigName == 'ApexClass'){
    		List<String> ApexClassToDelete = new List<String>();
    		for(String details:ConfigurationList.split(',')){
    			ApexClassToDelete.add(details.split('\\$')[1]);
    		}
    		system.debug('ApexClassToDelete - ' + ApexClassToDelete);
    		
    		lstDependentClasses=ConfigurationCleanUpServiceHandler.SearchInClass(ApexClassToDelete);
    		lstDependentPages=ConfigurationCleanUpServiceHandler.SearchInPage(ApexClassToDelete);
 		   	lstDependentTriggers=ConfigurationCleanUpServiceHandler.SearchInTrigger(ApexClassToDelete);
	    	
	    	System.debug('lstDependentClasses='+lstDependentClasses);
    		System.debug('lstDependentPages='+lstDependentPages);
    		System.debug('lstDependentTriggers='+lstDependentTriggers);
    	}
    }
    
    public void deleteclasses()
    {
    	NewConfigurationCleanUpServiceHandler.deleteclasses(selectedClasses,lstDependentClasses,lstDependentTriggers,lstDependentPages);
    }
    
    public void dependents(){
    	System.debug('*******dependents*******');
   		selectedClasses=new List<String>();
   		for(String s:ConfigurationList.split(','))
   		{
   			selectedClasses.add(s);
   		}
   		lstDependentPages=new List<String>();
   		lstDependentClasses = new List<String>();
   		lstDependentTriggers =  new List<String>();
   		lstDependentPages=NewConfigurationCleanUpServiceHandler.SearchInPage(selectedClasses);
   		lstDependentClasses=NewConfigurationCleanUpServiceHandler.SearchInClass(selectedClasses);
   		lstDependentTriggers=NewConfigurationCleanUpServiceHandler.SearchInTrigger(selectedClasses);
   		
   		dependentClassesJson=NewConfigurationCleanUpServiceHandler.generateJson(lstDependentClasses);
   		dependentPagesJson=NewConfigurationCleanUpServiceHandler.generateJson(lstDependentPages);
   		dependentTriggersJson=NewConfigurationCleanUpServiceHandler.generateJson(lstDependentTriggers);
   		List<List<String>> someList = new List<List<String>>();
   	}
    
}