package ch.ethz.asltest;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;


/**
 * 
 * This class starts and shuts down the middleware
 *
 */
public class MyMiddleware implements Runnable {

	// Arguments from RunMW
	private String myIp;
	private int myPort;
	private List<String> mcAddresses;
	private int numThreadsPTP;
	private boolean readSharded;
	private boolean keySix;

	// The queue
	private LinkedBlockingQueue<RequestWrapper> requestsQueue;
	private int serverTotal;
	
	// Used to implement round robin of servers
	private AtomicInteger serverIndex;
	
	private NetworkThread networkThread;
	private ExecutorService executor;
	private String[] iPs;
	private Integer[] ports;

	
/* ------------------ Statistic Related Arguments ------------------ */
	public static ArrayList<String> timesInProcessingGet = new ArrayList<>();
	public static ArrayList<String> timesToParseGet = new ArrayList<>();
	
	public static ArrayList<String> timesInProcessingSet = new ArrayList<>();
	public static ArrayList<String> timesToParseSet = new ArrayList<>();
	
	public static ArrayList<String> tPMG = new ArrayList<>();
	public static ArrayList<String> tParseMG = new ArrayList<>();
	
	public static ArrayList<String> timesToSendGet = new ArrayList<>();
	public static ArrayList<String> timesToSendSet = new ArrayList<>();
	public static ArrayList<String> tSendMG = new ArrayList<>();
	
	public static ArrayList<String> tSendRespGet = new ArrayList<>();
	public static ArrayList<String> tSendRespSet = new ArrayList<>();
	public static ArrayList<String> tSRBMG = new ArrayList<>();
	
	public static ArrayList<String> rtGet = new ArrayList<>();
	public static ArrayList<String> rtSet = new ArrayList<>();
	public static ArrayList<String> rtMG = new ArrayList<>();

	public static ArrayList<String> requestsQueueSizes = new ArrayList<>();
	public static ArrayList<String> timesInQueueS = new ArrayList<>();
	public static ArrayList<String> timesInQueueG = new ArrayList<>();
	public static ArrayList<String> throughputs = new ArrayList<>();
	public static ArrayList<String> setThroughputs = new ArrayList<>();
	public static ArrayList<String> getThroughputs = new ArrayList<>();
	public static ArrayList<String> mgTh = new ArrayList<>();
	public static ArrayList<String> missRate = new ArrayList<>();
	public static ArrayList<String> keyCounts = new ArrayList<>();
	public static ArrayList<String> arrivalRates = new ArrayList<>();


	// Used for the M/M/m model and Network of Queues
	public static ConcurrentHashMap<Long, Long> getTHPerWT = new ConcurrentHashMap<>();
	public static ConcurrentHashMap<Long, Long> setTHPerWT = new ConcurrentHashMap<>();
	
	public static ConcurrentHashMap<Long, Long> setSTPerWT = new ConcurrentHashMap<>();
	public static ConcurrentHashMap<Long, Long> getSTPerWT = new ConcurrentHashMap<>();

/* ----------------------------------------------------------------- */

	
	/* ------------------ CONSTRUCTORS ------------------ */
	
	
	public MyMiddleware(String myIp, int myPort, List<String> mcAddresses,
			int numThreadsPTP, boolean readSharded) {
		this.myIp = myIp;
		this.myPort = myPort;
		this.mcAddresses = mcAddresses;
		this.numThreadsPTP = numThreadsPTP;
		this.readSharded = readSharded;
		this.requestsQueue = new LinkedBlockingQueue<>();
		this.serverTotal = mcAddresses.size();
		this.serverIndex = new AtomicInteger();
		this.iPs = new String[serverTotal];
		this.ports = new Integer[serverTotal];
		this.keySix = false;
	}

	// Only used in Section 5
	public MyMiddleware(String myIp, int myPort, List<String> mcAddresses,
			int numThreadsPTP, boolean readSharded, boolean keySix) {
		this.myIp = myIp;
		this.myPort = myPort;
		this.mcAddresses = mcAddresses;
		this.numThreadsPTP = numThreadsPTP;
		this.readSharded = readSharded;
		this.requestsQueue = new LinkedBlockingQueue<>();
		this.serverTotal = mcAddresses.size();
		this.serverIndex = new AtomicInteger();
		this.iPs = new String[serverTotal];
		this.ports = new Integer[serverTotal];
		this.keySix = keySix;
	}

	/* -------------------------------------------------- */

	@Override
	public void run() {
		// Initialize ports and IPs from list of addresses
		getIPsandPortsFromList(mcAddresses);

		// Only used to get the server index, could have made it static
		MyMiddleware middleware = new MyMiddleware(myIp, myPort, mcAddresses, numThreadsPTP, readSharded, keySix);		

		/* Starts the Thread Pool */
		executor = Executors.newFixedThreadPool(numThreadsPTP);

		for (int i = 0; i < numThreadsPTP; i++) {
			executor.submit(new Worker(requestsQueue, serverTotal, middleware, iPs, ports, readSharded));

		}

		/* Starts the Network Thread */
		networkThread = new NetworkThread(myIp, myPort, requestsQueue);
		networkThread.start();


		/* When Shutting Down */
		Runtime.getRuntime().addShutdownHook(new Thread() {

			@Override
			public void run() {
				try {
					networkThread.interrupt();
					networkThread.join();

					// To tell worker threads to terminate
					for (int i = 0; i < numThreadsPTP; i++) {
						requestsQueue.put(new RequestWrapper("exit", null));
					}

					executor.shutdown();
					executor.awaitTermination(1000, TimeUnit.MILLISECONDS);

					if (keyCounts.size() != 0) {
						double avgKc = 0.0;

						for (int i = 0; i < keyCounts.size(); i++) {
							avgKc += Double.valueOf(keyCounts.get(i));
						}

						avgKc /= keyCounts.size();


						keyCounts.add("AVG: " + String.valueOf(avgKc));
					}
					
					double avgQL = 0.0;
					
					for (String s : requestsQueueSizes) {
						avgQL += Double.valueOf(s);
					}
					
					avgQL /= requestsQueueSizes.size();
					
					// Only write average, since queue length taken every 100 ms
					requestsQueueSizes.clear();
					requestsQueueSizes.add(String.valueOf(avgQL));

					System.out.println("AFTER SHUTDOWN");
				} catch (InterruptedException e) {
					e.printStackTrace();
				} finally {
					try {
						writeStatsToFiles();
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
		});

	}

	private void writeStatsToFiles() throws IOException {
		if(missRate.size() > 1)
			Files.write(Paths.get("Cache_Misses.txt"), missRate , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);
		if(timesToParseGet.size() > 1) 
			Files.write(Paths.get("Times_To_Parse_Get.txt"), timesToParseGet , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(timesToParseSet.size() > 1)
			Files.write(Paths.get("Times_To_Parse_Set.txt"), timesToParseSet , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(tParseMG.size() > 1)
			Files.write(Paths.get("TParseMG.txt"), tParseMG , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(timesToSendGet.size() > 1)
			Files.write(Paths.get("Times_To_Send_Get.txt"), timesToSendGet , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(timesToSendSet.size() > 1)
			Files.write(Paths.get("Times_To_Send_Set.txt"), timesToSendSet , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);
		
		if(tSendMG.size() > 1)
			Files.write(Paths.get("TSendMG.txt"), tSendMG , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(tSendRespGet.size() > 1)
			Files.write(Paths.get("Times_To_Send_Back_Get.txt"), tSendRespGet , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(tSendRespSet.size() > 1)
			Files.write(Paths.get("Times_To_Send_Back_Set.txt"), tSendRespSet , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(tSRBMG.size() > 1)
			Files.write(Paths.get("TSRBMG.txt"), tSRBMG , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(timesInProcessingGet.size() > 1)
			Files.write(Paths.get("Times_In_Processing_Get.txt"), timesInProcessingGet , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(timesInProcessingSet.size() > 1)
			Files.write(Paths.get("Times_In_Processing_Set.txt"), timesInProcessingSet , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(tPMG.size() > 1)
			Files.write(Paths.get("TPMG.txt"), tPMG , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(timesInQueueS.size() > 1)
			Files.write(Paths.get("Times_In_Queue_Set.txt"), timesInQueueS , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);
		

		if(timesInQueueG.size() > 1)
			Files.write(Paths.get("Times_In_Queue_Get.txt"), timesInQueueG , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(setThroughputs.size() > 1)
			Files.write(Paths.get("Set_Throughputs.txt"), setThroughputs , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(getThroughputs.size() > 1)
			Files.write(Paths.get("Get_Throughputs.txt"), getThroughputs , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);
		

		if(mgTh.size() > 1)
			Files.write(Paths.get("MGTH.txt"), mgTh , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(rtGet.size() > 1)
			Files.write(Paths.get("Get_RT.txt"), rtGet , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(rtSet.size() > 1)
			Files.write(Paths.get("Set_RT.txt"), rtSet , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(rtMG.size() > 1)
			Files.write(Paths.get("RTMG.txt"), rtMG , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(keyCounts.size() > 1) 
			Files.write(Paths.get("KC.txt"), keyCounts , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);

		if(arrivalRates.size() > 1) {
			Files.write(Paths.get("AR.txt"), arrivalRates , StandardCharsets.UTF_8,
					StandardOpenOption.CREATE, StandardOpenOption.APPEND);			
		}

		Files.write(Paths.get("Queue_Lenghts.txt"), requestsQueueSizes , StandardCharsets.UTF_8,
				StandardOpenOption.CREATE, StandardOpenOption.APPEND);


	}
	
	/* ---------- GETS ----------*/
	
	public AtomicInteger getServerIndex() {
		return this.serverIndex;
	}

	public void getIPsandPortsFromList(List<String> mcAddresses) {
		iPs = new String[mcAddresses.size()];
		ports = new Integer[mcAddresses.size()];
		String[] split = null;

		for (int i = 0; i < mcAddresses.size(); i++) {
			split = mcAddresses.get(i).split(":");
			iPs[i] = split[0];
			ports[i] = Integer.valueOf(split[1]);
		}

	}

	public String[] getIPs() {
		return this.iPs;
	}

	public Integer[] getPorts() {
		return this.ports;
	}
	
	public boolean getKeySix() {
		return this.keySix;
	}
	

	/* --------------------------*/

}


