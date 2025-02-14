#!/bin/bash

# Configure displays:
# - eDP-1 (laptop screen)
# - DP-2-1 (front dell monitor)
# - DP-2-2 (right dell monitor)
xrandr --output DP-1-1 --auto --above eDP-1
xrandr --output DP-1-2 --auto --right-of DP-1-1
