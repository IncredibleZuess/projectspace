# Delegate System Implementation

## Overview
The delegate system has been implemented to change the navigation from scene-based transitions to a window-based system where the Galaxy map remains the main window and system views open as popup windows.

## Changes Made

### 1. New System Window (`system_window.tscn`)
- Created a new Window-based scene for system views
- Contains the system map with a Close button instead of "Back to Galaxy Map"
- Properly sized and configured for overlaying on the galaxy view

### 2. Galaxy Node Updates (`galnode.gd`)
- **Before**: Used `get_tree().change_scene_to_file("res://system_map.tscn")` 
- **After**: Creates and shows system window instances
- Integrates with window management system for proper cleanup
- Allows multiple system windows to be opened simultaneously

### 3. System Map Updates (`system_map.gd`)
- **Before**: Had "Back to Galaxy Map" button that changed scenes
- **After**: Has close button that closes the current window
- Added window close request handling
- Proper cleanup integration with the main map

### 4. Main Map Updates (`map.gd`)
- Added window tracking array (`system_windows`)
- Added window management functions:
  - `add_system_window(window)` - Register a new system window
  - `remove_system_window(window)` - Unregister a system window  
  - `cleanup_system_windows()` - Clean up all windows on exit
- Added `_exit_tree()` callback for proper cleanup

### 5. Scene Configuration (`map.tscn`)
- Added `galaxy_map` group to the main Map node for easy reference

## Benefits

1. **Multiple System Views**: Users can now open multiple system windows simultaneously
2. **Persistent Galaxy Context**: The galaxy map always remains visible as the main reference
3. **Better Navigation**: No more scene transitions that lose context
4. **Improved UX**: More intuitive navigation pattern similar to modern applications
5. **Memory Safety**: Proper window cleanup prevents memory leaks

## Usage

1. Start the application (login -> galaxy map)
2. Click on any galaxy node/system
3. A new system window opens showing that system's details
4. The galaxy map remains visible in the background
5. Click the Close button or window X to close individual system windows
6. Multiple systems can be viewed simultaneously

## Technical Details

- System windows are instances of `system_window.tscn`
- Windows are managed by the main map scene
- All windows are properly cleaned up when the map scene exits
- Signal connections ensure proper communication between windows and the main map