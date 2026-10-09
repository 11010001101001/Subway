# 🚇 Subway SPb (Saint Petersburg Metro Navigator)

> Native iOS subway navigation app with custom vector map rendering and shortest path routing.

<p align=center>
  <img src="https://github.com/user-attachments/assets/981a8703-af8b-43fb-b47d-6a499260b399" alt="Subway SPb Demo" width="320" />
</p>

---

## ✨ Features

- **Custom Interactive Map**: Saint Petersburg metro scheme rendered using Bézier curves and native CoreGraphics / QuartzCore layers.
- **Shortest Path Algorithm**: Graph-based pathfinding (Dijkstra algorithm) to calculate the fastest route between stations with transfer penalties.
- **Route Breakdown**: Detailed itinerary screen showing travel time, line transfers, and station checkpoints.
- **Haptic Feedback**: Custom tactile response on station selection and navigation events.
- **Offline First**: Fully standalone operation without external network dependencies.

## 🛠️ Tech Stack

- **Language**: Swift
- **UI Architecture**: UIKit (MVC), Programmatic UI & Storyboards
- **Graphics**: CoreGraphics, UIBezierPath, CALayer
- **Algorithms**: Graph Theory / Dijkstra Pathfinding
- **Platform**: iOS
