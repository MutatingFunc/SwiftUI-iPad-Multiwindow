//
//  WindowManager.swift
//  Multiwindow
//
//  Created by James Froggatt on 19/12/2020.
//

import SwiftUI

struct WindowManager: View {
	@Binding var windows: [Window]
	@State private var fullscreenFrame: CGRect = .zero
	@State private var statusBarHeight: CGFloat = 0
	@AppStorage("Tiling") private var tilingEnabled = false
	
	var body: some View {
		VStack(spacing: 0) {
			//Rectangle().fill(Color.black.opacity(0.2))
			MenuBar(activeAppName: windows.last?.title)
				.colorScheme(.dark)
				.frame(height: statusBarHeight)
				.background(Color.black.opacity(0.2))
			
			ZStack {
				Rectangle().fill(Color.clear)
				let orderedWindows = ForEach(Array(zip(windows.indices, tilingEnabled ? windows.reversed() : windows)), id: \.1) { index, window in
					window.isActive(index == 0)
				}
				if tilingEnabled {
					HStack(spacing: 8) {
						orderedWindows
					}.padding(8)
				} else {
					orderedWindows
				}
			}.zIndex(-1)
			.background(
			 GeometryReader { (geometry: GeometryProxy) in
				 Rectangle().fill(Color.clear)
					 .onAppear {
						 fullscreenFrame.size = geometry.size
					 }
					 .onChange(of: geometry.size) { size in
						 fullscreenFrame.size = size
					 }
			 }
		 )
			
			Dock().ignoresSafeArea(.keyboard, edges: .bottom)
		}
		.edgesIgnoringSafeArea(.top)
		.background(
			GeometryReader { (geometry: GeometryProxy) in
				Rectangle().fill(Color.clear)
					.onAppear {
						statusBarHeight = geometry.safeAreaInsets.top
					}
					.onChange(of: geometry.safeAreaInsets.top) { size in
						if geometry.safeAreaInsets.top != 0 {
							statusBarHeight = geometry.safeAreaInsets.top
						}
					}
			}
		)
		.environment(
			\.windowManagement,
			WindowManagement(
				close: {w in
					windows.removeAll(where: {$0.id == w.id})
				},
				minimise: {w in
					
				},
				fullscreen: {
					fullscreenFrame
				},
				launch: {w in
					windows.append(w)
				},
				activate: {w in
					if let index = windows.firstIndex(where: {$0.id == w.id}) {
						windows.append(windows.remove(at: index))
					}
				},
				tilingEnabled: tilingEnabled
			)
		)
		.background(Image("Big Sur Graphic").resizable().scaledToFill().ignoresSafeArea())
	}
}


struct WindowManagement: EnvironmentKey {
	static let defaultValue: Self = WindowManagement()
	
	var close: (Window) -> () = {_ in}
	var minimise: (Window) -> () = {_ in}
	var fullscreen: () -> CGRect = {.zero}
	var launch: (Window) -> () = {_ in}
	var activate: (Window) -> () = {_ in}
	var tilingEnabled: Bool = false
}

extension EnvironmentValues {
	var windowManagement: WindowManagement {
		get {self[WindowManagement.self]}
		set {self[WindowManagement.self] = newValue}
	}
}
