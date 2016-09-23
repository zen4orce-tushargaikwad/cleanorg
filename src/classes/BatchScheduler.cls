global class BatchScheduler implements Schedulable {
  global Database.Batchable<ApexClass> batchClass{get;set;}
  global Integer batchSize{get;set;} {batchSize = 10;}
  global static Integer callstatus=0;
  global static boolean schedulestatus{get;set;}

  global void execute(SchedulableContext sc) {
  	
  		System.debug('Inside Scheduler after 1 min');
		List<AsyncApexJob> lstAsyncApexJobNew=new List<AsyncApexJob>();
		List<String> lstJobNames=new List<String>();
		lstJobNames.add('CommentDependentPagesBatch');
		lstJobNames.add('CommentDependentClassBatch');
		lstJobNames.add('CommentDependentTriggersBatch');
		lstAsyncApexJobNew=Configurationcleanupselector.getAsyncApexJobStatus(lstJobNames);
		System.debug('lstAsyncApexJobNew size='+lstAsyncApexJobNew);
		if(lstAsyncApexJobNew[0].status=='Completed' && lstAsyncApexJobNew[1].status=='Completed' && lstAsyncApexJobNew[2].status=='Completed')
		{
			System.debug('Batch callled count=');
			database.executebatch(batchClass, batchSize);
			//System.abortJob(sc.getTriggerId());
			schedulestatus=true;
		}
		else{
			NewConfigurationCleanUpServiceHandler.ScheduleDeletionBatch();
			schedulestatus=false;
		}
  }
}