//
//  SubscriptionManager.swift
//  PodOuvir
//
//  Created by Adriano Souza Costa on 10/05/24.
//

import Foundation
import StoreKit

@Observable
final class SubscriptionManager {
    
    // MARK: - Public Variables
    
    static var shared = SubscriptionManager()
    
    private(set) var hasPremium: Bool {
        didSet {
            userDefaults.setValue(hasPremium, forKey: hasPremiumKey)
        }
    }
    
    // MARK: - Private Variables
    
    private let userDefaults = UserDefaults.standard
    private let hasPremiumKey = "hasPremium"
    
    private var transactionUpdate: Task<Void, Never>? = nil
    private var subscriptions = Set<String>()
        
    // MARK: - Life Cicle
    
    init() {
        hasPremium = userDefaults.bool(forKey: hasPremiumKey)
        transactionUpdate = makeTransactionUpdateTask()
    }

    deinit {
        transactionUpdate?.cancel()
    }
    
    // MARK: - Public Methods
    
    func verify(_ result: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = result else {
            return
        }
        
        if transaction.revocationDate != nil {
            subscriptions.remove(transaction.productID)
        } else if let expirationDate = transaction.expirationDate, expirationDate < Date.now {
            subscriptions.remove(transaction.productID)
        } else if transaction.isUpgraded {
            subscriptions.remove(transaction.productID)
        } else {
            subscriptions.insert(transaction.productID)
        }
        
        await transaction.finish()
        
        hasPremium = !subscriptions.isEmpty
    }
    
    // MARK: - Private Methods
    
    private func makeTransactionUpdateTask() -> Task<Void, Never> {
        Task(priority: .background) {
            for await transaction in Transaction.currentEntitlements {
                await verify(transaction)
            }
            
            for await transaction in Transaction.updates {
                await verify(transaction)
            }
            
            for await transaction in Transaction.unfinished {
                await verify(transaction)
            }
        }
    }
    
}
