#!/usr/bin/env bash

if [[ "$SandboxUtilsVersion" ]]; then return 0; fi
readonly SandboxUtilsVersion="1.0"

SandboxWorkspacePath="/tmp/sandbox"
SandboxOutputDevice="/dev/stdout"

# After changing global identifiers in the main script,
# I forgot to update the identifiers here, leading to a
# horrific accident where the script ended and executed
# the command "rm -rf /*" ... yeah, fuck that...
# Spent an entire day retreiving all my shit back.
sandbox_remove_workfile() {
  # Check we've got the environment variables ready.
  if [[ -z "$SandboxWorkspacePath" || -z "$SandboxOutputDevice" ]]; then
    echo "The workspace path, or the output device is missing." >$SandboxOutputDevice
    return 1
  fi

  # Additional safety check: workspace path must be in /tmp
  if [[ "$SandboxWorkspacePath" != /tmp/* ]]; then
    echo "Security Error: Workspace path must be in /tmp" >$SandboxOutputDevice
    return 4
  fi

  # Check we're actually deleting a workfile.
  if [[ "$1" != $SandboxWorkspacePath* ]]; then
    echo "Stopped an attempt to delete non-workfiles." >$SandboxOutputDevice
    return 2
  fi

  # Additional safety: prevent deletion of root or important directories
  local dangerous_paths=("/" "/bin" "/boot" "/dev" "/etc" "/home" "/lib" "/proc" "/root" "/sbin" "/sys" "/usr" "/var")
  for path in "${dangerous_paths[@]}"; do
    if [[ "$1" == "$path" || "$1" == "$path/"* ]]; then
      echo "Security Error: Attempt to delete protected path blocked" >$SandboxOutputDevice
      return 5
    fi
  done

  # Attempt to remove iff it exists.
  #if [ ! -e "$1" -a "$1" != *"/"*"*" ]; then
  #	echo "Stopped an attempt to delete non-existent files" > $SandboxOutputDevice
  #	return 3;
  #fi

  # Remove the target file (do NOT force it).
  eval "rm -r $1 &> $SandboxOutputDevice"
}

# Create a secure temporary file with proper permissions
sandbox_create_tempfile() {
  local prefix="${1:-fluxion}"
  local tempfile=$(mktemp -p "$SandboxWorkspacePath" "${prefix}_XXXXXX")
  
  if [ $? -eq 0 ]; then
    chmod 600 "$tempfile"
    echo "$tempfile"
    return 0
  else
    echo "Error: Failed to create temporary file" >$SandboxOutputDevice
    return 1
  fi
}

# Create a secure temporary directory with proper permissions
sandbox_create_tempdir() {
  local prefix="${1:-fluxion}"
  local tempdir=$(mktemp -d -p "$SandboxWorkspacePath" "${prefix}_XXXXXX")
  
  if [ $? -eq 0 ]; then
    chmod 700 "$tempdir"
    echo "$tempdir"
    return 0
  else
    echo "Error: Failed to create temporary directory" >$SandboxOutputDevice
    return 1
  fi
}

# Securely remove a temporary file (overwrite before delete)
sandbox_secure_remove() {
  local target="$1"
  
  # Verify it's in the workspace
  if [[ "$target" != $SandboxWorkspacePath* ]]; then
    echo "Security Error: File not in workspace" >$SandboxOutputDevice
    return 1
  fi
  
  if [ -f "$target" ]; then
    # For files, use shred if available for secure deletion
    if command -v shred &>/dev/null; then
      shred -vfz -n 3 "$target" &>/dev/null 2>&1
    else
      # Fallback: overwrite with zeros (faster than random)
      dd if=/dev/zero of="$target" bs=4K count=1 conv=notrunc &>/dev/null 2>&1
      rm -f "$target"
    fi
    return 0
  elif [ -d "$target" ]; then
    # For directories, use regular removal
    sandbox_remove_workfile "$target"
    return $?
  fi
  
  return 1
}

# FLUXSCRIPT END
