/*
 *  Copyright (c) 2022, Arvydas Ciupaila
 *
 *  This source code is licensed under under the terms of the
 *  GNU Lesser General Public License found in the
 *  LICENSE file in the root directory of this source tree.
 *
 */

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), cards: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        Task {
            let cards = await CardsStore.recentCards
            let entry = SimpleEntry(date: Date(), cards: cards)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            let cards = await CardsStore.recentCards
            var entries: [SimpleEntry] = []
            entries.append(SimpleEntry(date: Date(), cards: cards))
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let cards: [CardViewModel]
}

struct CardView: View {
    
    @ObservedObject var viewModel: CardViewModel

    var body: some View {
        Link(destination: URL(string: "cardz://card/\(viewModel.id.uuidString)")!) {
            ZStack {
                let cardColor = viewModel.color ?? .white
                Rectangle().foregroundColor(Color(cardColor))
                if let backgroundImage = viewModel.backgroundImage {
                    Image(uiImage: backgroundImage).resizable().aspectRatio(contentMode: .fill)
                } else {
                    let font = UIFont.appFont(ofType: .bold, size: .small)
                    Text(viewModel.name)
                        .font(Font(font))
                        .foregroundColor(Color(cardColor.textColor))
                }
            }
            .frame(height: 60)
            .clipped()
            .cornerRadius(6)
        }
    }
}

struct MyCardsWidgetEntryView: View {
    var entry: Provider.Entry
    
    var columns: [GridItem] = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(entry.cards) { viewModel in
                CardView(viewModel: viewModel)
            }
        }.padding(EdgeInsets(top: 0, leading: 13, bottom: 0, trailing: 13))
    }
}

@main
struct MyCardsWidget: Widget {
    let kind: String = "MyCardsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MyCardsWidgetEntryView(entry: entry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(ContainerRelativeShape().fill(Color.init(.sRGB, red: 0.89, green: 0.89, blue: 0.89, opacity: 0.15)))
        }
        .configurationDisplayName("My Cards")
        .description("Recently used Cards Widget")
        .supportedFamilies([.systemMedium])
    }
}

struct MyCardsWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyCardsWidgetEntryView(entry: SimpleEntry(date: Date(),
                                                  cards: CardsStore.recentCards))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
