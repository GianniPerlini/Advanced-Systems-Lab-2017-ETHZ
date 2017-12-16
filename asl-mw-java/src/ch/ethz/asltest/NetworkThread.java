package ch.ethz.asltest;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.sql.Time;
import java.util.Iterator;
import java.util.Timer;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;

/**
 * 
 * Class encapsulating the Network Thread
 *
 */
public class NetworkThread extends Thread {

	private LinkedBlockingQueue<RequestWrapper> requestsQueue;
	private String iP;
	private int port;
	
	private Selector selector;
	private ByteBuffer buffer;
	
	private String setRequest = "";
	
	// To know when to stop
	private boolean isRunning;
	private boolean isFirst;

	// Timers
	private Timer loggingTimer;
	private Timer queueLengthTimer;
	
	// Keep track of arrival rate
	public static AtomicLong arrivalRate = new AtomicLong();

	private final int SIZE = 2048;

	public NetworkThread(String iP, int port, LinkedBlockingQueue<RequestWrapper> requestsQueue) {
		this.iP = iP;
		this.port = port;
		this.requestsQueue = requestsQueue;
		this.selector = null;
		this.buffer = ByteBuffer.allocate(SIZE);
		this.isRunning = true;
		this.loggingTimer = new Timer();
		this.queueLengthTimer = new Timer();
		this.isFirst = true;
	}


	@Override
	public void run() {
		try {

			selector = Selector.open();
			ServerSocketChannel serverChannel = ServerSocketChannel.open();
			serverChannel.configureBlocking(false);

			serverChannel.socket().bind(new InetSocketAddress(iP, port));
			serverChannel.register(selector, SelectionKey.OP_ACCEPT);

			while(isRunning) {
				// Listen on the channel for events
				selector.select();
				Iterator<SelectionKey> selectedKeys = selector.selectedKeys().iterator();

				while(selectedKeys.hasNext()) {

					SelectionKey key = (SelectionKey) selectedKeys.next();
					selectedKeys.remove();

					if(!key.isValid()) {
						continue;
					} else if(key.isAcceptable()) {
						acceptConnection(key);
					} else if(key.isReadable()) {
						readRequest(key);
					}
				}
			}

			System.out.println("STOPPING NETWORK THREAD");

			// Close what needs to be closed and canceled
			serverChannel.close();
			selector.close();
			
			loggingTimer.cancel();
			loggingTimer.purge();

			queueLengthTimer.cancel();
			queueLengthTimer.purge();


		} catch (IOException e) {
			e.printStackTrace();
		}
	}


	private void readRequest(SelectionKey key) {
		SocketChannel socketChannel = (SocketChannel) key.channel();
		buffer.clear();
		int read = -1;
		byte[] data = null;
		String request = "";
		arrivalRate.incrementAndGet();

		try {
			read = socketChannel.read(buffer);				

			while(read  != -1 && read != 0) {
				data = new byte[read];
				System.arraycopy(buffer.array(), 0, data, 0, read);
				request = new String(data);

				// This is not needed, kept just for consistency between experiments
				if(request.substring(0, 3).equals("get")) {
					System.out.println("GET REQUEST: " + request);
					requestsQueue.put(new RequestWrapper(request, socketChannel));
					
					if (isFirst) {
						LoggingTimerTask lTT = new LoggingTimerTask();
						loggingTimer.scheduleAtFixedRate(lTT, 1000, 1000);
						
						QueueLengthTimerTask qLTT = new QueueLengthTimerTask(requestsQueue);
						queueLengthTimer.scheduleAtFixedRate(qLTT, 100, 100);
						
						isFirst = false;
					}
					
					
					break;


				} else if(request.substring(0, 3).equals("set")) {

					if(request.split("\r\n").length == 2) {
						System.out.println("SET REQUEST");
						setRequest = setRequest.concat(request);
						requestsQueue.put(new RequestWrapper(setRequest, socketChannel));
						
						if (isFirst) {
							LoggingTimerTask lTT = new LoggingTimerTask();
							loggingTimer.scheduleAtFixedRate(lTT, 1000, 1000);

							QueueLengthTimerTask qLTT = new QueueLengthTimerTask(requestsQueue);
							queueLengthTimer.scheduleAtFixedRate(qLTT, 100, 100);
							
							isFirst = false;
						}
						
						setRequest = "";
						break;
					} 
					
				}
			}


		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
		}


	}


	private void acceptConnection(SelectionKey key) {
		try {

			ServerSocketChannel serverChannel = (ServerSocketChannel) key.channel();	
			SocketChannel clientChannel = serverChannel.accept();

			if(clientChannel != null) {
				clientChannel.configureBlocking(false);
				clientChannel.register(selector, SelectionKey.OP_READ);
			}

		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void interrupt() {
		this.isRunning = false;
	}

}
