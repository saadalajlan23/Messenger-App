//
//  ConversationsModels.swift
//  Messenger-App
//
//  Created by administrator on 07/11/2021.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
