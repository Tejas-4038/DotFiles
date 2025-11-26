#!/bin/sh

# GPU Temperature
temp="$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader)"

# GPU Utilization (%)
usage="$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | tr -d ' %')"

# GPU Power Draw (W)
power="$(nvidia-smi --query-gpu=power.draw --format=csv,noheader | tr -d ' W')"

# VRAM Usage (used/total)
vram_used="$(nvidia-smi --query-gpu=memory.used --format=csv,noheader | tr -d ' MiB')"
vram_total="$(nvidia-smi --query-gpu=memory.total --format=csv,noheader | tr -d ' MiB')"

tooltip="Power: ${power}W | VRAM: ${vram_used}/${vram_total} MiB"

# Output JSON for Waybar
printf '{"text": " %s%%   %s°C", "tooltip": "%s", "class": "gpu"}\n' \
  "$usage" "$temp" "$tooltip"
