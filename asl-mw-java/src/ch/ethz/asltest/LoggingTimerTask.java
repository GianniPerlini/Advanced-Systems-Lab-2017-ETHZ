package ch.ethz.asltest;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.Collections;
import java.util.TimerTask;
import java.util.concurrent.LinkedBlockingQueue;

/**
 *
 * Class in charge of storing statistics from Worker to Middleware
 *
 */
public class LoggingTimerTask extends TimerTask {

	private int runCount = 0;
	
	@Override
	public void run() {		
		runCount++;
		try {
			
			copyStats();

			// If no operations done in the last second, cancel the task
			if(Worker.setsPerSecond.get() != 0 || Worker.getsPerSecond.get() != 0 || Worker.mgPerSecond.get() != 0 || NetworkThread.arrivalRate.get() != 0) {
				
				if(Worker.setsPerSecond.get() != 0)
					MyMiddleware.setThroughputs.add(String.valueOf(Worker.setsPerSecond.get()));
				
				if(Worker.getsPerSecond.get() != 0)
					MyMiddleware.getThroughputs.add(String.valueOf(Worker.getsPerSecond.get()));
				
				if(Worker.mgPerSecond.get() != 0)
					MyMiddleware.mgTh.add(String.valueOf(Worker.mgPerSecond.get()));
				
				if(NetworkThread.arrivalRate.get() != 0) 
					MyMiddleware.arrivalRates.add(String.valueOf(NetworkThread.arrivalRate));
				
				writeTHInFile();
				
				double totKeys = Worker.missKeyCount.get();
				
				if(totKeys != 0) {
					double miss = Worker.missCount.get();
					MyMiddleware.missRate.add(String.valueOf(miss / totKeys * 100));
				}
				
				clearWorkerStats();

			} else {
				this.cancel();
			}
		} catch(Exception e) {
			e.printStackTrace();
		}

	}

	/**
	 *
	 * Copy from Workers to MW
	 * 
	 */
	private void copyStats() {

		if (Worker.tIQCountS.get() != 0) {
			MyMiddleware.timesInQueueS.add(String.valueOf(Worker.tIQSumS.get() / Worker.tIQCountS.get()));
		}
		
		if (Worker.tIQCountG.get() != 0) {
			MyMiddleware.timesInQueueG.add(String.valueOf(Worker.tIQSumG.get() / Worker.tIQCountG.get()));
		}


		if(Worker.tPCountGet.get() != 0 && Worker.tPCountSet.get() != 0) {

			MyMiddleware.timesInProcessingGet.add(String.valueOf(Worker.tPSumGet.get() / Worker.tPCountGet.get()));
			MyMiddleware.timesInProcessingSet.add(String.valueOf(Worker.tPSumSet.get() / Worker.tPCountSet.get()));

		} else if(Worker.tPCountSet.get() != 0) {
			MyMiddleware.timesInProcessingSet.add(String.valueOf(Worker.tPSumSet.get() / Worker.tPCountSet.get()));

		} else if(Worker.tPCountGet.get() != 0){
			MyMiddleware.timesInProcessingGet.add(String.valueOf(Worker.tPSumGet.get() / Worker.tPCountGet.get()));

		}


		if (Worker.tParseCountSet.get() != 0 && Worker.tParseCountGet.get() != 0) {

			MyMiddleware.timesToParseGet.add(String.valueOf(Worker.tParseSumGet.get() / Worker.tParseCountGet.get()));
			MyMiddleware.timesToParseSet.add(String.valueOf(Worker.tParseSumSet.get() / Worker.tParseCountSet.get()));

		} else if(Worker.tParseCountGet.get() != 0) {

			MyMiddleware.timesToParseGet.add(String.valueOf(Worker.tParseSumGet.get() / Worker.tParseCountGet.get()));

		} else if(Worker.tParseCountSet.get() != 0) {

			MyMiddleware.timesToParseSet.add(String.valueOf(Worker.tParseSumSet.get() / Worker.tParseCountSet.get()));
		}

		if (Worker.tSendCountSet.get() != 0 && Worker.tSendCountGet.get() != 0) {

			MyMiddleware.timesToSendGet.add(String.valueOf(Worker.tSendSumGet.get() / Worker.tSendCountGet.get()));
			MyMiddleware.timesToSendSet.add(String.valueOf(Worker.tSendSumSet.get() / Worker.tSendCountSet.get()));

		} else if(Worker.tSendCountGet.get() != 0) {

			MyMiddleware.timesToSendGet.add(String.valueOf(Worker.tSendSumGet.get() / Worker.tSendCountGet.get()));

		} else if(Worker.tSendCountSet.get() != 0) {

			MyMiddleware.timesToSendSet.add(String.valueOf(Worker.tSendSumSet.get() / Worker.tSendCountSet.get()));
		}

		if (Worker.tSendRespCountSet.get() != 0 && Worker.tSendRespCountGet.get() != 0) {

			MyMiddleware.tSendRespGet.add(String.valueOf(Worker.tSendRespSumGet.get() / Worker.tSendRespCountGet.get()));
			MyMiddleware.tSendRespSet.add(String.valueOf(Worker.tSendRespSumSet.get() / Worker.tSendRespCountSet.get()));

		} else if(Worker.tSendRespCountGet.get() != 0) {

			MyMiddleware.tSendRespGet.add(String.valueOf(Worker.tSendRespSumGet.get() / Worker.tSendRespCountGet.get()));

		} else if(Worker.tSendRespCountSet.get() != 0) {

			MyMiddleware.tSendRespSet.add(String.valueOf(Worker.tSendRespSumSet.get() / Worker.tSendRespCountSet.get()));
		}

		if (Worker.rtCountSet.get() != 0 && Worker.rtCountGet.get() != 0) {

			MyMiddleware.rtGet.add(String.valueOf(Worker.rtSumGet.get() / Worker.rtCountGet.get()));
			MyMiddleware.rtSet.add(String.valueOf(Worker.rtSumSet.get() / Worker.rtCountSet.get()));

		} else if(Worker.rtCountGet.get() != 0) {

			MyMiddleware.rtGet.add(String.valueOf(Worker.rtSumGet.get() / Worker.rtCountGet.get()));

		} else if(Worker.rtCountSet.get() != 0) {

			MyMiddleware.rtSet.add(String.valueOf(Worker.rtSumSet.get() / Worker.rtCountSet.get()));
		}
		
		if (Worker.keyCountC.get() != 0) {
			MyMiddleware.keyCounts.add(String.valueOf(Worker.keyCountSum.get() / Worker.keyCountC.get()));
		}
		
		
		if(Worker.tParseMGCount.get() != 0) {
			MyMiddleware.tParseMG.add(String.valueOf(Worker.tParseMGSum.get() / Worker.tParseMGCount.get()));
		}
		
		if(Worker.tSendMGCount.get() != 0) {
			MyMiddleware.tSendMG.add(String.valueOf(Worker.tSendMGSum.get() / Worker.tSendMGCount.get()));
		}
		
		if(Worker.tPMGCount.get() != 0) {
			MyMiddleware.tPMG.add(String.valueOf(Worker.tPMGSum.get() / Worker.tPMGCount.get()));
		}
		
		if(Worker.tSRMGCount.get() != 0) {
			MyMiddleware.tSRBMG.add(String.valueOf(Worker.tSRMGSum.get() / Worker.tSRMGCount.get()));
		}
		
		if(Worker.rtMGCount.get() != 0) {
			MyMiddleware.rtMG.add(String.valueOf(Worker.rtMGSum.get() / Worker.rtMGCount.get()));
		}

	}

	
	/**
	 *
	 * Clear all statistics related values/arrays
	 * 
	 */
	private void clearWorkerStats() {

		Worker.tIQSumS.set(0);
		Worker.tIQCountS.set(0);

		Worker.tIQSumG.set(0);
		Worker.tIQCountG.set(0);

		Worker.tParseSumGet.set(0);
		Worker.tParseCountGet.set(0);
		Worker.tParseSumSet.set(0);
		Worker.tParseCountSet.set(0);
		Worker.tParseMGSum.set(0);
		Worker.tParseMGCount.set(0);
		
		Worker.tSendSumGet.set(0);
		Worker.tSendCountGet.set(0);
		Worker.tSendSumSet.set(0);
		Worker.tSendCountSet.set(0);
		Worker.tSendMGSum.set(0);
		Worker.tSendMGCount.set(0);

		Worker.tPSumGet.set(0);
		Worker.tPCountGet.set(0);
		Worker.tPSumSet.set(0);
		Worker.tPCountSet.set(0);
		Worker.tPMGSum.set(0);
		Worker.tPMGCount.set(0);

		Worker.tSendRespSumGet.set(0);
		Worker.tSendRespCountGet.set(0);
		Worker.tSendRespSumSet.set(0);
		Worker.tSendRespCountSet.set(0);
		Worker.tSRMGSum.set(0);
		Worker.tSRMGCount.set(0);

		Worker.rtSumGet.set(0);
		Worker.rtCountGet.set(0);
		Worker.rtSumSet.set(0);
		Worker.rtCountSet.set(0);
		Worker.rtMGSum.set(0);
		Worker.rtMGCount.set(0);

		Worker.setsPerSecond.set(0);
		Worker.getsPerSecond.set(0);
		Worker.mgPerSecond.set(0);
		Worker.missCount.set(0);
		Worker.missKeyCount.set(0);
		
		NetworkThread.arrivalRate.set(0);
		
		MyMiddleware.getTHPerWT.clear();
		MyMiddleware.setTHPerWT.clear();

		MyMiddleware.getSTPerWT.clear();
		MyMiddleware.setSTPerWT.clear();

	}


	/**
	 *
	 * Write per Worker Thread throughput and service time into appropriate files
	 * 
	 */
	private void writeTHInFile() {

		ArrayList<Long> getTh = new ArrayList<>(MyMiddleware.getTHPerWT.values());
		ArrayList<Long> setTh = new ArrayList<>(MyMiddleware.setTHPerWT.values());

		ArrayList<Long> getSt = new ArrayList<>(MyMiddleware.getSTPerWT.values());
		ArrayList<Long> setSt = new ArrayList<>(MyMiddleware.setSTPerWT.values());
		
		try {
		if (!getTh.isEmpty()) {
			ArrayList<String> getThS = new ArrayList<String>(getTh.size());
			
			getThS.add("SEC " + runCount);
			
			for (int i = 0; i < getTh.size(); i++) {
				getThS.add(i + ": " + getTh.get(i));
			}
			
			getThS.add("\n");

			Files.write(Paths.get("Get_Th_Per_WT.txt"), getThS , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);
			
		}
		
		if (!setTh.isEmpty()) {
			ArrayList<String> setThS = new ArrayList<String>(setTh.size());
			
			setThS.add("SEC " + runCount);
			
			for (int i = 0; i < setTh.size(); i++) {
				setThS.add(i + ": " + setTh.get(i));
			}
			
			setThS.add("\n");

			Files.write(Paths.get("Set_Th_Per_WT.txt"), setThS , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);
		}
		
		if(!getSt.isEmpty()) {
			ArrayList<String> getSts = new ArrayList<>(getSt.size());
			
			getSts.add("SEC " + runCount);
			
			for (int i = 0; i < getSt.size(); i++) {
				getSts.add(i + ": " + getSt.get(i));
			}
			
			getSts.add("\n");
			

			Files.write(Paths.get("GSTWT.txt"), getSts , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);
		}
		
		if(!setSt.isEmpty()) {
			ArrayList<String> setSts = new ArrayList<>(setSt.size());
			
			setSts.add("SEC " + runCount);
			
			for (int i = 0; i < setSt.size(); i++) {
				setSts.add(i + ": " + setSt.get(i));
			}
			
			setSts.add("\n");
			

			Files.write(Paths.get("SSTWT.txt"), setSts , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);
		}

		} catch(IOException e) {
			e.printStackTrace();
		}
	}

}
