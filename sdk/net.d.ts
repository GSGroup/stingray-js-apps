// Copyright (c) 2011 - 2022, GS Group, https://github.com/GSGroup
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
// provided that the above copyright notice and this permission notice appear in all copies.
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
// IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

/**
 * Abstract component that represent object containing document URL and data.
 */
declare interface Event {
	readonly origin: string;
	readonly data: string;
}

/**
 * The EventSource interface is web content's interface to server-sent events.
 * An EventSource instance opens a persistent connection to an HTTP server, which sends events in text/event-stream format.
 * The connection remains open until closed by calling {@link EventSource.close()}
 */
declare class EventSource {
	static readonly CONNECTING: number;
	static readonly OPEN: number;
	static readonly CLOSED: number;

	/**
	 * Returns the URL providing the event stream.
	 */
	url: string;

	/**
	 * Returns true if the credentials mode for connection requests to the URL providing the event stream is set to "include", and false otherwise.
	 */
	withCredentials: boolean;

	/**
	 * Returns the state of this EventSource object's connection. It can have the values described below.
	 */
	readyState: number;

	/**
	 * Holds the property that determines last event id.
	 */
	lastEventId: string;

	/**
	 * Holds the property that determines the event handler called when a message {@link Event} is received,
	 * that is when a message is coming from the source.
	 */
	onmessage: (event: Event) => void;

	/**
	 * Holds the property that determines the event handler called when an open event is received,
	 * that is when the connection was just opened.
	 */
	onopen: () => void;

	/**
	 * Holds the property that determines the event handler called
	 * when an error occurs and the error event is dispatched on an {@link EventSource} object.
	 */
	onerror: (error: string) => void;

	/**
	 * Contructor
	 *
	 * @param url - source url
	 * @param withCredentials - is credentials in use. Default value is false.
	 */
	constructor(url: string, withCredentials?: boolean);

	/**
	 * Method that set up a function that will be called whenever the specified {@link Event} is delivered to the target.
	 *
	 * @param eventName - Name of event.
	 * @param callback - Function which receives a notification.
	 * @param useCapture - A Boolean indicating that events of this type will be dispatched to the registered listener before being dispatched to any EventTarget.
	 */
	addEventListener(eventName: string, callback: (event:Event) => void, useCapture: boolean);

	/**
	 * Method that used to start listening events.
	 */
	listen(): void;
	/**
	 * Aborts any instances of the fetch algorithm started for this EventSource object, and sets the readyState attribute to {@link EventSource.CLOSED}.
	 */
	close(): void;
}

/**
 * The HttpStreamSource interface is web content's interface to server-sent events.
 * An HttpStreamSource instance opens a persistent connection to an HTTP server, which sends http stream.
 * The connection remains open until closed by calling {@link HttpStreamSource.close()}
 */
declare class HttpStreamSource {
	static readonly CONNECTING: number;
	static readonly OPEN: number;
	static readonly CLOSED: number;

	/**
	 * Returns the URL providing the event stream.
	 */
	url: string;

	/**
	 * Holds the property that determines the event handler called when {@link HttpStreamSource.readyState} value changed.
	 */
	readyState: number;

	/**
	 * Holds the property that determines a number representing the state of the connection.
	 * Possible values are {@link HttpStreamSource.CONNECTING}, {@link HttpStreamSource.OPEN}, {@link HttpStreamSource.CLOSED}
	 */
	onreadystatechange: () => void;

	/**
	 * Holds the property that determines the event handler called when a data is received,
	 * that is when a data is coming from the source.
	 */
	onData: (data: string) => void;

	/**
	 * Holds the property that determines the event handler called when an error occurs
	 * and the error event is dispatched on an HttpStreamSource object.
	 */
	onError: (error: string) => void;

	/**
	 * Contructor
	 *
	 * @param url - source url
	 */
	constructor(url: string);

	/**
	 * Method that used to set http header.
	 *
	 * @param header - name of the header.
	 * @param value - value of header.
	 */
	setHeader(header: string, value: string): void;

	/**
	 * Method that used to start listening data.
	 */
	listen(): void;

	/**
	 * Method that used to close the connection, if any, and sets the readyState attribute to {@link HttpStreamSource.CLOSED}.
	 * If the connection is already closed, the method does nothing.
	 */
	close(): void;
}

/**
 * Use XMLHttpRequest (XHR) objects to interact with servers.
 * Despite its name, XMLHttpRequest can be used to retrieve any type of data, not just XML.
 */
declare class XMLHttpRequest {
	static readonly UNSENT: number;
	static readonly OPENED: number;
	static readonly HEADERS_RECEIVED: number;
	static readonly LOADING: number;
	static readonly DONE: number;

	/**
	 * Holds the property that determines the state of the request.
	 */
	readyState: number;

	/**
	 * Holds the property that determines the response status.
	 */
	status: number;

	/**
	 * Holds the property that that contains the response to the request as text,
	 * or null if the request was unsuccessful or has not yet been sent.
	 */
	responseText: string;

	/**
	 * Holds the property that that contains the response to the request, or null if the request was unsuccessful,
	 * has not yet been sent, or cannot be parsed as XML or HTML.
	 */
	responseXML: string;

	/**
	 * Holds the property that determines the event handler that is called whenever the readyState attribute changes.
	 */
	onreadystatechange: () => void;

	constructor();

	/**
	 * Method that used to initialize request.
	 *
	 * @param method - HTTP Method(GET/POST/PUT/DELETE)
	 * @param url -  server URL
	 * @param async - async request. Default value is true.
	 * @param user - user field in base HTTP Auth.
	 * @param password - password field in base HTTP Auth.
	 */
	open(method: string, url: string, async?: boolean, user?: string, password?: string): void;

	/**
	 * Method that used to set the value of an HTTP request header.
	 * You must call {@link HttpStreamSource.setRequestHeader()} after {@link HttpStreamSource.open()},
	 * but before {@link HttpStreamSource.send()}.
	 *
	 * @param header - HTTP header name.
	 * @param value - HTTP header value.
	 */
	setRequestHeader(header: string, value: string): void;

	/**
	 * Method used to send the request. If the request is asynchronous (which is the default), t
	 * his method returns as soon as the request is sent.
	 *
	 * @param data - HTTP request payload.
	 * @param timeout - Request timeout(milliseconds). Default value is 30000.
	 */
	send(data?: string, timeout?: number): void;

	/**
	 * Method that used to abort the request if it has already been sent.
	 */
	abort(): void;

	/**
	 * Returns the string containing the text of the specified header,
	 * or null if either the response has not yet been received or the header doesn't exist in the response.
	 *
	 * @param header - HTTP header name.
	 */
	getResponseHeader(header: string): string;

	/**
	 * Returns all the response headers, separated by CRLF, as a string, or null if no response has been received.
	 */
	getAllResponseHeaders(): string;
}
