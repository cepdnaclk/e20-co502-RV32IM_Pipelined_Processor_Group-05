# GTKWave TCL script for dynamic updates
proc update_waveform {} {
    # Reload the dumpfile without closing GTKWave
    reload
    
    # Update zoom to show new data
    zoom_full
    
    # Force display update
    update
}

# Set up signal monitoring
set update_interval 1000  # Update every 1 second

while {1} {
    # Check if source file has been modified
    if {[file mtime $dumpfile] > $last_mtime} {
        update_waveform
        set last_mtime [file mtime $dumpfile]
    }
    
    # Wait before next check
    after $update_interval
}