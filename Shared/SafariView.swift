//
//  SafariView.swift
//  Multiwindow
//
//  Created by James Froggatt on 19/12/2020.
//

import SwiftUI
import SafariServices

#if os(macOS) || targetEnvironment(macCatalyst)
struct Safari: View {
	var url: URL?
	
	var body: some View {
		Rectangle().fill(Color.clear)
	}
}
#else
struct Safari: UIViewControllerRepresentable {
	@Environment(\.windowManagement) private var windowManagement
	@Environment(\.window) private var window
	let url: URL
	
	func makeUIViewController(context: UIViewControllerRepresentableContext<Safari>) -> SFSafariViewController {
		let vc = SFSafariViewController(url: url)
		vc.delegate = context.coordinator
		return vc
	}
	
	func updateUIViewController(_ safariViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<Safari>) {
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
	
	class Coordinator: NSObject, SFSafariViewControllerDelegate {
		var close: () -> ()
		init(close: @escaping () -> ()) {
			self.close = close
			super.init()
		}
		func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
			close()
		}
		func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
			close()
		}
	}
}

final class CustomSafariViewController: UIViewController {
	var url: URL? {
		didSet {
			// when url changes, reset the safari child view controller
			configureChildViewController()
		}
	}
	
	var coordinator: Safari.Coordinator?
	
	private var safariViewController: SFSafariViewController?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureChildViewController()
	}
	
	private func configureChildViewController() {
		// Remove the previous safari child view controller if not nil
		if let safariViewController = safariViewController {
			safariViewController.willMove(toParent: self)
			safariViewController.view.removeFromSuperview()
			safariViewController.removeFromParent()
			self.safariViewController = nil
		}
		
		guard let url = url else { return }
		
		// Create a new safari child view controller with the url
		let newSafariViewController = SFSafariViewController(url: url)
		newSafariViewController.dismissButtonStyle = .close
		newSafariViewController.preferredBarTintColor = .white
		newSafariViewController.delegate = coordinator
		addChild(newSafariViewController)
		newSafariViewController.view.frame = view.frame
		view.addSubview(newSafariViewController.view)
		newSafariViewController.didMove(toParent: self)
		self.safariViewController = newSafariViewController
	}
	
	override func viewWillLayoutSubviews() {
		safariViewController?.view.frame = view.frame
		super.viewWillLayoutSubviews()
	}
}
#endif

struct Safari_Previews: PreviewProvider {
	static var previews: some View {
		Safari(url: URL(string: "https://en.wikipedia.org/")!)
	}
}
