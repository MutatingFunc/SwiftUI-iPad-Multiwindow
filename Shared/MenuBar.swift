//
//  MenuBar.swift
//  Multiwindow
//
//  Created by James Froggatt on 20/12/2020.
//

import SwiftUI

struct MenuBar: View {
	var activeAppName: String?
	
	var body: some View {
		HStack(spacing: 16) {
			Spacer()
			Text("")
			Text(activeAppName ?? "Finder").fontWeight(.semibold)
			Text("File")
			Text("Edit")
			Text("View")
			Text("Window")
			Text("Go")
			Text("Help")
			Spacer()
		}
		.padding(.horizontal)
	}
}

struct MenuBarMenu: View {
	var title: String
	init(_ title: String) {self.title = title}
	
	var body: some View {
		Menu(title) { // Problematic - status bar consumes touch
			Button("A", action: {})
			Button("B", action: {})
			Button("C", action: {})
		}
	}
}
