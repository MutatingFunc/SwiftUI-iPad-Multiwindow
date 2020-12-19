//
//  ViewIf.swift
//  Multiwindow
//
//  Created by James Froggatt on 29/12/2020.
//

import SwiftUI

extension View {
	@ViewBuilder
	func `if`<ConditionalView: View>(_ condition: Bool, then modify: (Self) -> ConditionalView) -> some View {
		self.if(condition, then: modify, else: {$0})
	}
	@ViewBuilder
	func `if`<ConditionalView: View, ElseView: View>(_ condition: Bool, then modify: (Self) -> ConditionalView, else alternative: (Self) -> ElseView) -> some View {
		if condition {
			modify(self)
		} else {
			alternative(self)
		}
	}
}
