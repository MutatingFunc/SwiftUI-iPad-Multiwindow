//
//  SystemPrefs.swift
//  Multiwindow
//
//  Created by James Froggatt on 29/12/2020.
//

import SwiftUI

struct SystemPrefs: View {
	@AppStorage("Tiling") private var tilingEnabled = false
	
	var body: some View {
		VStack {
			HStack {
				Toggle(isOn: $tilingEnabled) {
					Text("Tiling enabled")
				}
			}
		}.padding()
	}
}

struct SystemPrefs_Previews: PreviewProvider {
    static var previews: some View {
        SystemPrefs()
    }
}
