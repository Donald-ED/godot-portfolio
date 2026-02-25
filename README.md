# Godot Game Development Portfolio — Donald

A curated set of 5 projects demonstrating breadth across game development: systems design, shader programming, UI/UX, networking, and tool development. Built with **Godot 4.3+**.

## Projects

### 1. Voidlock — Top-Down Roguelite Shooter
**Genre:** Action / Roguelite | **Complexity:** Medium

A fast-paced top-down shooter with procedurally generated rooms, weapon upgrades, and boss fights. Demonstrates procedural generation (BSP), finite state machines for AI, object pooling, particle effects, and save/load systems.

**Key Systems:** BSP Dungeon Generation • State Machine AI • Weapon Resource System • Screen Shake & Hit Flash Shaders

### 2. Hexforge — Turn-Based Strategy Game
**Genre:** Strategy / Tactics | **Complexity:** Medium-High

A hex-grid tactics game with unique unit abilities, A* pathfinding with custom heuristics, and a full turn-based game loop. Heavy emphasis on clean UI and systems architecture.

**Key Systems:** Hex Grid Math (Cube Coordinates) • A* Pathfinding • Turn/Phase System • Custom Resource Types

### 3. Netpulse — Multiplayer Party Game
**Genre:** Party / Minigames | **Complexity:** High

A collection of real-time multiplayer minigames (2–4 players) using Godot's ENet API. Features a lobby system, client-server architecture with authority, and network synchronization.

**Key Systems:** ENet Multiplayer • Client-Server Authority • Lobby + Matchmaking • Scene Transitions

### 4. Luminara — 3D Puzzle Platformer
**Genre:** Puzzle / Platformer | **Complexity:** Medium

A 3D puzzle platformer where light and shadow manipulation creates platforms and solves environmental puzzles. Focuses on shader work and visual quality.

**Key Systems:** CharacterBody3D • Shadow Detection Shader • Volumetric Light Beams • Dissolve Effects

### 5. GDForge — Godot Editor Plugin
**Genre:** Tool / Plugin | **Complexity:** Medium

A visual dialog/conversation tree editor built as a Godot editor plugin. Uses GraphEdit for visual editing, exports to JSON, and includes a runtime dialog system.

**Key Systems:** EditorPlugin API • GraphEdit/GraphNode • Custom Resource Serialization • Runtime Dialog Runner

## Architecture

```
godot-portfolio/
├── voidlock/          # Top-down roguelite shooter
├── hexforge/          # Turn-based hex strategy
├── netpulse/          # Multiplayer party game
├── luminara/          # 3D puzzle platformer
├── gdforge/           # Editor plugin
├── docs/              # Portfolio website
└── README.md
```

## Getting Started

1. Install [Godot 4.3+](https://godotengine.org/download)
2. Clone this repository
3. Open any project folder in Godot
4. Press F5 to run

## Portfolio Website

The portfolio is hosted on GitHub Pages. Visit the `docs/` folder or the live site to see project showcases with architecture diagrams and code highlights.

## License

MIT License — see individual project folders for details.
