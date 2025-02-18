//
//  FontViewer.swift
//  Snowflakes
//
//  Created by Htet Aung Shine on 18/2/25.
//

import SwiftUI

struct FontViewer: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Large Title").font(.largeTitle)
            Text("Title").font(.title)
            Text("Title 2").font(.title2)
            Text("Title 3").font(.title3)
            Text("Headline").font(.headline)
            Text("Subheadline").font(.subheadline)
            Text("Body (default)").font(.body)
            Text("Callout").font(.callout)
            Text("Footnote").font(.footnote)
            Text("Caption").font(.caption)
            Text("Caption 2").font(.caption2)
        }
    }
}

#Preview{
    FontViewer()
}
