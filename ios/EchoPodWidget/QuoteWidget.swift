import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quote: "听见好声音，发现新世界。", author: "EchoPod", imageUrl: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let defaults = UserDefaults(suiteName: "group.com.echopod.ai")
        let quote = defaults?.string(forKey: "widget_quote") ?? "听见好声音，发现新世界。"
        let author = defaults?.string(forKey: "widget_author") ?? "EchoPod"
        let imageUrl = defaults?.string(forKey: "widget_image") ?? ""
        let entry = SimpleEntry(date: Date(), quote: quote, author: author, imageUrl: imageUrl)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let defaults = UserDefaults(suiteName: "group.com.echopod.ai")
        let quote = defaults?.string(forKey: "widget_quote") ?? "听见好声音，发现新世界。"
        let author = defaults?.string(forKey: "widget_author") ?? "EchoPod"
        let imageUrl = defaults?.string(forKey: "widget_image") ?? ""
        
        let entry = SimpleEntry(date: Date(), quote: quote, author: author, imageUrl: imageUrl)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
    let author: String
    let imageUrl: String
}

struct EchoPodQuoteWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(red: 26/255, green: 10/255, blue: 58/255) // Deep purple theme
            
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: "quote.opening")
                    .foregroundColor(.purple)
                    .font(.title2)
                
                Text(entry.quote)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(3)
                
                Spacer()
                
                HStack {
                    Text("— \(entry.author)")
                        .font(.caption2)
                        .italic()
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "podcast.arrow.up.right")
                        .foregroundColor(.purple)
                        .font(.caption)
                }
            }
            .padding()
        }
    }
}

struct EchoPodQuoteWidget: Widget {
    let kind: String = "EchoPodQuoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            EchoPodQuoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("EchoPod 金句")
        .description("每日为您推荐一个订阅播客中的智慧瞬间。")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
