//
//  TextEditor.swift
//  Multiwindow
//
//  Created by James Froggatt on 20/12/2020.
//

import SwiftUI

struct TextEditorView: View {
	@State private var text = ""
	var body: some View {
		TextEditor(text: $text)
	}
}
