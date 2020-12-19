//
//  Window.swift
//  Multiwindow
//
//  Created by James Froggatt on 20/12/2020.
//

import SwiftUI

struct Window: View, Identifiable, Hashable {
	@Environment(\.windowManagement) private var windowManagement
	let id = UUID()
	let app: HostApp
	var title: String
	var isActiveWindow = false
	@State private var frame: CGRect = CGRect(x: 20, y: 20, width: 320, height: 320)
	@State private var initialSize: CGSize = .zero
	
	enum HostApp: View {
		case safari, files, photos, mail, messages, textEdit, systemPreferences
		
		var body: some View {
			switch self {
			case .safari: Safari(url: URL(string: "https://en.wikipedia.org.")!).background(Color.blue)
			case .files: DocumentBrowser().background(Color.red)
			case .photos: ImagePicker().background(Color.yellow)
			case .mail: MailCompose().background(Color.purple)
			case .messages: MessagesCompose().background(Color.green)
			case .textEdit: TextEditorView().background(Color.gray)
			case .systemPreferences: SystemPrefs()
			}
		}
	}
	
	func isActive(_ isActive: Bool) -> Self {
		var copy = self
		copy.isActiveWindow = isActive
		return copy
	}
	
	var body: some View {
		VStack(spacing: 0) {
			TitleBar(windowFrame: $frame, title: title)
				.background(
					Color(.systemBackground).opacity(0.5)
				)
				.if(!windowManagement.tilingEnabled) {
					$0.gesture(
						DragGesture(minimumDistance: 0)
							.onChanged { value in
								windowManagement.activate(self)
								frame.origin.x += value.translation.width
								frame.origin.y += value.translation.height
								frame.origin.y = max(0, frame.origin.y)
							}
					)
				} else: {
					$0.onTapGesture {
						windowManagement.activate(self)
					}
				}
			app
		}
		.environment(\.window, self)
		.background(Color(.systemBackground))
		.cornerRadius(12)
		.overlay(
			RoundedRectangle(cornerRadius: 12)
				.stroke(Color(.systemFill), lineWidth: 0.5)
		)
		.if(!windowManagement.tilingEnabled || isActiveWindow) {
			$0.overlay(
				Image(systemName: "line.horizontal.3.decrease")
				 .frame(width: 20, height: 20)
				 .rotationEffect(.degrees(-45))
				 .background(Color.gray.opacity(1/255))
				 .padding(20)
				 .gesture(
					 DragGesture(minimumDistance: 0.5)
							 .onChanged { value in
								 if initialSize == .zero {
									 initialSize = frame.size
								 }
								 frame.size.width += value.translation.width
								 frame.size.height += value.translation.height
							 }
						 .onEnded { _ in
							 initialSize = .zero
						 }
				 )
				 .padding(-20),
			 alignment: .bottomTrailing
		 )
		}
		.shadow(color: Color.black.opacity(0.5), radius: 16, x: 0, y: 0)
		.if(!windowManagement.tilingEnabled) {
			$0.frame(width: frame.width, height: frame.height, alignment: .center)
				.position(x: frame.midX, y: frame.midY)
		}
		.if(windowManagement.tilingEnabled && isActiveWindow) {
			$0.frame(width: frame.width)
		}
	}
	
	static func == (lhs: Window, rhs: Window) -> Bool {
		lhs.id == rhs.id
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}

struct TitleBar: View {
	@Binding var windowFrame: CGRect
	var title: String
	
	var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 24) {
				Stoplights(windowFrame: $windowFrame)
				Text(title).font(.headline)
				Spacer()
			}.padding()
			Divider()
		}
	}
}

struct Stoplights: View {
	@Environment(\.windowManagement) private var windowManagement
	@Environment(\.window) private var window
	@Binding var windowFrame: CGRect
	@State private var symbolsShown = false
	
	var body: some View {
		switch window {
		case nil: EmptyView()
		case let window?:
			HStack(spacing: 8) {
				Group {
					Stoplight(name: "Close", color: .red, symbolShown: symbolsShown, symbol: Image(systemName: "xmark")) {
						windowManagement.close(window)
					}
					
					Stoplight(name: "Minimise", color: .yellow, symbolShown: symbolsShown, symbol: Image(systemName: "minus")) {
						windowManagement.minimise(window)
					}
					
					Stoplight(name: "Fullscreen", color: .green, symbolShown: symbolsShown, symbol: Image(systemName: "arrow.up.left.and.arrow.down.right")) {
						windowFrame = windowManagement.fullscreen()
					}
				}
				.buttonStyle(PlainButtonStyle())
				.contentShape(Circle())
				.labelStyle(IconOnlyLabelStyle())
				.padding(-10)
				.frame(width: 12, height: 12)
			}
			.background(Color(.systemBackground))
			.onHover { hovering in
				symbolsShown = hovering
			}
		}
	}
}

struct Stoplight: View {
	var name: String
	var color: Color
	var symbolShown: Bool
	var symbol: Image
	var action: () -> ()
	
	var body: some View {
		Button(action: action) {
			Label {
				Text(name)
			} icon: {
				Circle()
					.fill(color)
					.overlay(
						symbol.font(Font.system(size: 8).weight(.bold))
							.foregroundColor(Color(.secondaryLabel))
							.opacity(symbolShown ? 1 : 0)
					)
					.hoverEffect(.lift)
			}.padding(10)
		}
	}
}

enum WindowKey: EnvironmentKey {
	static let defaultValue: Window? = nil
}

extension EnvironmentValues {
	var window: Window? {
		get {self[WindowKey.self]}
		set {self[WindowKey.self] = newValue}
	}
}


struct Window_Previews: PreviewProvider {
	static var previews: some View {
		Window(app: .safari, title: "Safari")
	}
}
