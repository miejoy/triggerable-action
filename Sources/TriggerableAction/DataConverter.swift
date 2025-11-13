//
//  DataConverter.swift
//  triggerable-action
//
//  Created by 黄磊 on 2025/11/9.
//


/// 数据异步转化器
public protocol AsyncDataConverter: Sendable {
    associatedtype Input
    associatedtype Output
    
    /// 处理当前数据，并生成下游数据
    func process(data: Input) async throws -> Output
}

/// 数据转化器
public protocol DataConverter: AsyncDataConverter {
    /// 处理当前数据，并生成下游数据
    func process(data: Input) throws -> Output
}

public protocol AsyncDataToVoidConverter: AsyncDataConverter where Output == Void {}
public protocol DataToVoidConverter: DataConverter, AsyncDataToVoidConverter where Output == Void {}

extension AsyncDataConverter where Output == Void {
    public func process(data: Input) async throws -> Output {
        Void()
    }
}

extension DataConverter where Output == Void {
    public func process(data: Input) throws -> Output {
        Void()
    }
}
