//
//  TriggerCompletionAction.swift
//  triggerable-action
//
//  Created by 黄磊 on 2026/3/25.
//

import Foundation

/// 可触发异步闭包带结果事件
public struct TriggerCompletionAction<TriggerData: Sendable, ResultData: Sendable>: TriggerableAsyncResultAction {

    let block : @Sendable (TriggerData, (ResultData) -> Void) throws -> Void
    let timeout: TimeInterval
        
    public init(timeout: TimeInterval = 60.0, block: @Sendable @escaping (_ data: TriggerData, _ completion: (ResultData) -> Void) throws -> Void) {
        self.block = block
        self.timeout = timeout
    }
    
    public func trigger(with data: TriggerData) async throws -> ResultData {
        return try await withThrowingTaskGroup(of: ResultData.self) { group in
            // 添加主要任务
            group.addTask {
                try await withCheckedThrowingContinuation { continuation in
                    do {
                        try self.block(data) { result in
                            continuation.resume(returning: result)
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
            
            // 添加超时任务
            group.addTask {
                try await Task.sleep(for: .seconds(self.timeout))
                throw CancellationError()
            }
            
            // 等待第一个完成的任务（使用 ! 因为 group 中至少有两个任务，一定会返回结果）
            let result = try await group.next()!
            // 取消其他任务
            group.cancelAll()
            return result
        }
    }
}
