//
//  SubscriptionScreenView.swift
//  PodOuvir
//
//  Created by ProDoctor on 10/05/24.
//

import SwiftUI
import StoreKit

struct SubscriptionScreenView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let subscriptionManager = SubscriptionManager.shared
    
    var body: some View {
        SubscriptionStoreView(
            groupID: Configurations.subscriptionGroupId,
            visibleRelationships: .all
        )
        .subscriptionStorePolicyForegroundStyle(.teal)
        .subscriptionStoreControlStyle(.prominentPicker)
//        .subscriptionStorePolicyDestination(url: AppConstants.URLs.privacyPolicy, for: .privacyPolicy)
//            .subscriptionStorePolicyDestination(url: AppConstants.URLs.termsOfUse, for: .termsOfService)
            .subscriptionStoreButtonLabel(.multiline)
        .storeButton(.visible, for: .cancellation)
        .onInAppPurchaseCompletion { _, result in
            guard case .success(.success(let transaction)) = result else { return }
            await subscriptionManager.verify(transaction)
            dismiss()
        }
    }
}

#Preview {
    SubscriptionScreenView()
}
