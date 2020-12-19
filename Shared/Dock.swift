//
//  Dock.swift
//  Multiwindow
//
//  Created by James Froggatt on 20/12/2020.
//

import SwiftUI

struct Dock: View {
	@Environment(\.windowManagement) private var windowManagement
	var body: some View {
		HStack {
			Group {
				Button(action: {windowManagement.launch(.init(app: .files, title: "Files"))}) {
					DockIcon(icon: Image(systemName: "folder.fill"), backgroundColor: .blue)
				}
				Button(action: {windowManagement.launch(.init(app: .systemPreferences, title: "System Preferences"))}) {
					DockIcon(icon: Image(systemName: "gearshape.2.fill"), backgroundColor: .gray)
				}
				Button(action: {windowManagement.launch(.init(app: .safari, title: "Safari"))}) {
					DockIcon(icon: Image(systemName: "safari.fill"), backgroundColor: .blue)
				}
				Button(action: {windowManagement.launch(.init(app: .photos, title: "Photos"))}) {
					DockIcon(icon: Image(systemName: "photo.fill"), backgroundColor: .yellow)
				}
				Button(action: {windowManagement.launch(.init(app: .mail, title: "Mail"))}) {
					DockIcon(icon: Image(systemName: "envelope.fill"), backgroundColor: .blue)
				}
				Button(action: {windowManagement.launch(.init(app: .messages, title: "Messages"))}) {
					DockIcon(icon: Image(systemName: "bubble.left.fill"), backgroundColor: .green)
				}
				Button(action: {windowManagement.launch(.init(app: .textEdit, title: "TextEdit"))}) {
					DockIcon(icon: Image(systemName: "square.and.pencil"), backgroundColor: .gray)
				}
			}
		}
		.padding()
		.background(Color(UIColor.systemBackground.withAlphaComponent(0.8)))
		.cornerRadius(24)
		.padding()
		.shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
	}
}

struct DockIcon: View {
	var icon: Image
	var backgroundColor: Color
	
	var body: some View {
		RoundedRectangle(cornerRadius: 16, style: .continuous)
			.fill(backgroundColor)
			.overlay(
				icon
					.font(.system(size: 28, weight: .semibold))
					.foregroundColor(.white)
			)
			.frame(width: 64, height: 64)
			.hoverEffect(.lift)
	}
}
