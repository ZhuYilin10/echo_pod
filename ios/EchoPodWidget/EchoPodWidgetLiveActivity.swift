import ActivityKit
import WidgetKit
import SwiftUI

struct EchoPodWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: EchoPodAttributes.self) { context in
            // Lock Screen UI
            VStack {
                HStack {
                    if let url = URL(string: context.attributes.imageUrl),
                       let data = try? Data(contentsOf: url),
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    } else {
                        Image(systemName: "music.note")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(context.attributes.episodeTitle)
                            .font(.headline)
                            .lineLimit(1)
                        Text(context.attributes.podcastTitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    Spacer()
                    Image(systemName: context.state.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                }
                ProgressView(value: context.state.progress)
                    .progressViewStyle(.linear)
                    .tint(.purple)
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.8))
            .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    if let url = URL(string: context.attributes.imageUrl),
                       let data = try? Data(contentsOf: url),
                       let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(4)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(systemName: context.state.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .foregroundColor(.purple)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading) {
                        Text(context.attributes.episodeTitle)
                            .font(.headline)
                        Text(context.attributes.podcastTitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        ProgressView(value: context.state.progress)
                            .tint(.purple)
                    }
                }
            } compactLeading: {
                Image(systemName: "headphones")
                    .foregroundColor(.purple)
            } compactTrailing: {
                ProgressView(value: context.state.progress)
                    .progressViewStyle(.circular)
                    .tint(.purple)
            } minimal: {
                Image(systemName: context.state.isPlaying ? "waveform" : "pause")
                    .foregroundColor(.purple)
            }
            .widgetURL(URL(string: "echopod://open-player"))
            .keylineTint(Color.purple)
        }
    }
}

// Re-defining Attributes here as well because it needs to be accessible in the Widget Extension
struct EchoPodAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var progress: Double
        var isPlaying: Bool
    }

    var podcastTitle: String
    var episodeTitle: String
    var imageUrl: String
}
