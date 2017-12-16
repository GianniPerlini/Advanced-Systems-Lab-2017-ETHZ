package ch.ethz.asltest;

import java.util.TimerTask;
import java.util.concurrent.LinkedBlockingQueue;

/**
 * 
 * Keep track of length of the request queue every 100 milliseconds
 *
 */
public class QueueLengthTimerTask extends TimerTask {

	private LinkedBlockingQueue<RequestWrapper> requestsQueue;


	public QueueLengthTimerTask(LinkedBlockingQueue<RequestWrapper> requestsQueue) {
		this.requestsQueue = requestsQueue;
	}


	@Override
	public void run() {
		MyMiddleware.requestsQueueSizes.add(String.valueOf(requestsQueue.size()));
		
	}

}
