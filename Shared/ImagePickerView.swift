//
//  ImagePickerView.swift
//  Multiwindow
//
//  Created by James Froggatt on 20/12/2020.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
	@Environment(\.windowManagement) private var windowManagement
	@Environment(\.window) private var window
	
	func makeUIViewController(context: Context) -> some UIViewController {
		let picker = UIImagePickerController()
		picker.delegate = context.coordinator
		picker.allowsEditing = true
		return picker
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
	
	class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		var close: () -> ()
		init(close: @escaping () -> ()) {
			self.close = close
			super.init()
		}
		
		func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			close()
		}
	}
}
