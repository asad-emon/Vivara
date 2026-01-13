# Vivara

<div align="center">

**Your color. Your moment.**

*iOS video editing app using AI person segmentation to create selective color effects*

[![Platform](https://img.shields.io/badge/platform-iOS%2016%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)

</div>

---

## Overview

**Vivara** is a revolutionary iOS video editing application that uses advanced person segmentation AI to make people stand out in vivid, vibrant color while transforming the background into elegant grayscale. The result is a striking cinematic effect where subjects radiate with color while the world around them fades to monochrome.

### ✨ Key Features

- **AI-Powered Person Segmentation** - Uses Apple Vision framework for accurate person detection
- **Selective Color Effect** - Person in vivid color, background in elegant grayscale
- **Adjustable Intensity** - Fine-tune the effect with real-time preview
- **Video Comparison** - Side-by-side comparison of original vs processed video
- **Easy Export** - Save to Photos or share via share sheet
- **Professional Quality** - Highest quality video export with per-frame processing

---

## Screenshots

*Coming soon - app is currently in development*

---

## Technical Stack

### Frameworks
- **SwiftUI** - Modern declarative UI framework
- **AVFoundation** - Video processing and encoding
- **Vision** - Person segmentation using `VNGeneratePersonSegmentationRequest`
- **CoreImage** - Image processing and filters
- **PhotosUI** - Photo library integration

### Architecture
- **MVVM** - Model-View-ViewModel pattern
- **Async/Await** - Modern concurrency for video processing
- **Combine** - Reactive state management

### Requirements
- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

---

## How It Works

```
Video Input → Person Segmentation (Vision Framework)
    ↓
Generate Mask → Apply Threshold
    ↓
Original Frame + Grayscale Background → Blend with Mask
    ↓
Per-Frame Processing → Export High Quality Video
```

### Processing Pipeline

1. **Load Video** - Import from Photos or Files
2. **Generate Preview** - Extract frame and apply segmentation
3. **Adjust Threshold** - Real-time preview updates
4. **Process Video** - Per-frame segmentation and effect application
5. **Export** - High quality MOV output
6. **Compare & Share** - View comparison and share results

---

## Project Structure

```
Vivara/
├── Vivara/
│   ├── VivaraApp.swift              # App entry point
│   ├── ContentView.swift            # Main UI
│   ├── ComparisonView.swift         # Comparison screen
│   ├── VideoProcessor.swift         # Video processing logic
│   └── Assets.xcassets/             # App icons and colors
├── VIVARA_BRAND_GUIDE.md            # Brand identity guidelines
├── VIVARA_UI_REDESIGN_PROPOSAL.md   # Complete UI/UX redesign spec
└── VIVARA_LOGO_GENERATION_PROMPT.md # Logo design prompts
```

---

## Brand Identity

Vivara combines:
- **Viv** — from "vivid," meaning intensely deep, bright, and alive
- **Ara** — from "aura," the distinctive atmosphere surrounding a person

### Brand Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Electric Coral | `#FF6B6B` | Primary actions, warmth, energy |
| Vivid Purple | `#845EF7` | Secondary actions, creativity |
| Luminous Cyan | `#22D3EE` | Accents, highlights |
| Charcoal Gray | `#374151` | Text, borders |
| Soft Gray | `#F3F4F6` | Backgrounds |

See [VIVARA_BRAND_GUIDE.md](VIVARA_BRAND_GUIDE.md) for complete brand guidelines.

---

## UI Redesign

A comprehensive UI redesign is in progress with **3 design directions**:

1. **LUMINOUS** (Recommended) - Premium, elegant, content-creator focused
2. **MINIMAL STUDIO** - Clean, professional, editor-focused
3. **SOCIAL CREATOR** - Fun, vibrant, social-media native

See [VIVARA_UI_REDESIGN_PROPOSAL.md](VIVARA_UI_REDESIGN_PROPOSAL.md) for complete specifications, mockups, and implementation details.

---

## Installation

### Prerequisites

1. macOS with Xcode 15.0 or later
2. iOS 16.0+ device or simulator

### Build & Run

```bash
# Clone the repository
git clone https://github.com/pxlshpr/Vivara.git
cd Vivara

# Open in Xcode
open Vivara.xcodeproj

# Build and run (⌘R)
```

---

## Usage

1. **Launch Vivara** on your iOS device
2. **Choose Video**
   - Tap "Choose from Photos" to select from library
   - Or tap "Choose from Files" to import from file system
3. **Adjust Intensity**
   - Use the depth threshold slider to fine-tune the effect
   - Preview updates in real-time
4. **Process Video**
   - Tap "Process Video" to apply the effect
   - Watch the progress bar as each frame is processed
5. **Compare & Share**
   - View side-by-side comparison of original vs processed
   - Save to Photos or share via share sheet

---

## Roadmap

### Current Version (1.0)
- [x] Basic video import
- [x] Person segmentation
- [x] Selective color effect
- [x] Adjustable threshold
- [x] Comparison view
- [x] Export to Photos

### Upcoming Features
- [ ] Brand color implementation
- [ ] Redesigned UI (LUMINOUS direction)
- [ ] Effect presets (Cinematic, Subtle, Dreamy)
- [ ] Processing quality options (Fast, Balanced, High)
- [ ] Batch processing
- [ ] Projects gallery
- [ ] Video trimming
- [ ] Export format options (MOV, MP4, GIF)
- [ ] Dark mode
- [ ] Haptic feedback
- [ ] Onboarding flow

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## Documentation

- [Brand Guide](VIVARA_BRAND_GUIDE.md) - Complete brand identity guidelines
- [UI Redesign Proposal](VIVARA_UI_REDESIGN_PROPOSAL.md) - Full UI/UX specifications
- [Logo Generation](VIVARA_LOGO_GENERATION_PROMPT.md) - Logo design prompts

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Apple Vision framework for person segmentation
- SwiftUI for modern UI development
- CoreImage for efficient image processing

---

## Contact

For questions, feedback, or collaboration:

- **GitHub Issues**: [github.com/pxlshpr/Vivara/issues](https://github.com/pxlshpr/Vivara/issues)
- **Repository**: [github.com/pxlshpr/Vivara](https://github.com/pxlshpr/Vivara)

---

<div align="center">

**Your color. Your moment.**

Made with ✨ by [pxlshpr](https://github.com/pxlshpr)

Co-developed with [Claude Code](https://claude.com/claude-code)

</div>
