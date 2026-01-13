# Vivara UI Redesign Proposal

**Version 1.0** | January 13, 2026
**Status:** Awaiting Design Direction Selection
**Document Type:** Comprehensive UI/UX Redesign Specification

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Current State Analysis](#current-state-analysis)
3. [App Functionality Overview](#app-functionality-overview)
4. [Design Direction 1: LUMINOUS](#design-direction-1-luminous-recommended)
5. [Design Direction 2: MINIMAL STUDIO](#design-direction-2-minimal-studio)
6. [Design Direction 3: SOCIAL CREATOR](#design-direction-3-social-creator)
7. [Feature Comparison](#feature-comparison)
8. [Recommended Improvements](#recommended-improvements-all-designs)
9. [Implementation Recommendation](#implementation-recommendation)
10. [How to Continue This Work](#how-to-continue-this-work)

---

## Executive Summary

Based on comprehensive analysis of the Vivara codebase and brand guidelines, this document presents **3 distinct design directions** for transforming Vivara into a fully-fledged, professional iOS application. Each direction offers a complete visual and UX overhaul while preserving the core video processing functionality.

### Key Findings

- **Current app:** Functional but uses default SwiftUI styling with no brand implementation
- **Brand guide:** Comprehensive guidelines exist but are not yet implemented in code
- **Opportunity:** Transform from a basic utility into a polished, market-ready application
- **Recommendation:** Design Direction 1 "LUMINOUS" (Premium, Elegant, Content-Creator Focused)

---

## Current State Analysis

### Current Issues Identified

| Issue | Description | Impact |
|-------|-------------|--------|
| No brand colors | Using default SwiftUI blue/gray | App looks generic |
| Single-screen workflow | Everything on one screen with modal alerts | Poor UX flow |
| No onboarding | Users dropped directly into app | Poor feature discovery |
| Limited visual hierarchy | Flat design, no depth | Hard to scan |
| No settings/customization | No user preferences | Limited flexibility |
| Basic progress feedback | Simple progress bar | Unclear processing status |
| No presets/saved projects | Must start fresh each time | Inefficient workflow |

### Current Technical Stack

```
Framework: SwiftUI (iOS 16+)
Architecture: MVVM (VideoProcessor as ViewModel)
Video Processing: AVFoundation + Vision framework
Person Segmentation: VNGeneratePersonSegmentationRequest
Image Processing: CoreImage filters
Export: AVAssetExportSession (MOV format)
```

### Current File Structure

```
/Vivara/
├── VivaraApp.swift          (Entry point)
├── ContentView.swift        (Main UI - 222 lines)
├── ComparisonView.swift     (Comparison UI - 202 lines)
├── VideoProcessor.swift     (ViewModel - 366 lines)
├── Vivara.entitlements      (App capabilities)
└── Assets.xcassets/         (App icons, colors)
```

**Total codebase:** ~790 lines of Swift (lean, focused)

---

## App Functionality Overview

### Core Features (Currently Implemented)

1. **Video Import**
   - PhotosPicker for Photos library
   - File picker for file system
   - Supports .mov, .mp4, .quickTimeMovie

2. **Person Segmentation**
   - Uses Apple Vision framework
   - VNGeneratePersonSegmentationRequest
   - Quality level: .balanced

3. **Selective Color Effect**
   - Person remains in full color
   - Background converted to grayscale
   - Adjustable depth threshold (0.0 - 1.0)

4. **Video Processing**
   - Per-frame processing via AVMutableVideoComposition
   - Progress tracking with status messages
   - Export to temporary directory

5. **Comparison View**
   - Side-by-side original vs processed
   - Hold gesture to show original
   - Synchronized playback

6. **Export Options**
   - Save to Photos library
   - Share via share sheet

### Processing Pipeline

```
Video Input → AVURLAsset → Thumbnail Generation
    ↓
Preview Generation (Vision + CoreImage)
    ↓
Video Composition (Per-frame processing)
    ↓
Vision Segmentation + CoreImage Filters
    ↓
AVAssetExportSession → Encoded Video Output
    ↓
Save to Photos / Share Sheet
```

### Target Audience (from Brand Guide)

- **Primary:** Content creators, social media enthusiasts (Instagram, TikTok, YouTube)
- **Secondary:** Videographers, filmmakers, digital artists
- **Age range:** 16-35 years old
- **Tech-savvy:** iPhone users comfortable with creative apps

---

## Design Direction 1: LUMINOUS (Recommended)

*Premium, Elegant, Content-Creator Focused*

### Design Philosophy

- Full brand color implementation (coral/purple gradients)
- Card-based UI with soft shadows and depth
- Bottom tab navigation for quick access
- Rich visual feedback and animations
- Professional yet approachable aesthetic

### Screen Mockups

#### Splash Screen

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░ SPLASH SCREEN ░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│                                                             │
│                    ✨ Radiant glow effect                   │
│                                                             │
│              ██╗   ██╗██╗██╗   ██╗                          │
│              ██║   ██║██║██║   ██║                          │
│              ╚██╗ ██╔╝██║╚██╗ ██╔╝ara                       │
│               ╚████╔╝ ██║ ╚████╔╝                           │
│                ╚═══╝  ╚═╝  ╚═══╝                            │
│             [gradient coral→purple]                         │
│                                                             │
│               Your color. Your moment.                      │
│                                                             │
│                        ◉ ◉ ◉                                │
│                    Loading dots                             │
└─────────────────────────────────────────────────────────────┘
```

**Implementation Notes:**
- Background: Soft gray (#F3F4F6) or subtle gradient
- Logo: "Viv" in coral→purple gradient, "ara" in charcoal
- Tagline: SF Pro Display, Medium weight
- Animation: Pulsing glow effect, loading dots

#### Onboarding Flow (3 Screens)

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░ ONBOARDING 1/3 ░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│                                                             │
│            ┌─────────────────────────────┐                  │
│            │     👤 ← Full color         │                  │
│            │    ╔═══╗                    │                  │
│            │    ║███║ Person in vivid    │                  │
│            │    ║███║ coral/purple       │                  │
│            │    ╚═══╝                    │                  │
│            │ ░░░░░░░░░░░░░░░░░░░░░░░░░░  │                  │
│            │   Background in grayscale   │                  │
│            └─────────────────────────────┘                  │
│                                                             │
│                  YOU RADIATE                                │
│              in vivid, stunning color                       │
│                                                             │
│            AI-powered person segmentation                   │
│            isolates you from the world                      │
│                                                             │
│                     ● ○ ○                                   │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │               [Continue →]                            │  │
│  │           coral gradient button                       │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                             │
│                    Skip for now                             │
└─────────────────────────────────────────────────────────────┘
```

**Onboarding Screen Content:**

| Screen | Title | Description | Illustration |
|--------|-------|-------------|--------------|
| 1/3 | YOU RADIATE | AI-powered person segmentation isolates you from the world | Person silhouette in color, BG gray |
| 2/3 | ONE-TAP MAGIC | Professional results in seconds, no editing skills needed | Magic wand/sparkle effect |
| 3/3 | SHARE EVERYWHERE | Ready for Instagram, TikTok, YouTube and beyond | Social platform icons |

#### Main Screen

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░ MAIN SCREEN ░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ⚙️                 Vivara                     ⭐️    │   │
│  │  Settings        [gradient]                 Projects│   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ╔═════════════════════════════════════════════════════╗   │
│  ║                                                     ║   │
│  ║                                                     ║   │
│  ║         ┌───────────────────────────────┐          ║   │
│  ║         │                               │          ║   │
│  ║         │    [VIDEO PREVIEW AREA]       │          ║   │
│  ║         │                               │          ║   │
│  ║         │   👤 Person in color          │          ║   │
│  ║         │   ░░ Background grayscale     │          ║   │
│  ║         │                               │          ║   │
│  ║         │   ▶️ Play preview button      │          ║   │
│  ║         │                               │          ║   │
│  ║         └───────────────────────────────┘          ║   │
│  ║                                                     ║   │
│  ╚═════════════════════════════════════════════════════╝   │
│           rounded corners 24px, subtle shadow              │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  EFFECT INTENSITY                              100% │   │
│  │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░  │   │
│  │  coral→purple gradient slider                       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  PRESETS                                     See All│   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐       │   │
│  │  │ Cinema │ │ Subtle │ │ Dreamy │ │ Custom │       │   │
│  │  │  ■■■   │ │  ■■■   │ │  ■■■   │ │   +    │       │   │
│  │  └────────┘ └────────┘ └────────┘ └────────┘       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌────────────────────┐  ┌────────────────────────────┐   │
│  │     📷 Import      │  │    ✨ Process Video        │   │
│  │    secondary btn   │  │      coral gradient        │   │
│  └────────────────────┘  └────────────────────────────┘   │
│                                                             │
│  ╔═══════════════════════════════════════════════════════╗ │
│  ║  📁 Photos  │  📂 Files  │  🎬 Record  │  📚 Recent   ║ │
│  ║     Tab        Tab          Tab            Tab        ║ │
│  ╚═══════════════════════════════════════════════════════╝ │
│           Bottom tab bar with coral accent                  │
└─────────────────────────────────────────────────────────────┘
```

**Main Screen Components:**

| Component | Specifications |
|-----------|---------------|
| Nav Bar | White background, Vivara logo centered (gradient), Settings left, Projects right |
| Preview Card | 24px corner radius, subtle shadow (0 4px 12px rgba(0,0,0,0.08)), 16:9 aspect ratio |
| Intensity Slider | Coral→purple gradient track, white thumb with shadow |
| Presets | Horizontal scroll, card style, thumbnail preview |
| Action Buttons | Import (secondary/outline), Process (primary/coral gradient) |
| Tab Bar | 4 tabs with SF Symbols, coral highlight on active |

#### Processing Screen

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░ PROCESSING SCREEN ░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ←                Processing                         │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ╔═════════════════════════════════════════════════════╗   │
│  ║                                                     ║   │
│  ║         ┌───────────────────────────────┐          ║   │
│  ║         │                               │          ║   │
│  ║         │    [CURRENT FRAME PREVIEW]    │          ║   │
│  ║         │                               │          ║   │
│  ║         │    Live processing preview    │          ║   │
│  ║         │    showing effect applied     │          ║   │
│  ║         │                               │          ║   │
│  ║         └───────────────────────────────┘          ║   │
│  ║                                                     ║   │
│  ╚═════════════════════════════════════════════════════╝   │
│                                                             │
│                    ✨ Enhancing your aura...                │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                     │   │
│  │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░  │   │
│  │         coral→purple gradient progress bar          │   │
│  │                                                     │   │
│  │                      67%                            │   │
│  │              Frame 201 of 300                       │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│                 Estimated: 45 seconds                       │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              [ Cancel Processing ]                  │   │
│  │                 secondary button                    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│            💡 Tip: Higher quality takes longer              │
│               but produces stunning results                 │
└─────────────────────────────────────────────────────────────┘
```

**Processing Screen Features:**
- Live frame preview (updates periodically)
- Animated gradient progress bar
- Percentage + frame count display
- Estimated time remaining
- Cancel button (secondary style)
- Rotating tips at bottom

#### Completion Screen

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░ COMPLETION SCREEN ░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ←                 Complete                    Done  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ╔═════════════════════════════════════════════════════╗   │
│  ║                                                     ║   │
│  ║         ┌───────────────────────────────┐          ║   │
│  ║         │                               │          ║   │
│  ║         │    [PROCESSED VIDEO PLAYER]   │          ║   │
│  ║         │                               │          ║   │
│  ║         │         ▶️ Play               │          ║   │
│  ║         │                               │          ║   │
│  ║         │    Full playback controls     │          ║   │
│  ║         │                               │          ║   │
│  ║         └───────────────────────────────┘          ║   │
│  ║                                                     ║   │
│  ╚═════════════════════════════════════════════════════╝   │
│                                                             │
│                   ✨ You look radiant!                      │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │            [ 🔄 Compare Original ]                  │   │
│  │               Hold to see original                  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │               SHARE YOUR MOMENT                     │   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐       │   │
│  │  │  💾    │ │  📤    │ │  📷    │ │  ···   │       │   │
│  │  │ Save   │ │ Share  │ │ Insta  │ │ More   │       │   │
│  │  └────────┘ └────────┘ └────────┘ └────────┘       │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │            [ ✨ Create Another ]                      │ │
│  │             coral gradient button                     │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

#### Comparison View

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░ COMPARISON VIEW ░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  Black cinematic background                                 │
│                                                             │
│  ╔═════════════════════════════════════════════════════╗   │
│  ║                                                     ║   │
│  ║         ┌───────────────────────────────┐          ║   │
│  ║         │                               │          ║   │
│  ║         │    [SIDE-BY-SIDE VIEW]        │          ║   │
│  ║         │                               │          ║   │
│  ║         │  ORIGINAL  │  PROCESSED       │          ║   │
│  ║         │    ░░░░░   │     👤          │          ║   │
│  ║         │    ░░░░░   │   vivid!        │          ║   │
│  ║         │    ░░░░░   │     ░░░         │          ║   │
│  ║         │            │                  │          ║   │
│  ║         └───────────────────────────────┘          ║   │
│  ║                                                     ║   │
│  ║   ← Drag divider to compare →                      ║   │
│  ║                                                     ║   │
│  ╚═════════════════════════════════════════════════════╝   │
│                                                             │
│          ┌─────────┐  ▶️ ▮▮  ┌─────────┐                   │
│          │ Original│  play   │Processed│                   │
│          └─────────┘  pause  └─────────┘                   │
│              Toggle buttons with glow effect                │
│                                                             │
│                       [ Done ]                              │
└─────────────────────────────────────────────────────────────┘
```

**Comparison View Features:**
- Black cinematic background
- Draggable divider for side-by-side comparison
- Toggle buttons for Original/Processed
- Play/Pause controls
- Synchronized playback
- Done button to dismiss

#### Settings Screen

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░ SETTINGS SCREEN ░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ←                Settings                           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  VIDEO QUALITY                                      │   │
│  │                                                     │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐            │   │
│  │  │ Standard │ │  High    │ │ Maximum  │            │   │
│  │  │   720p   │ │  1080p   │ │   4K     │            │   │
│  │  │   Fast   │ │ Balanced │ │  Slower  │            │   │
│  │  └──────────┘ └──────────┘ └──────────┘            │   │
│  │                  [selected]                         │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  PROCESSING                                         │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │  Segmentation Quality        [ Balanced ▼ ]        │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │  Auto-save to Photos         [ 🔘 ON    ]          │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │  Save Original Copy          [ ○ OFF   ]           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  APPEARANCE                                         │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │  Theme                       [ System ▼ ]          │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │  Haptic Feedback             [ 🔘 ON    ]          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  ABOUT VIVARA                                       │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │  Version                              1.0.0        │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │  Privacy Policy                             →      │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │  Terms of Service                           →      │   │
│  │  ─────────────────────────────────────────────────  │   │
│  │  Rate Vivara ⭐                             →      │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│            Made with ✨ by Your Team                        │
└─────────────────────────────────────────────────────────────┘
```

#### Projects Screen

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░ PROJECTS SCREEN ░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ←               My Projects                   Edit  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  🔍 Search projects...                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │ ┌──────────────┐ │  │ ┌──────────────┐ │                │
│  │ │              │ │  │ │              │ │                │
│  │ │  Thumbnail   │ │  │ │  Thumbnail   │ │                │
│  │ │     📹      │ │  │ │     📹      │ │                │
│  │ │              │ │  │ │              │ │                │
│  │ └──────────────┘ │  │ └──────────────┘ │                │
│  │ Beach Sunset     │  │ City Walk        │                │
│  │ Jan 10, 2026     │  │ Jan 8, 2026      │                │
│  │ 0:45 • 1080p     │  │ 1:20 • 4K        │                │
│  └──────────────────┘  └──────────────────┘                │
│                                                             │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │ ┌──────────────┐ │  │ ┌──────────────┐ │                │
│  │ │              │ │  │ │              │ │                │
│  │ │  Thumbnail   │ │  │ │  Thumbnail   │ │                │
│  │ │     📹      │ │  │ │     📹      │ │                │
│  │ │              │ │  │ │              │ │                │
│  │ └──────────────┘ │  │ └──────────────┘ │                │
│  │ Coffee Shop      │  │ Portrait         │                │
│  │ Jan 5, 2026      │  │ Jan 3, 2026      │                │
│  │ 0:30 • 1080p     │  │ 0:15 • 1080p     │                │
│  └──────────────────┘  └──────────────────┘                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### LUMINOUS Design System

#### Colors (from Brand Guide)

```swift
// Primary Colors
static let electricCoral = Color(hex: "#FF6B6B")  // Primary actions
static let vividPurple = Color(hex: "#845EF7")    // Secondary actions
static let luminousCyan = Color(hex: "#22D3EE")   // Accents

// Neutral Colors
static let charcoalGray = Color(hex: "#374151")   // Text, borders
static let softGray = Color(hex: "#F3F4F6")       // Backgrounds
static let mediumGray = Color(hex: "#9CA3AF")     // Secondary text

// Gradients
static let brandGradient = LinearGradient(
    colors: [electricCoral, vividPurple],
    startPoint: .leading,
    endPoint: .trailing
)
```

#### Typography

```swift
// Type Scale
static let displayLarge = Font.system(size: 48, weight: .bold)
static let headline1 = Font.system(size: 32, weight: .bold)
static let headline2 = Font.system(size: 28, weight: .semibold)
static let bodyLarge = Font.system(size: 18, weight: .regular)
static let bodyRegular = Font.system(size: 16, weight: .regular)
static let caption = Font.system(size: 12, weight: .medium)
```

#### Components

```swift
// Primary Button
struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: [.electricCoral, .vividPurple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
                .shadow(color: .electricCoral.opacity(0.3), radius: 12, y: 4)
        }
    }
}

// Preview Card
struct PreviewCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white)
            .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
    }
}
```

---

## Design Direction 2: MINIMAL STUDIO

*Clean, Professional, Editor-Focused*

### Design Philosophy

- Full-bleed video preview (maximized viewing area)
- Swipe-up tool drawer (hidden by default)
- Floating minimal action buttons
- Sheet-based modals instead of full screens
- Focus on content, not UI chrome
- Subtle brand accents only
- Professional, distraction-free editing

### Screen Mockups

#### Main Screen

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░ MAIN SCREEN ░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  ████████████████████████████████████████████████████████   │
│  ██                                                    ██   │
│  ██                                                    ██   │
│  ██                                                    ██   │
│  ██                                                    ██   │
│  ██           [LARGE VIDEO PREVIEW AREA]               ██   │
│  ██                                                    ██   │
│  ██              Full-bleed, edge-to-edge              ██   │
│  ██                                                    ██   │
│  ██                      ▶️                            ██   │
│  ██                                                    ██   │
│  ██                                                    ██   │
│  ██                                                    ██   │
│  ████████████████████████████████████████████████████████   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                     │   │
│  │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░  │   │
│  │     minimal white slider with coral thumb           │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                        85%                                  │
│                                                             │
│  ┌─────────────┐              ┌─────────────────────────┐  │
│  │             │              │                         │  │
│  │   📁 Open   │              │     ✨ Process          │  │
│  │    white    │              │    coral pill button    │  │
│  │             │              │                         │  │
│  └─────────────┘              └─────────────────────────┘  │
│                                                             │
│               Minimal floating action buttons               │
└─────────────────────────────────────────────────────────────┘
```

#### Tool Drawer (Swipe Up)

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░ TOOL DRAWER (SWIPE UP) ░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  ████████████████████████████████████████████████████████   │
│  ██           [VIDEO PREVIEW - smaller]                ██   │
│  ████████████████████████████████████████████████████████   │
│                                                             │
│  ───────────────────── ═══ ─────────────────────────────    │
│                     drag handle                             │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  INTENSITY                                          │   │
│  │  ──────────────────────────────────────────────▓──  │   │
│  │                                               85%   │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  QUALITY                                            │   │
│  │     ○ Fast    ● Balanced    ○ High                 │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  FORMAT                                             │   │
│  │     ● MOV     ○ MP4                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  PRESETS                                            │   │
│  │  ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐               │   │
│  │  │ 1  │ │ 2  │ │ 3  │ │ 4  │ │ +  │               │   │
│  │  └────┘ └────┘ └────┘ └────┘ └────┘               │   │
│  │   Cinematic  Subtle  Dreamy  Stark   Save          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

#### Export Sheet

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░ EXPORT SHEET ░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  ───────────────────── ═══ ─────────────────────────────    │
│                                                             │
│                    ✓ COMPLETE                               │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                     │   │
│  │           [Processed video thumbnail]               │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│         Beach_Sunset_vivara.mov • 12.4 MB                   │
│                                                             │
│  ┌────────────┐ ┌────────────┐ ┌────────────┐              │
│  │            │ │            │ │            │              │
│  │   💾 Save  │ │  📤 Share  │ │  🔄 Compare│              │
│  │            │ │            │ │            │              │
│  └────────────┘ └────────────┘ └────────────┘              │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │              [ Create Another ]                       │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### MINIMAL STUDIO Key Features

- **Full-bleed preview:** Maximum screen real estate for video
- **Hidden controls:** Swipe up to reveal tools
- **Sheet-based modals:** Non-intrusive overlays
- **Minimal chrome:** Focus on content
- **Quick export:** Streamlined completion flow
- **Professional aesthetic:** Clean, distraction-free

---

## Design Direction 3: SOCIAL CREATOR

*Fun, Vibrant, Social-Media Native*

### Design Philosophy

- Vertical-first design (optimized for TikTok/Reels)
- In-app recording with live effect preview
- Emoji-based presets for quick selection
- Fun, playful UI with animations
- Direct share to social platforms
- Celebratory completion experience
- Younger, trend-focused audience appeal

### Screen Mockups

#### Main Screen

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░ MAIN SCREEN ░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  ╔═════════════════════════════════════════════════════╗   │
│  ║                   VIVARA ✨                         ║   │
│  ║          gradient text, bouncy animation            ║   │
│  ╚═════════════════════════════════════════════════════╝   │
│                                                             │
│  ╔═════════════════════════════════════════════════════╗   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░ [VERTICAL VIDEO PREVIEW] ░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░     9:16 aspect ratio    ░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░   TikTok/Reels native    ░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ╚═════════════════════════════════════════════════════╝   │
│        rounded corners with gradient border glow           │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │          ✨ INTENSITY ✨                            │   │
│  │                                                     │   │
│  │  😊────────────────────●────────────────────🔥     │   │
│  │  subtle              vibe               intense    │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐        │
│  │ 🎬    │ │ ✨    │ │ 🌙    │ │ 🔥    │ │ 💫    │        │
│  │ Cine  │ │ Glow  │ │ Dreamy│ │ Bold  │ │ Custom│        │
│  └───────┘ └───────┘ └───────┘ └───────┘ └───────┘        │
│      Emoji-labeled presets, colorful backgrounds           │
│                                                             │
│  ╔═══════════════════════════════════════════════════════╗ │
│  ║                                                       ║ │
│  ║   📁 Gallery    🎥 Record    ✨ Magic Button         ║ │
│  ║                                                       ║ │
│  ╚═══════════════════════════════════════════════════════╝ │
│        Gradient bottom bar, "Magic" is main CTA            │
└─────────────────────────────────────────────────────────────┘
```

#### Recording Mode

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░ RECORDING MODE ░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │   ×                                         🔄 Flip │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ╔═════════════════════════════════════════════════════╗   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░ [LIVE CAMERA FEED WITH EFFECT] ░░░░░░░░░░░░░║   │
│  ║░░░░░░░░                                 ░░░░░░░░░░░░░║   │
│  ║░░░░░░░░    Real-time preview of effect  ░░░░░░░░░░░░░║   │
│  ║░░░░░░░░    Person in color, BG gray     ░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ╚═════════════════════════════════════════════════════╝   │
│                                                             │
│                          ⏱️ 0:15                            │
│                        Recording timer                      │
│                                                             │
│  ┌───────┐            ┌───────────┐           ┌───────┐   │
│  │       │            │           │           │       │   │
│  │  ⚡️  │            │    🔴     │           │  📷   │   │
│  │Effect │            │  RECORD   │           │ Photo │   │
│  │       │            │           │           │       │   │
│  └───────┘            └───────────┘           └───────┘   │
│                    Giant record button                      │
└─────────────────────────────────────────────────────────────┘
```

#### Share Screen

```
┌─────────────────────────────────────────────────────────────┐
│ ░░░░░░░░░░░░░░░░░░░ SHARE SCREEN ░░░░░░░░░░░░░░░░░░░░░░░░░░ │
│                                                             │
│                   🎉 YOU LOOK AMAZING! 🎉                   │
│                      confetti animation                     │
│                                                             │
│  ╔═════════════════════════════════════════════════════╗   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░  [PROCESSED VIDEO PREVIEW]  ░░░░░░░░░░░░░░░║   │
│  ║░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░║   │
│  ╚═════════════════════════════════════════════════════╝   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │          SHARE TO YOUR FAVORITES                    │   │
│  │                                                     │   │
│  │  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐      │   │
│  │  │     │  │     │  │     │  │     │  │     │      │   │
│  │  │TikTok│ │Insta│  │ Snap │  │ iMsg │  │ More │      │   │
│  │  │     │  │     │  │     │  │     │  │     │      │   │
│  │  └─────┘  └─────┘  └─────┘  └─────┘  └─────┘      │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────┐  ┌────────────────────────────┐  │
│  │     💾 Save         │  │      🔄 Compare            │  │
│  └─────────────────────┘  └────────────────────────────┘  │
│                                                             │
│  ┌───────────────────────────────────────────────────────┐ │
│  │           [ ✨ Create More Magic ✨ ]                 │ │
│  │              vibrant gradient button                  │ │
│  └───────────────────────────────────────────────────────┘ │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### SOCIAL CREATOR Key Features

- **Vertical-first:** 9:16 aspect ratio native
- **In-app recording:** Live camera with effect preview
- **Emoji presets:** Fun, quick selection
- **Platform sharing:** Direct to TikTok, Instagram, etc.
- **Celebratory UX:** Confetti, animations
- **Young audience appeal:** Trendy, playful

---

## Feature Comparison

| Feature | LUMINOUS | MINIMAL STUDIO | SOCIAL CREATOR |
|---------|----------|----------------|----------------|
| **Onboarding** | ✅ 3-screen flow | ❌ Skip to app | ✅ Fun animated |
| **Tab Navigation** | ✅ Bottom tabs | ❌ Single screen | ✅ Bottom bar |
| **Presets** | ✅ Cards with thumbnails | ✅ Minimal pills | ✅ Emoji buttons |
| **In-App Recording** | ❌ Import only | ❌ Import only | ✅ Full camera |
| **Comparison View** | ✅ Slider control | ✅ Simple toggle | ✅ Hold gesture |
| **Settings** | ✅ Full settings page | ✅ Tool drawer | ❌ Minimal |
| **Projects Gallery** | ✅ Grid view | ✅ List view | ❌ Recent only |
| **Social Sharing** | ✅ Share sheet | ✅ Share sheet | ✅ Platform buttons |
| **Visual Style** | Premium elegant | Professional clean | Fun vibrant |
| **Target User** | Content creators | Videographers | Social influencers |
| **Complexity** | Medium-High | Low-Medium | Medium |
| **Brand Alignment** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## Recommended Improvements (All Designs)

### Small, High-Impact Improvements

These improvements can be implemented regardless of which design direction is chosen:

### 1. Processing Quality Options

```swift
enum ProcessingQuality: String, CaseIterable {
    case fast = "Fast"
    case balanced = "Balanced"
    case high = "High"

    var resolution: CGSize {
        switch self {
        case .fast: return CGSize(width: 1280, height: 720)
        case .balanced: return CGSize(width: 1920, height: 1080)
        case .high: return CGSize(width: 3840, height: 2160)
        }
    }

    var segmentationQuality: VNGeneratePersonSegmentationRequest.QualityLevel {
        switch self {
        case .fast: return .fast
        case .balanced: return .balanced
        case .high: return .accurate
        }
    }
}
```

**Impact:** Users can choose speed vs quality based on their needs

---

### 2. Effect Presets System

```swift
struct EffectPreset: Codable, Identifiable {
    let id: UUID
    let name: String
    let intensity: Double
    let icon: String
    let isCustom: Bool

    static let defaults: [EffectPreset] = [
        EffectPreset(id: UUID(), name: "Cinematic", intensity: 0.85, icon: "🎬", isCustom: false),
        EffectPreset(id: UUID(), name: "Subtle", intensity: 0.5, icon: "✨", isCustom: false),
        EffectPreset(id: UUID(), name: "Dreamy", intensity: 0.7, icon: "🌙", isCustom: false),
        EffectPreset(id: UUID(), name: "Bold", intensity: 1.0, icon: "🔥", isCustom: false),
    ]
}

class PresetManager: ObservableObject {
    @Published var presets: [EffectPreset] = EffectPreset.defaults

    func saveCustomPreset(name: String, intensity: Double) {
        let preset = EffectPreset(
            id: UUID(),
            name: name,
            intensity: intensity,
            icon: "💫",
            isCustom: true
        )
        presets.append(preset)
        // Persist to UserDefaults or file
    }
}
```

**Impact:** One-tap effects without manual slider adjustment

---

### 3. Haptic Feedback

```swift
struct HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// Usage examples:
// Button tap: HapticManager.impact(.light)
// Processing complete: HapticManager.notification(.success)
// Slider change: HapticManager.selection()
```

**Impact:** Professional, tactile feel throughout the app

---

### 4. Batch Processing Queue

```swift
class BatchProcessor: ObservableObject {
    @Published var queue: [URL] = []
    @Published var currentIndex: Int = 0
    @Published var isProcessing: Bool = false
    @Published var results: [URL: URL] = [:] // input: output

    func addToQueue(_ urls: [URL]) {
        queue.append(contentsOf: urls)
    }

    func processNext(using processor: VideoProcessor) async {
        guard currentIndex < queue.count else {
            isProcessing = false
            return
        }

        isProcessing = true
        let inputURL = queue[currentIndex]

        await processor.loadVideo(from: inputURL)
        await processor.processVideo()

        if let outputURL = processor.outputURL {
            results[inputURL] = outputURL
        }

        currentIndex += 1
        await processNext(using: processor)
    }
}
```

**Impact:** Process multiple videos without waiting between each

---

### 5. Video Trimming

```swift
struct TrimRange {
    var start: CMTime
    var end: CMTime

    var duration: CMTime {
        CMTimeSubtract(end, start)
    }
}

extension VideoProcessor {
    func setTrimRange(_ range: TrimRange) {
        self.trimRange = range
    }

    // Modify processVideo to respect trim range
    func processVideo() async throws {
        // ... existing setup ...

        if let trim = trimRange {
            exportSession.timeRange = CMTimeRange(start: trim.start, duration: trim.duration)
        }

        // ... rest of processing ...
    }
}

// UI Component
struct TrimSlider: View {
    @Binding var range: TrimRange
    let duration: CMTime

    var body: some View {
        // Custom range slider implementation
        GeometryReader { geometry in
            // ... slider UI ...
        }
    }
}
```

**Impact:** Process only the desired portion of videos

---

### 6. Export Format Options

```swift
enum ExportFormat: String, CaseIterable {
    case mov = "MOV"
    case mp4 = "MP4"
    case gif = "GIF"

    var fileType: AVFileType {
        switch self {
        case .mov: return .mov
        case .mp4: return .mp4
        case .gif: return .mov // GIF conversion done separately
        }
    }

    var fileExtension: String {
        rawValue.lowercased()
    }
}

extension VideoProcessor {
    func export(format: ExportFormat) async throws -> URL {
        switch format {
        case .mov, .mp4:
            return try await exportVideo(fileType: format.fileType)
        case .gif:
            let videoURL = try await exportVideo(fileType: .mov)
            return try await convertToGIF(videoURL)
        }
    }

    private func convertToGIF(_ videoURL: URL) async throws -> URL {
        // Implementation using AVAssetImageGenerator + ImageIO
    }
}
```

**Impact:** Flexibility for different sharing needs

---

### 7. Auto-Save to Projects

```swift
struct Project: Codable, Identifiable {
    let id: UUID
    let name: String
    let createdAt: Date
    let inputURL: URL
    let outputURL: URL
    let settings: ProjectSettings
    let thumbnailData: Data?
}

struct ProjectSettings: Codable {
    let intensity: Double
    let quality: ProcessingQuality
    let preset: String?
}

class ProjectManager: ObservableObject {
    @Published var projects: [Project] = []

    private let storageURL: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Projects")
    }()

    func save(_ project: Project) throws {
        // Create directory if needed
        try FileManager.default.createDirectory(at: storageURL, withIntermediateDirectories: true)

        // Copy video files to project directory
        let projectDir = storageURL.appendingPathComponent(project.id.uuidString)
        try FileManager.default.createDirectory(at: projectDir, withIntermediateDirectories: true)

        // Save metadata
        let metadataURL = projectDir.appendingPathComponent("metadata.json")
        let data = try JSONEncoder().encode(project)
        try data.write(to: metadataURL)

        projects.append(project)
    }

    func load() throws {
        // Load all projects from storage
    }

    func delete(_ project: Project) throws {
        // Remove project directory and update list
    }
}
```

**Impact:** Re-export without reprocessing, project history

---

### 8. Live Preview During Slider

```swift
class VideoProcessor: ObservableObject {
    // Add debounced preview update
    private var previewUpdateTask: Task<Void, Never>?

    @Published var depthThreshold: Double = 0.85 {
        didSet {
            // Cancel previous update task
            previewUpdateTask?.cancel()

            // Debounce preview updates
            previewUpdateTask = Task { @MainActor in
                try? await Task.sleep(nanoseconds: 100_000_000) // 100ms debounce

                guard !Task.isCancelled else { return }
                await updatePreview()
            }
        }
    }

    @MainActor
    private func updatePreview() async {
        guard let thumbnail = originalThumbnail else { return }

        // Generate new preview with current threshold
        if let newPreview = await generatePreviewImage(from: thumbnail) {
            self.previewImage = newPreview
        }
    }
}
```

**Impact:** Real-time visual feedback as user adjusts settings

---

### 9. Processing ETA

```swift
class VideoProcessor: ObservableObject {
    @Published var estimatedTimeRemaining: TimeInterval?

    private var frameProcessingTimes: [TimeInterval] = []
    private var processingStartTime: Date?

    func updateETA(currentFrame: Int, totalFrames: Int) {
        guard let startTime = processingStartTime else { return }

        let elapsed = Date().timeIntervalSince(startTime)
        let avgTimePerFrame = elapsed / Double(currentFrame)
        let remainingFrames = totalFrames - currentFrame

        estimatedTimeRemaining = avgTimePerFrame * Double(remainingFrames)
    }

    var formattedETA: String {
        guard let eta = estimatedTimeRemaining else { return "" }

        if eta < 60 {
            return "\(Int(eta)) seconds"
        } else {
            let minutes = Int(eta / 60)
            let seconds = Int(eta.truncatingRemainder(dividingBy: 60))
            return "\(minutes)m \(seconds)s"
        }
    }
}
```

**Impact:** Users know how long to wait

---

### 10. Dark Mode Support

```swift
// Color extension with dark mode support
extension Color {
    // Brand colors (same in both modes)
    static let electricCoral = Color(hex: "#FF6B6B")
    static let vividPurple = Color(hex: "#845EF7")
    static let luminousCyan = Color(hex: "#22D3EE")

    // Adaptive colors
    static let background = Color("Background") // Light: #F3F4F6, Dark: #1F2937
    static let cardBackground = Color("CardBackground") // Light: #FFFFFF, Dark: #374151
    static let primaryText = Color("PrimaryText") // Light: #374151, Dark: #F9FAFB
    static let secondaryText = Color("SecondaryText") // Light: #9CA3AF, Dark: #9CA3AF
}

// Assets.xcassets color definitions:
// Background:
//   Any: #F3F4F6
//   Dark: #1F2937
//
// CardBackground:
//   Any: #FFFFFF
//   Dark: #374151
//
// PrimaryText:
//   Any: #374151
//   Dark: #F9FAFB
```

**Impact:** Comfortable viewing in all lighting conditions

---

## Implementation Recommendation

### Recommended Design Direction

**Design Direction 1: LUMINOUS** is recommended because:

1. **Best brand alignment** - Fully implements the Vivara brand guide colors, typography, and voice
2. **Professional yet approachable** - Appeals to target audience (content creators 16-35)
3. **Complete feature set** - Includes all essential features without unnecessary complexity
4. **Scalable architecture** - Easy to add features later (recording, more effects, etc.)
5. **Industry standard** - Follows iOS HIG while maintaining unique brand identity

### Implementation Priority Order

| Priority | Component | Effort | Impact |
|----------|-----------|--------|--------|
| 1 | Brand colors + Design system | Low | High |
| 2 | Splash screen | Low | Medium |
| 3 | Main screen redesign | Medium | High |
| 4 | Processing screen | Low | Medium |
| 5 | Completion screen | Low | Medium |
| 6 | Settings page | Medium | Medium |
| 7 | Presets system | Medium | High |
| 8 | Onboarding flow | Medium | Medium |
| 9 | Projects gallery | High | Medium |
| 10 | Comparison view improvements | Low | Low |

### Quick Wins (Can implement immediately)

1. **Add brand colors** - Create Colors.swift with brand palette
2. **Update buttons** - Apply gradient to primary buttons
3. **Add haptic feedback** - UIImpactFeedbackGenerator on interactions
4. **Improve progress UI** - Gradient progress bar, better messaging
5. **Dark mode colors** - Add color assets for dark mode

---

## How to Continue This Work

### Starting a New Chat Session

When starting a new chat to continue this redesign work, provide the following context:

```
I'm working on a UI redesign for the Vivara iOS app - a video processing
app that uses AI person segmentation to create selective color effects
(person in color, background in grayscale).

Please read these files for context:
1. /Users/pxlshpr/Developer/Vivara/VIVARA_UI_REDESIGN_PROPOSAL.md
2. /Users/pxlshpr/Developer/Vivara/VIVARA_BRAND_GUIDE.md

The recommended design direction is "LUMINOUS" (premium, elegant,
content-creator focused).

Current task: [Specify what you want to work on next]
```

### Continuation Tasks

Here are the specific tasks that can be requested in future sessions:

#### Phase 1: Foundation
- [ ] Create `VivaraDesignSystem.swift` with colors, typography, and components
- [ ] Create `Colors.xcassets` with brand colors for light/dark mode
- [ ] Update `ContentView.swift` to use new design system
- [ ] Create `SplashView.swift` with animated logo

#### Phase 2: Core Screens
- [ ] Redesign main screen with card-based preview
- [ ] Create `ProcessingView.swift` with improved progress UI
- [ ] Create `CompletionView.swift` with share options
- [ ] Improve `ComparisonView.swift` with slider control

#### Phase 3: Features
- [ ] Create `PresetManager.swift` and preset UI components
- [ ] Create `SettingsView.swift` with all options
- [ ] Create `OnboardingView.swift` (3-screen flow)
- [ ] Create `ProjectsView.swift` with grid gallery

#### Phase 4: Polish
- [ ] Add haptic feedback throughout
- [ ] Implement processing ETA
- [ ] Add animations and transitions
- [ ] Implement dark mode fully

### Example Continuation Prompts

**For implementing the design system:**
```
Continue the Vivara UI redesign. Read VIVARA_UI_REDESIGN_PROPOSAL.md
for context. Create VivaraDesignSystem.swift with the brand colors,
typography scale, and reusable button components defined in the
LUMINOUS design direction.
```

**For redesigning the main screen:**
```
Continue the Vivara UI redesign. Read VIVARA_UI_REDESIGN_PROPOSAL.md
for context. Update ContentView.swift to match the LUMINOUS main screen
mockup, using the design system we created.
```

**For adding presets:**
```
Continue the Vivara UI redesign. Read VIVARA_UI_REDESIGN_PROPOSAL.md
for context. Implement the Effect Presets System as defined in the
recommended improvements section.
```

### Key Files Reference

| File | Purpose |
|------|---------|
| `VIVARA_UI_REDESIGN_PROPOSAL.md` | This document - full redesign spec |
| `VIVARA_BRAND_GUIDE.md` | Brand colors, typography, voice |
| `ContentView.swift` | Main UI (needs redesign) |
| `ComparisonView.swift` | Comparison UI (needs improvement) |
| `VideoProcessor.swift` | ViewModel (add new features here) |

### Design Assets Needed

Before full implementation, these design assets should be created:

1. **App Icon** - 1024x1024px with person silhouette and gradient
2. **Splash Logo** - Vector wordmark with gradient "Viv" and gray "ara"
3. **Onboarding Illustrations** - 3 illustrations for onboarding screens
4. **Preset Thumbnails** - Sample effect previews for preset cards

---

## Appendix

### Color Reference (Hex Codes)

```
Primary Colors:
- Electric Coral:  #FF6B6B
- Vivid Purple:    #845EF7
- Luminous Cyan:   #22D3EE

Neutral Colors:
- Charcoal Gray:   #374151
- Soft Gray:       #F3F4F6
- Medium Gray:     #9CA3AF
- Pure White:      #FFFFFF
- Deep Black:      #000000

Dark Mode Variants:
- Background:      #1F2937
- Card Background: #374151
- Primary Text:    #F9FAFB
```

### Typography Reference

```
Display Large:  48px / Bold / -0.02em tracking
Headline 1:     32px / Bold / -0.01em tracking
Headline 2:     28px / Semibold / 1.2 line-height
Body Large:     18px / Regular / 1.6 line-height
Body Regular:   16px / Regular / 1.5 line-height
Caption:        12px / Medium / 0.01em tracking
Label:          11px / Medium / 0.02em tracking (uppercase)
```

### Button Specifications

```
Primary Button:
- Background: Linear gradient (coral → purple)
- Text: White, 17px, Semibold
- Corner radius: 12px
- Padding: 16px vertical, 32px horizontal
- Shadow: 0 4px 12px rgba(255, 107, 107, 0.3)

Secondary Button:
- Background: Transparent
- Border: 2px solid Charcoal Gray
- Text: Charcoal Gray, 17px, Semibold
- Corner radius: 12px
- Padding: 16px vertical, 32px horizontal
```

---

**Document Version:** 1.0
**Created:** January 13, 2026
**Last Updated:** January 13, 2026
**Status:** Awaiting Design Direction Selection

---

*This document serves as the complete specification for the Vivara UI redesign project. All mockups, specifications, and implementation details are contained within for reference in future development sessions.*
