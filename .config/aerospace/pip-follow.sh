#!/bin/bash
# ワークスペース切り替え時に、PIPウィンドウを現在のワークスペースに移動する

current_workspace=$(aerospace list-workspaces --focused)

# ピクチャーインピクチャー ウィンドウを現在のワークスペースに移動
aerospace list-windows --all | grep "ピクチャーインピクチャー" | awk '{print $1}' | while read window_id; do
    if [ -n "$window_id" ]; then
        aerospace move-node-to-workspace --window-id "$window_id" "$current_workspace"
    fi
done
