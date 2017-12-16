package ch.ethz.asltest;

import java.net.Socket;
import java.nio.channels.SocketChannel;

/**
 * This class is used to keep track of which client issued a specific requests
 * by binding the request to the proper socket channel
 */
public class RequestWrapper { 
	
	private String request;
	private Socket clientSocket;
	private SocketChannel socketChannel;
	private long putTime;
	
	public RequestWrapper(String request, SocketChannel socketChannel) {
		this.request = request;
		this.socketChannel = socketChannel;
		this.putTime = System.nanoTime();
	}

	public String getRequest() {
		return request;
	}

	public Socket getClientSocket() {
		return clientSocket;
	}
	
	public SocketChannel getSocketChannel() {
		return socketChannel;
	}
	
	public long getPutTime() {
		return putTime;
	}
	
	
	
}
