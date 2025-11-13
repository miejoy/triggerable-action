//
//  TriggerBlockAction.swift
//
//
//  Created by 黄磊 on 2020-04-17.
//

import Foundation

/// 可触发闭包事件
public struct TriggerBlockAction<Data>: TriggerableAction {

    let block : @Sendable (Data) throws -> Void
        
    public init(block: @Sendable @escaping (Data) throws -> Void) {
        self.block = block
    }
    
    public func trigger(with data: Data) throws {
        try block(data)
    }
}

/// 可触发异步闭包事件
public struct TriggerAsyncBlockAction<Data>: TriggerableAsyncAction {

    let block : @Sendable (Data) async throws -> Void
        
    public init(block: @Sendable @escaping (Data) async throws -> Void) {
        self.block = block
    }
    
    public func trigger(with data: Data) async throws {
        try await block(data)
    }
}
