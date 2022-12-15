//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel

    var body: some View {
        VStack {
//            TopBarView(viewModel: viewModel.topBarViewModel)
            Divider()
            Spacer()
            MessageListView(viewModel: viewModel.messageListViewModel)
            TypingParticipantsView(viewModel: viewModel.typingParticipantsViewModel)
            messageInput
        }
        .onAppear {
            viewModel.getInitialMessages()
        }
    }

    var messageInput: some View {
        Group {
            if #available(iOS 15, *) {
                BottomBarView(viewModel: viewModel.bottomBarViewModel)
            } else {
                // Use Custom legacy textfeld to handle focusing on iOS 14
            }
        }
    }
}