//
//  MailCompose.swift
//  Multiwindow
//
//  Created by James Froggatt on 20/12/2020.
//

import SwiftUI
import MessageUI

struct MessagesCompose: UIViewControllerRepresentable {
	@Environment(\.windowManagement) private var windowManagement
	@Environment(\.window) private var window
	
	func makeUIViewController(context: Context) -> some UIViewController {
		let vc = MFMessageComposeViewController()
		vc.messageComposeDelegate = context.coordinator
		return vc
	}
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(
			close: {
				if let window = window {
					windowManagement.close(window)
				}
			}
		)
	}
	
	class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
		var close: () -> ()
		init(close: @escaping () -> ()) {
			self.close = close
			super.init()
		}
		
		func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
			if result == .cancelled {
				close()
			}
		}
	}
}
