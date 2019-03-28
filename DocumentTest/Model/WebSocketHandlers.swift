//
//  WebSocketHandlers.swift
//  TestWebsocket
//
//  Created by perrion huds on 09/03/2019.
//  Copyright © 2019 perrion huds. All rights reserved.
//

import UIKit
import Starscream

class WebSocketHandlers: UIViewController, WebSocketDelegate
{
    
    var socket: WebSocket!
    
    func websocketDidConnect(socket: WebSocketClient)
    {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?)
    {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String)
    {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data)
    {
        print("Received data: \(data.count)")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var request = URLRequest(url: URL(string: "http://34.73.231.127")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
}

