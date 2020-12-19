//
//  ContentView.swift
//  Shared
//
//  Created by James Froggatt on 19/12/2020.
//

import SwiftUI

struct ContentView: View {
	@State private var windows: [Window] = []
	
	var body: some View {
		VStack {
			WindowManager(windows: $windows)
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
