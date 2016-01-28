//
//  comm.swift
//  COR-Framework-iOS
//
//  Created by denis lavrov on 8/01/16.
//  Copyright © 2016 Denis Lavrov. All rights reserved.
//

import Foundation

public class NetworkAdapter{
    public let module: CORModule
    public init(module: CORModule){
        self.module = module
    }
    
    public func messageOut(msg: Message){
    }

}

public class CallbackNetworkAdapter: NetworkAdapter {
    var callbacks: [String: [(Message) -> Void]] = [:]
    
    public override init(module: CORModule){
        super.init(module: module)
    }
    public override func messageOut(message: Message){
        super.messageOut(message)
        if let clbks = self.callbacks[message.atype]{
            for callback in clbks {
                callback(message)
            }
        }
    }
    
    public func registerCallback(type: String, modules: CORModule...){
        for module in modules {
            if let networkAdapter = module.networkAdapter as? CallbackNetworkAdapter{
                if var clbks = self.callbacks[type]{
                    clbks.append(networkAdapter.handle)
                } else {
                    self.callbacks[type] = [networkAdapter.handle]
                }
            } else {
                print("Those modules cannot be linked")
            }
        }
    }
    public func handle(message: Message){
        self.module.messageIn(message)
    }
}