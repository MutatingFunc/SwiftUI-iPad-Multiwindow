//
//  DocumentBrowserView.swift
//  Multiwindow
//
//  Created by James Froggatt on 19/12/2020.
//

import SwiftUI

#if os(macOS) || targetEnvironment(macCatalyst)
struct DocumentBrowser: View {
	var body: some View {
		Rectangle().fill(Color.clear)
	}
}
#else
struct DocumentBrowser: UIViewControllerRepresentable {
	
	func makeUIViewController(context: Context) -> some UIViewController {
		let db = UIDocumentBrowserViewController(forOpening: [.data, .folder])
		db.allowsDocumentCreation = false
		db.view.translatesAutoresizingMaskIntoConstraints = false
		return db
	}
	
	func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
	}
}
#endif

struct DocumentBrowser_Previews: PreviewProvider {
		static var previews: some View {
			DocumentBrowser()
		}
}
