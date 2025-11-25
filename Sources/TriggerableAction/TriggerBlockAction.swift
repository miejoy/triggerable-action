//
//  TriggerBlockAction.swift
//
//
//  Created by 黄磊 on 2020-04-17.
//

import Foundation

/// 可触发闭包事件
public struct TriggerBlockAction<TriggerData>: TriggerableAction {

    let block : @Sendable (TriggerData) throws -> Void
        
    public init(block: @Sendable @escaping (TriggerData) throws -> Void) {
        self.block = block
    }
    
    public func trigger(with data: TriggerData) throws {
        try block(data)
    }
}

/// 可触发异步闭包事件
public struct TriggerAsyncBlockAction<TriggerData>: TriggerableAsyncAction {

    let block : @Sendable (TriggerData) async throws -> Void
        
    public init(block: @Sendable @escaping (TriggerData) async throws -> Void) {
        self.block = block
    }
    
    public func trigger(with data: TriggerData) async throws {
        try await block(data)
    }
}


/// 可触发闭包带结果事件
public struct TriggerBlockResultAction<TriggerData, ResultData>: TriggerableResultAction {

    let block : @Sendable (TriggerData) throws -> ResultData
        
    public init(block: @Sendable @escaping (TriggerData) throws -> ResultData) {
        self.block = block
    }
    
    public func trigger(with data: TriggerData) throws -> ResultData {
        try block(data)
    }
}

/// 可触发异步闭包带结果事件
public struct TriggerAsyncBlockResultAction<TriggerData, ResultData>: TriggerableAsyncResultAction {

    let block : @Sendable (TriggerData) async throws -> ResultData
        
    public init(block: @Sendable @escaping (TriggerData) async throws -> ResultData) {
        self.block = block
    }
    
    public func trigger(with data: TriggerData) async throws -> ResultData {
        try await block(data)
    }
}
