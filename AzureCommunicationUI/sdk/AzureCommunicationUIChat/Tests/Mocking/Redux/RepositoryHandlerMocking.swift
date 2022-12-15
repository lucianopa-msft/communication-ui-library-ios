//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
@testable import AzureCommunicationUIChat

class RepositoryHandlerMocking: RepositoryMiddlewareHandling {
    var loadInitialMessagesCalled: ((Bool) -> Void)?
    var addPreviousMessagesCalled: ((Bool) -> Void)?
    var addNewSentMessageCalled: ((Bool) -> Void)?
    var updateNewEditedMessageCalled: ((Bool) -> Void)?
    var updateNewDeletedMessageCalled: ((Bool) -> Void)?
    var updateSentMessageIdAndSendStatusCalled: ((Bool) -> Void)?
    var updateMessageSendStatusCalled: ((Bool) -> Void)?
    var updateEditedMessageTimestampCalled: ((Bool) -> Void)?
    var updateDeletedMessageTimestampCalled: ((Bool) -> Void)?
    var addTopicUpdatedMessageCalled: ((Bool) -> Void)?
    var addParticipantAddedMessageCalled: ((Bool) -> Void)?
    var addParticipantRemovedMessageCalled: ((Bool) -> Void)?
    var addReceivedMessageCalled: ((Bool) -> Void)?
    var updateReceivedEditedMessageCalled: ((Bool) -> Void)?
    var updateReceivedDeletedMessageCalled: ((Bool) -> Void)?
    var readReceiptReceivedCalled: ((Bool) -> Void)?
    var addLocalUserRemovedMessage: ((Bool) -> Void)?
    var updateMessageReadReceiptStatusCalled: ((Bool) -> Void)?

    func loadInitialMessages(messages: [ChatMessageInfoModel], state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            loadInitialMessagesCalled?(true)
        }
    }

    func addPreviousMessages(messages: [ChatMessageInfoModel], state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            addPreviousMessagesCalled?(true)
        }
    }

    func addNewSentMessage(internalId: String, content: String, state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            addNewSentMessageCalled?(true)
        }
    }

    func updateNewEditedMessage(messageId: String, content: String, state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            updateNewEditedMessageCalled?(true)
        }
    }

    func updateNewDeletedMessage(messageId: String, state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            updateNewDeletedMessageCalled?(true)
        }
    }

    func updateSentMessageIdAndSendStatus(
                            internalId: String,
                            actualId: String,
                            state: AppState,
                            dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            updateSentMessageIdAndSendStatusCalled?(true)
        }
    }

    func updateMessageSendStatus(
                            messageId: String,
                            messageSendStatus: AzureCommunicationUIChat.MessageSendStatus,
                            dispatch: @escaping AzureCommunicationUIChat.ActionDispatch) -> Task<Void, Never> {
        Task {
            updateMessageSendStatusCalled?(true)
        }
    }

    func updateEditedMessageTimestamp(messageId: String, state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            updateEditedMessageTimestampCalled?(true)
        }
    }

    func updateDeletedMessageTimestamp(messageId: String, state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            updateDeletedMessageTimestampCalled?(true)
        }
    }

    func addTopicUpdatedMessage(threadInfo: ChatThreadInfoModel, state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            addTopicUpdatedMessageCalled?(true)
        }
    }

    func participantAddedMessage(participants: [ParticipantInfoModel],
                                 state: AzureCommunicationUIChat.AppState,
                                 dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            addParticipantAddedMessageCalled?(true)
        }
    }

    func participantRemovedMessage(participants: [ParticipantInfoModel], dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            addParticipantRemovedMessageCalled?(true)
        }
    }

    func addReceivedMessage(message: ChatMessageInfoModel, state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            addReceivedMessageCalled?(true)
        }
    }

    func updateReceivedEditedMessage(message: ChatMessageInfoModel, state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            updateReceivedEditedMessageCalled?(true)
        }
    }

    func updateReceivedDeletedMessage(message: ChatMessageInfoModel, state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            updateReceivedDeletedMessageCalled?(true)
        }
    }

    func updateMessageReceiptReceivedStatus(
        readReceiptInfo: ReadReceiptInfoModel,
        state: AppState,
        dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            updateMessageReadReceiptStatusCalled?(true)
        }
    }
    func addLocalUserRemovedMessage(state: AppState, dispatch: @escaping ActionDispatch) -> Task<Void, Never> {
        Task {
            addLocalUserRemovedMessage?(true)
        }
    }
}