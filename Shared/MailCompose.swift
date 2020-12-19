//
//  MailCompose.swift
//  Multiwindow
//
//  Created by James Froggatt on 20/12/2020.
//

import SwiftUI
import MessageUI

struct MailCompose: UIViewControllerRepresentable {
	@Environment(\.windowManagement) private var windowManagement
	@Environment(\.window) private var window
	
	func makeUIViewController(context: Context) -> some UIViewController {
		let vc = MFMailComposeViewController()
		vc.mailComposeDelegate = context.coordinator
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
	
	class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
		var close: () -> ()
		init(close: @escaping () -> ()) {
			self.close = close
			super.init()
		}
		func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
			if result != .failed && error == nil {
				close()
			}
		}
	}
}
