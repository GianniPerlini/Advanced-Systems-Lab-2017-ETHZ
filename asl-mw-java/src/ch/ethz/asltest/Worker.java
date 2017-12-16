package ch.ethz.asltest;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

/**
 *
 * Class implementing thread's job in thread pool
 *
 */
public class Worker implements Runnable {

	private static final String ERROR = "ERROR\r\n";
	
	/*---------- FROM MW ---------- */
	
	private LinkedBlockingQueue<RequestWrapper> requestsQueue;
	private int serverTotal;
	private MyMiddleware middleware;
	private String[] iPs;
	private Integer[] ports;
	private boolean readSharded;
	
	/*------------------------------ */

	
	private SocketChannel socketChannel;
	private String stringRequest;
	
	public static AtomicLong tIQSumS = new AtomicLong();
	public static AtomicInteger tIQCountS = new AtomicInteger();
	public static AtomicLong tIQSumG = new AtomicLong();
	public static AtomicInteger tIQCountG = new AtomicInteger();
	private long tIQ;

	/*---------- PRIVATE STATISTICS RELATED ARGUMENTS ----------*/
	
	private long startParseTime;
	private long startSendTime;
	private long startSendRespTime;
	private long memcachedTime;
	private long putTime;
	private long pullTime;
	
	private long gets = 0;
	private long sets = 0;
	
	// For gets
	private long s1Count, s2Count, s3Count;
	// Only for section 4, shows that sets are forwarded to all servers
	private int[] serversCount;
	private int keyCount;
	
	private ArrayList<String> wrongRequests;
	private ArrayList<String> serverErrors;
	
	/*-----------------------------------------------------------*/

	/*---------- ATOMIC STATISTICS RELATED ARGUMENTS ----------*/
	
	public static AtomicLong tParseSumGet = new AtomicLong();
	public static AtomicInteger tParseCountGet = new AtomicInteger();
	public static AtomicLong tParseSumSet = new AtomicLong();
	public static AtomicInteger tParseCountSet = new AtomicInteger();

	public static AtomicLong tSendSumGet = new AtomicLong();
	public static AtomicInteger tSendCountGet = new AtomicInteger();
	public static AtomicLong tSendSumSet = new AtomicLong();
	public static AtomicInteger tSendCountSet = new AtomicInteger();	

	public static AtomicLong tPSumGet = new AtomicLong();
	public static AtomicInteger tPCountGet = new AtomicInteger();
	public static AtomicLong tPSumSet = new AtomicLong();
	public static AtomicInteger tPCountSet = new AtomicInteger();

	public static AtomicLong tSendRespSumSet = new AtomicLong();
	public static AtomicInteger tSendRespCountSet = new AtomicInteger();

	public static AtomicLong tSendRespSumGet = new AtomicLong();
	public static AtomicInteger tSendRespCountGet = new AtomicInteger();

	public static AtomicLong rtSumSet = new AtomicLong();
	public static AtomicInteger rtCountSet = new AtomicInteger();

	public static AtomicLong rtSumGet = new AtomicLong();
	public static AtomicInteger rtCountGet = new AtomicInteger();

	// Multi Get Statistics
	public static AtomicLong tParseMGSum = new AtomicLong();
	public static AtomicInteger tParseMGCount = new AtomicInteger();

	public static AtomicLong tSendMGSum = new AtomicLong();
	public static AtomicInteger tSendMGCount = new AtomicInteger();

	public static AtomicLong tPMGSum = new AtomicLong();
	public static AtomicInteger tPMGCount = new AtomicInteger();

	public static AtomicLong tSRMGSum = new AtomicLong();
	public static AtomicInteger tSRMGCount = new AtomicInteger();

	public static AtomicLong rtMGSum = new AtomicLong();
	public static AtomicInteger rtMGCount = new AtomicInteger();

	public static AtomicLong keyCountSum = new AtomicLong();
	public static AtomicInteger keyCountC = new AtomicInteger();

	public static AtomicInteger missCount = new AtomicInteger();
	public static AtomicInteger missKeyCount = new AtomicInteger();

	public static AtomicInteger opsPerSecond = new AtomicInteger();
	public static AtomicInteger getsPerSecond = new AtomicInteger();
	public static AtomicInteger	setsPerSecond = new AtomicInteger();
	public static AtomicInteger mgPerSecond = new AtomicInteger();
	
	/*---------------------------------------------------------*/


	private boolean isGet;
	private boolean isMultiGet;
	
	
	/*---------- THREAD LOCALS FOR REUSABLE STANDARD I/O OPERATIONS ----------*/
	
	private final ThreadLocal<ArrayList<Socket>> reusableSockets = new ThreadLocal<ArrayList<Socket>>() {
		@Override
		protected ArrayList<Socket> initialValue() {
			ArrayList<Socket> sockets = new ArrayList<>();
			try {
				
				for (int i = 0; i < serverTotal; i++) {
					sockets.add(new Socket(iPs[i], ports[i]));
				}


			} catch (IOException e) {
				e.printStackTrace();
			}
			return sockets;
		}
	};

	private final ThreadLocal<ArrayList<BufferedReader>> reusableBR = new ThreadLocal<ArrayList<BufferedReader>>() {
		@Override
		protected ArrayList<BufferedReader> initialValue() {
			ArrayList<BufferedReader> bRs = new ArrayList<>();
			try {

				for (int i = 0; i < reusableSockets.get().size(); i++) {
					bRs.add(new BufferedReader(new InputStreamReader(reusableSockets.get().get(i).getInputStream())));
				}

			} catch (IOException e) {
				e.printStackTrace();
			}
			return bRs;
		}
	};

	private final ThreadLocal<ArrayList<PrintWriter>> reusablePW = new ThreadLocal<ArrayList<PrintWriter>>() {
		@Override
		protected ArrayList<PrintWriter> initialValue() {
			ArrayList<PrintWriter> pWs = new ArrayList<>();
			try {

				for (int i = 0; i < reusableSockets.get().size(); i++) {
					pWs.add(new PrintWriter(reusableSockets.get().get(i).getOutputStream()));
				}

			} catch (IOException e) {
				e.printStackTrace();
			}
			return pWs;
		}
	};
	
	/*-------------------------------------------------------------------------*/


	public Worker(LinkedBlockingQueue<RequestWrapper> requestsQueue, int serverTotal, MyMiddleware middleware, String[] iPs, Integer[] ports, boolean readSharded) {
		this.requestsQueue = requestsQueue;
		this.serverTotal = serverTotal;
		this.middleware = middleware;
		this.iPs = iPs;
		this.ports = ports;
		this.readSharded = readSharded;
		
		this.socketChannel = null;
		this.stringRequest = "";
		
		this.startParseTime = 0;
		this.startSendTime = 0;
		this.startSendRespTime = 0;
		this.memcachedTime = 0;
		this.putTime = 0;
		this.pullTime = 0;
		this.tIQ = 0;

		this.keyCount = 0;
		
		this.isGet = false;
		this.isMultiGet = true;
		
		this.wrongRequests = new ArrayList<>();
		this.serverErrors = new ArrayList<>();
		this.serversCount = new int[3];

	}

	@Override
	public void run() {

		while (true) {
			try {
				System.out.println("IN WORKER RUN METHOD");
				
				RequestWrapper request = requestsQueue.take();

				// CAMBIARE CON GETSOCKETCHANNEL E VEDERE SE FUNZIONA
				if(request.getRequest().equals("exit") && request.getClientSocket() == null) {
					System.out.println("IN WORKER BREAK");
					break;
				}

				pullTime = System.nanoTime();
				putTime = request.getPutTime();
				// Time in Queue
				tIQ = (pullTime - putTime); 

				stringRequest = request.getRequest();
				socketChannel = request.getSocketChannel();

				startParseTime = System.nanoTime();

				// Parse the request to know if it is a get, set or gets
				parseRequest(stringRequest);

			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}



		try {
			System.out.println("Stopping Worker");

			socketChannel.close();

			for(int i = 0; i < serverTotal; i++) {
				reusableBR.get().get(i).close();
				reusablePW.get().get(i).close();
				reusableSockets.get().get(i).close();
			}

			
			/*---------- WRITE ERRORS AND SERVER COUNTS ----------*/
			
			ArrayList<String> serverCounts = new ArrayList<>();

			if(s1Count != 0)
				serverCounts.add("S1 Load: " + Thread.currentThread().getName() + " :" + String.valueOf(s1Count));

			if(s2Count != 0)
				serverCounts.add("S2 Load: " + Thread.currentThread().getName() + " :" + String.valueOf(s2Count));

			if(s3Count != 0)
				serverCounts.add("S3 Load: " + Thread.currentThread().getName() + " :" + String.valueOf(s3Count));


			if(serverCounts.size() != 0)
				Files.write(Paths.get("Server_Loads.txt"), serverCounts , StandardCharsets.UTF_8,
						StandardOpenOption.CREATE, StandardOpenOption.APPEND);

			if (serversCount[0] != 0 && serversCount[1] != 0 && serversCount[2] != 0) {
				serverCounts.add("S1 Load " + Thread.currentThread().getName() + " :" + String.valueOf(serversCount[0]));
				serverCounts.add("S2 Load " + Thread.currentThread().getName() + " :" + String.valueOf(serversCount[1]));
				serverCounts.add("S3 Load " + Thread.currentThread().getName() + " :" + String.valueOf(serversCount[2]));

				Files.write(Paths.get("Server_Loads_S4.txt"), serverCounts , StandardCharsets.UTF_8,
						StandardOpenOption.CREATE, StandardOpenOption.APPEND);
			}


			if(wrongRequests.size() != 0) {
				Files.write(Paths.get("Wrong_Requests.txt"), wrongRequests , StandardCharsets.UTF_8,
						StandardOpenOption.CREATE, StandardOpenOption.APPEND);
			}

			if (serverErrors.size() != 0) {
				Files.write(Paths.get("Server_Errors.txt"), serverErrors , StandardCharsets.UTF_8,
						StandardOpenOption.CREATE, StandardOpenOption.APPEND);				
			}


		} catch (IOException e) {
			e.printStackTrace();
		} 

	}

	/*------------------------------ PARSING ------------------------------ */
	
	/**
	 * @param stringRequest - the request to parse
	 * 
	 * Parse the request
	 */
	private void parseRequest(String stringRequest) {
		// Takes first tree letters of the request, so get or set
		// Also possible to do a .contains

		System.out.println("PARSE REQUEST");
		String type = stringRequest.substring(0, 3);	

		switch (type) {
		case "set":
			
			/*---------- Compute appropriate times and stores them ---------*/
			long endParsing = System.nanoTime() - startParseTime;
			tParseSumSet.addAndGet(endParsing);
			tParseCountSet.incrementAndGet();
			tIQSumS.addAndGet(tIQ);
			tIQCountS.incrementAndGet();
			
			isGet = false;
			System.out.println("SET CASE");
					
			startSendTime = System.nanoTime();
			handleSetRequest();
			break;

		case "get":
			System.out.println("GET CASE");
			
			// Check if it is a get or multi get
			isMultiGet = (stringRequest.split(" ").length > 2);
			
			if(isMultiGet) {
				
				long endParsingGet = System.nanoTime() - startParseTime;
				tParseMGSum.addAndGet(endParsingGet);
				tParseMGCount.incrementAndGet();
				tIQSumG.addAndGet(tIQ);
				tIQCountG.incrementAndGet();

				startSendTime = System.nanoTime();
				handleMultiGetRequest();
				
			} else {
				isGet = true;
				
				long endParsingGet = System.nanoTime() - startParseTime;
				tParseSumGet.addAndGet(endParsingGet);
				tParseCountGet.incrementAndGet();
				tIQSumG.addAndGet(tIQ);
				tIQCountG.incrementAndGet();

				startSendTime = System.nanoTime();
				handleGetRequest();
			
			}
			break;

		default:
			// Discard request and log the event
			wrongRequests.add("Wrong request: " + stringRequest);
			sendResponseToClient(ERROR, false);
			break;
		}
		
	}
	
	/*-------------------------------------------------------------------- */


	
	/*------------------------------ GET REQUESTS ------------------------------ */
	
	/**
	 *
	 * Compute the right server index and call sendRequestToServer with appropriate parameters
	 * 
	 */
	private void handleGetRequest() {
		System.out.println("HANDLE GET REQUEST");

		// Round robin
		int serverNumber = middleware.getServerIndex().getAndIncrement() % serverTotal;

		switch (serverNumber) {
		case 0:
			
			s1Count++;
			sendRequestToServer(iPs[0], ports[0], serverNumber, true);
			break;

		case 1:
			
			s2Count++;
			sendRequestToServer(iPs[1], ports[1], serverNumber, true);
			break;

		case 2:
			
			s3Count++;
			sendRequestToServer(iPs[2], ports[2], serverNumber, true);
			break;


		default:
			break;
		}
		
	}

	/**
	 * @param hostName - Server's IP
	 * @param port - Server's port
	 * @param index - Server's index
	 * @param isSingleGet - Single get or Multi get with one key
	 * 
	 * Send get request to appropriate server and wait for the response
	 */
	private void sendRequestToServer(String hostName, int port, int index, boolean isSingleGet) {
		
		System.out.println("SEND GET REQUEST TO SERVER");
		
		try {

			// Take appropriate I/O resources
			Socket connectionSocket = reusableSockets.get().get(index);
			BufferedReader in = reusableBR.get().get(index);
			PrintWriter write = reusablePW.get().get(index);
			String response = null;

			// Send request
			if(connectionSocket != null && write != null && in != null) {
				write.write(stringRequest);
				write.flush();
			}

			// this is the time where the sending process finished and when the waiting for memcached time begin
			long afterSendTime = System.nanoTime();

			// Distinguish between type of request for statistics
			if (isSingleGet) {
				
				tSendSumGet.addAndGet(afterSendTime - startSendTime);
				tSendCountGet.incrementAndGet();

			} else {
				
				tSendMGSum.addAndGet(afterSendTime - startSendTime);
				tSendMGCount.incrementAndGet();
			}


			String completeResponse = "";
			while((response = in.readLine()) != null) {
				
				completeResponse = completeResponse.concat(response).concat("\r\n");
				
				if(completeResponse.contains("END")) {
					break;
				}
			
			}

			long endProcessingTime = System.nanoTime();
			memcachedTime = endProcessingTime - afterSendTime;

			if(isSingleGet)	{
				
				tPSumGet.addAndGet(memcachedTime);
				tPCountGet.incrementAndGet();

			} else {
			
				tPMGSum.addAndGet(memcachedTime);
				tPMGCount.incrementAndGet();
			}
			
			startSendRespTime = System.nanoTime();

			if(isSingleGet) {

				// If response does not contain the string VALUE => miss
				missKeyCount.incrementAndGet(); // misleading name, this is the total count
				
				if(!completeResponse.contains("VALUE")) {
				
					missCount.incrementAndGet();
				
				}

			} else {
				// Calculate the total key count of the request to be able to calculate the miss count
				String stringKeys = stringRequest.replaceAll("get ", "").replaceAll("\r\n", "").concat(" ");
				String[] getsArray = stringKeys.split(" ");
				keyCount = getsArray.length;
				keyCountSum.addAndGet(keyCount);
				keyCountC.incrementAndGet();

				int misses = 0;
				// Miss = number of key in original request - number of values returned by the servers
				misses += keyCount - (completeResponse.split("VALUE").length - 1);
				missCount.addAndGet(misses);
				missKeyCount.addAndGet(keyCount);

			}

			sendResponseToClient(completeResponse, true);

		} catch(IOException e) {
			e.printStackTrace();
		}
	}
	
	/*--------------------------------------------------------------------------- */

	/*------------------------------ MULTI GET REQUESTS ------------------------------ */

	/**
	 *
	 * Handle multi gets, splitting if necessary
	 * 
	 */
	private void handleMultiGetRequest() {
		System.out.println("HANDLE MULTI GET REQUEST");

		if(readSharded) {
			
			int numGets = stringRequest.length() - stringRequest.replaceAll(" ", "").length();

			String[] serversGets = splitMultiGetEvenly(numGets);

			sendMultiGetRequest(serversGets);
			
		} else {
			
			sendMultiGetRequest(null);
		}

	}

	/**
	 * 
	 * Splits the keys evenly on the servers
	 * 
	 * @param numGets - not used anymore, kept for consistency
	 * 
	 * @return array containing requests, one for each server
	 */
	private String[] splitMultiGetEvenly(int numGets) {
		System.out.println("SPLIT MULTI GET");
		
		// String consisting of keys only
		String stringKeys = stringRequest.replaceAll("get ", "").replaceAll("\r\n", "").concat(" ");
		
		// Will contains per server request
		String[] serversGets = new String[serverTotal];

		String[] getsArray = stringKeys.split(" ");
		keyCount = getsArray.length;
		keyCountSum.addAndGet(keyCount);
		keyCountC.incrementAndGet();

		
		for (int i = 0; i < serverTotal; i++) {
			serversGets[i] = "get ";
		}

		// Start from the least recently used server
		int serverIndex = middleware.getServerIndex().get();

		// Iterate over all the keys, appending it to the appropriate server's request
		// Use modulo to calculate the indexes
		for (int i = 0; i < getsArray.length; i++) {
		
			if((getsArray.length - 1 - i) < serverTotal) {
			
				serversGets[(serverIndex + i) % serverTotal] = serversGets[(serverIndex + i)% serverTotal].concat(getsArray[i]);
			
			} else {
			
				serversGets[(serverIndex + i) % serverTotal] = serversGets[(serverIndex + i)% serverTotal].concat(getsArray[i]).concat(" ");
			
			}
		}

		serverIndex += (getsArray.length % serverTotal);

		middleware.getServerIndex().set(serverIndex);

		
		for (int i = 0; i < serverTotal; i++) {
			
			serversGets[i] = serversGets[i].concat("\r\n");

		}
		
		return serversGets;
	}


	/**
	 * 
	 * Send multi get to the servers, wait for all the responses
	 * 
	 * @param serversGets - array of requests, one for each server
	 * 
	 */
	private void sendMultiGetRequest(String[] serversGets) {
		System.out.println("SEND MULTI GET REQUEST");

		if (!readSharded) {
			
			// If sharding disabled, treat as a normal get
			int serverNumber = middleware.getServerIndex().getAndIncrement() % serverTotal;
			sendRequestToServer(iPs[serverNumber], ports[serverNumber], serverNumber, false);

		} else {

			try {
				// Take appropriate I/O resources and send requests to the servers
				for (int i = 0; i < serverTotal; i++) {
					Socket connectionSocket = reusableSockets.get().get(i);
					PrintWriter out = reusablePW.get().get(i);

					if(connectionSocket != null && out != null) {
						out.write(serversGets[i]);
						out.flush();
					}

				}


				long afterSendTime = System.nanoTime();
				tSendMGSum.addAndGet(afterSendTime - startSendTime);
				tSendMGCount.incrementAndGet();

				String[] responses = new String[serverTotal];
				String finalResponse = "";

				// Wait for all responses
				for (int i = 0; i < serverTotal; i++) {
					
					BufferedReader in = reusableBR.get().get(i);
					
					while((responses[i] = in.readLine()) != null) {
					
						responses[i] = responses[i].concat("\r\n");

						finalResponse = finalResponse.concat(responses[i]);

						if(responses[i].equals("END\r\n") && (serverTotal - 1 - i) > 0) {
						
							// Other responses still coming, get rid of END
							finalResponse = finalResponse.replace("END\r\n", "");
							break;
						
						} else if(responses[i].equals("END\r\n") && i == (serverTotal - 1)){
						
							break;
						
						}
					}

				}


				long endProcessingTime = System.nanoTime();
				memcachedTime = endProcessingTime - afterSendTime;
				tPMGSum.addAndGet(memcachedTime);
				tPMGCount.incrementAndGet();

				startSendRespTime = System.nanoTime();

				// Number of misses is the number of keys in the original request
				// minus the instances of VALUE in the final response
				int misses = 0;
				misses += keyCount - (finalResponse.split("VALUE").length - 1);
				missCount.addAndGet(misses);
				missKeyCount.addAndGet(keyCount);
				
				sendResponseToClient(finalResponse, true);

			} catch(IOException e) {
				e.printStackTrace();
			}
		}

	}
	
	/*-------------------------------------------------------------------------------- */

	/*------------------------------ SET REQUESTS ------------------------------ */

	/**
	 *
	 * Simply call sendSetRequest
	 * 
	 */
	private void handleSetRequest() {
		System.out.println("HANDLE SET REQUEST");
		sendSetRequest(stringRequest);

	}

	/**
	 * This method first sends set requests to all servers, then wait for single replies.
	 */
	private void sendSetRequest(String request) {
		System.out.println("SEND SET REQUEST");

		try {
			
			for (int i = 0; i < serverTotal; i++) {
				Socket connectionSocket = reusableSockets.get().get(i);
				PrintWriter out = reusablePW.get().get(i);

				if(connectionSocket != null && out != null) {
					out.write(request);
					out.flush();
				}

				serversCount[i]++;

			}


			long afterSendTime = System.nanoTime();
			tSendSumSet.addAndGet(afterSendTime - startSendTime);
			tSendCountSet.incrementAndGet();

			String[] responses = new String[serverTotal];
			int correctSets = 0;
			int errorIdx = 0;

			for (int i = 0; i < serverTotal; i++) {
				// Set response is only one line
				BufferedReader in = reusableBR.get().get(i);
				responses[i] = in.readLine().concat("\r\n");

				if(responses[i].equals("STORED\r\n")) {

					correctSets++;

				} else {
					
					serverErrors.add("Error in server " + i + ": " + responses[i]);
					errorIdx = i;
				
				}

			}


			long endProcessingTime = System.nanoTime();
			memcachedTime = endProcessingTime - afterSendTime;
			tPSumSet.addAndGet(memcachedTime);
			tPCountSet.incrementAndGet();

			startSendRespTime = System.nanoTime();

			if(correctSets == serverTotal) {
				// Index does not matter since all responses are the same
				sendResponseToClient(responses[0], true);
				
			} else {
				
				sendResponseToClient(responses[errorIdx], false);
			}

		} catch(IOException e) {
			e.printStackTrace();
		}

	}
	
	/*--------------------------------------------------------------------------- */


	/*------------------------------ SEND RESPONSE BACK ------------------------------ */

	/**
	 * Sends server response back to client 
	 * 
	 * @param response: response to be sent
	 
	 */
	private void sendResponseToClient(String response, boolean isLegit) {
		System.out.println("SEND RESPONSE TO CLIENT");
		
		// Should have checked which type of request in order to save resources
		ByteBuffer buffer = ByteBuffer.allocate(15000);
		
		buffer.clear();
		buffer.put(response.getBytes());
		buffer.flip();

		try {

			socketChannel.write(buffer);
			long endSendResponseTime = System.nanoTime();

			if (isLegit) {
				if(isGet) {

					getsPerSecond.incrementAndGet();

					gets++;
					MyMiddleware.getTHPerWT.put(Long.valueOf(Thread.currentThread().getId()), Long.valueOf(gets));
					MyMiddleware.getSTPerWT.put(Long.valueOf(Thread.currentThread().getId()), Long.valueOf(endSendResponseTime - pullTime));

					tSendRespSumGet.addAndGet(endSendResponseTime - startSendRespTime);
					tSendRespCountGet.incrementAndGet();

					rtSumGet.addAndGet(endSendResponseTime - putTime);
					rtCountGet.incrementAndGet();
					
					isGet = false;
					
					// Only for Section 5, response time distribution
					if(middleware.getKeySix())
						writeRT("singleGetRT", endSendResponseTime - putTime);

				} else if(isMultiGet) {

					mgPerSecond.incrementAndGet();

					tSRMGSum.addAndGet(endSendResponseTime - startSendRespTime);
					tSRMGCount.incrementAndGet();

					rtMGSum.addAndGet(endSendResponseTime - putTime);
					rtMGCount.incrementAndGet();
					isMultiGet = false;

					// Only for Section 5, response time distribution
					if(middleware.getKeySix())
						writeRT("singleMgRt", endSendResponseTime - putTime);

				} else {
					setsPerSecond.incrementAndGet();

					sets++;					
					MyMiddleware.setTHPerWT.put(Long.valueOf(Thread.currentThread().getId()), Long.valueOf(sets));
					MyMiddleware.setSTPerWT.put(Long.valueOf(Thread.currentThread().getId()), Long.valueOf(endSendResponseTime - pullTime));

					tSendRespSumSet.addAndGet(endSendResponseTime - startSendRespTime);
					tSendRespCountSet.incrementAndGet();

					rtSumSet.addAndGet(endSendResponseTime - putTime);
					rtCountSet.incrementAndGet();

					if(middleware.getKeySix())
						writeRT("singleSetRt", endSendResponseTime - putTime);

				}
			}

			
		} catch (IOException e) {
			e.printStackTrace();
		}

	}	
	
	/*--------------------------------------------------------------------------------- */

	/**
	 * 
	 * Write response time to file
	 * 
	 * @param fileName: name of the file to write response time in
	 * @param rt: response time to be written
	 * 
	 * @throws IOException
	 * 
	 */
	private void writeRT(String fileName, long rt) throws IOException {
		
		ArrayList<String> rts = new ArrayList<>(1);
		rts.add(String.valueOf(rt));
		Files.write(Paths.get(fileName), rts , StandardCharsets.UTF_8, StandardOpenOption.CREATE, StandardOpenOption.APPEND);		
	
	}

}
