//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AzureCommunicationUIChat
import AzureCommunicationCommon
import SwiftUI

struct ChatDemoView: View {

    @State var isErrorDisplayed: Bool = false
    @ObservedObject var envConfigSubject: EnvConfigSubject
    @State var isShowingChatView: Bool = false
    @State var errorMessage: String = ""

    let verticalPadding: CGFloat = 5
    let horizontalPadding: CGFloat = 10

    @State var chatAdapter: ChatAdapter?

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: chatView, isActive: $isShowingChatView) {
                    EmptyView()
                }
                launchView
            }
            .navigationTitle("UI Library - Chat Sample")
            .navigationBarTitleDisplayMode(.inline)
        }.onAppear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
        }.onDisappear {
            AppDelegate.orientationLock = UIInterfaceOrientationMask.all
        }.modifier(ErrorView(isPresented: $isErrorDisplayed,
                             errorMessage: errorMessage,
                             onDismiss: {
            isErrorDisplayed = false
            self.isShowingChatView = false
            self.chatAdapter?.disconnect()
            self.chatAdapter = nil
        }))
    }

    var launchView: some View {
        VStack {
            acsTokenSelector
            displayNameTextField
            userIdField
            endpointUrlField
            meetingSelector
            startExperience
            Spacer()
        }
        .padding()
    }

    var chatView: some View {
        VStack {
            if let chatAdapter = chatAdapter {
                ChatCompositeView(with: chatAdapter)
                    .navigationTitle("Chat")
                    .navigationBarTitleDisplayMode(.inline)
            } else {
                EmptyView()
                    .navigationTitle("Failed to start chat")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    var acsTokenSelector: some View {
        Group {
            Picker("Token Type", selection: $envConfigSubject.selectedAcsTokenType) {
                Text("Token URL").tag(ACSTokenType.tokenUrl)
                Text("Token").tag(ACSTokenType.token)
            }.pickerStyle(.segmented)
            switch envConfigSubject.selectedAcsTokenType {
            case .tokenUrl:
                TextField("ACS Token URL", text: $envConfigSubject.acsTokenUrl)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .textFieldStyle(.roundedBorder)
            case .token:
                TextField("ACS Token", text:
                            !envConfigSubject.useExpiredToken ?
                          $envConfigSubject.acsToken : $envConfigSubject.expiredAcsToken)
                .modifier(TextFieldClearButton(text: $envConfigSubject.acsToken))
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
            }
        }
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
    }

    var displayNameTextField: some View {
        TextField("Display Name", text: $envConfigSubject.displayName)
            .disableAutocorrection(true)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .textFieldStyle(.roundedBorder)
    }

    var userIdField: some View {
        TextField("Communication User Id", text: $envConfigSubject.userId)
            .disableAutocorrection(true)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .textFieldStyle(.roundedBorder)
    }

    var endpointUrlField: some View {
        TextField("ACS Endpoint Url", text: $envConfigSubject.endpointUrl)
            .disableAutocorrection(true)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .textFieldStyle(.roundedBorder)
    }

    var meetingSelector: some View {
        Group {
            Picker("Chat Type", selection: $envConfigSubject.selectedChatType) {
                Text("Group Chat").tag(ChatType.groupChat)
                Text("Teams Meeting").tag(ChatType.teamsChat)
            }.pickerStyle(.segmented)
            switch envConfigSubject.selectedChatType {
            case .groupChat:
                TextField(
                    "Group Chat ThreadId",
                    text: $envConfigSubject.threadId)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
            case .teamsChat:
                TextField(
                    "Team Meeting",
                    text: $envConfigSubject.teamsMeetingLink)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(.roundedBorder)
            }
        }
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
    }

    var startExperience: some View {
        Group {
            HStack {
                Button("Start Experience") {
                    if self.chatAdapter == nil {
                        self.startChatComposite()
                    }
                    self.isShowingChatView = true
                }
                .buttonStyle(DemoButtonStyle())
                .disabled(isStartExperienceDisabled)
                .accessibility(identifier: AccessibilityId.startExperienceAccessibilityID.rawValue)

                Button("Stop") {
                    self.chatAdapter = nil
                    self.isShowingChatView = false
                }
                .buttonStyle(DemoButtonStyle())
                .disabled(self.chatAdapter == nil)
                .accessibility(identifier: AccessibilityId.stopChatAccessibilityID.rawValue)

            }
        }
    }

    var isStartExperienceDisabled: Bool {
        let acsToken = envConfigSubject.useExpiredToken ? envConfigSubject.expiredAcsToken : envConfigSubject.acsToken
        if (envConfigSubject.selectedAcsTokenType == .token && acsToken.isEmpty)
            || envConfigSubject.selectedAcsTokenType == .tokenUrl && envConfigSubject.acsTokenUrl.isEmpty {
            return true
        }

        if (envConfigSubject.selectedChatType == .groupChat && envConfigSubject.threadId.isEmpty)
            || envConfigSubject.selectedChatType == .teamsChat && envConfigSubject.teamsMeetingLink.isEmpty {
            return true
        }

        return false
    }
}

extension ChatDemoView {
    func startChatComposite(headless: Bool = false) {
        let communicationIdentifier = CommunicationUserIdentifier(envConfigSubject.userId)
        guard let communicationTokenCredential = try? CommunicationTokenCredential(
            token: envConfigSubject.acsToken) else {
            return
        }

        self.chatAdapter = ChatAdapter(
            identifier: communicationIdentifier,
            credential: communicationTokenCredential,
            endpoint: envConfigSubject.endpointUrl,
            displayName: envConfigSubject.displayName)
        guard let chatAdapter = self.chatAdapter else {
            return
        }
        chatAdapter.events.onError = showError(error:)
        chatAdapter.connect(threadId: envConfigSubject.threadId) { _ in
            print("Chat connect completionHandler called")
        }
    }

    private func getTokenCredential() throws -> CommunicationTokenCredential {
        switch envConfigSubject.selectedAcsTokenType {
        case .token:
            let acsToken = envConfigSubject.useExpiredToken ?
            envConfigSubject.expiredAcsToken : envConfigSubject.acsToken
            if let communicationTokenCredential = try? CommunicationTokenCredential(token: acsToken) {
                return communicationTokenCredential
            } else {
                throw DemoError.invalidToken
            }
        case .tokenUrl:
            if let url = URL(string: envConfigSubject.acsTokenUrl) {
                let tokenRefresher = AuthenticationHelper.getCommunicationToken(tokenUrl: url)
                let communicationTokenRefreshOptions = CommunicationTokenRefreshOptions(initialToken: nil,
                                                                                        refreshProactively: true,
                                                                                        tokenRefresher: tokenRefresher)
                if let credential = try? CommunicationTokenCredential(withOptions: communicationTokenRefreshOptions) {
                    return credential
                }
            }
            throw DemoError.invalidToken
        }
    }

    private func showError(error: ChatCompositeError) {
        print("::::SwiftUIChatDemoView::showError \(error)")
        print("::::SwiftUIChatDemoView error.code \(error.code)")
        print("Error - \(error.code): \(error.error?.localizedDescription ?? error.localizedDescription)")
        switch error.code {
        case "connectFailed":
            errorMessage = "Connection Failed"
        case "authorizationFailed":
            errorMessage = "Authorization Failed"
        case "disconnectFailed":
            errorMessage = "Disconnect Failed"
        case "messageSendFailed":
            // no alert
            return
        default:
            errorMessage = "Unknown error"
        }
        isErrorDisplayed = true
    }
}