import React from 'react';
import { List, ActionPanel, Action, showToast, Icon, Toast } from '@vicinae/api';

import { exec } from "child_process";
import path from "path";

function runCommand(command: string, actionName: string) {
  exec(command, (error, stdout, stderr) => {
    if (error || stderr) {
      showToast({
        style: Toast.Style.Failure,
        title: `${actionName} cancelled`,
        message: error?.message || stderr,
      });
    }
  });
}

export default function Command() {
  return (
    <List>
      <List.Item
        title="Shut Down"
        icon={path.resolve(__dirname, "assets/shutdown.svg")}
        actions={
          <ActionPanel>
            <Action
              title="Shut Down"
              onAction={() => runCommand("gnome-session-quit --power-off", "shut down")}
            />
          </ActionPanel>
        }
      />
      <List.Item
        title="Restart"
        icon={path.resolve(__dirname, "assets/restart.svg")}
        actions={
          <ActionPanel>
            <Action
              title="Restart"
              onAction={() => runCommand("gnome-session-quit --reboot", "restart")}
            />
          </ActionPanel>
        }
      />
      <List.Item
        title="Log Out"
        icon={path.resolve(__dirname, "assets/logout.svg")}
        actions={
          <ActionPanel>
            <Action
              title="Log Out"
              onAction={() => runCommand("gnome-session-quit --logout", "log out")}
            />
          </ActionPanel>
        }
      />
      <List.Item
        title="Lock"
        icon={path.resolve(__dirname, "assets/lock.svg")}
        actions={
          <ActionPanel>
            <Action
              title="Lock"
              onAction={() => runCommand("xdg-screensaver lock", "lock")}
            />
          </ActionPanel>
        }
      />
      <List.Item
        title="Suspend"
        icon={path.resolve(__dirname, "assets/suspend.svg")}
        actions={
          <ActionPanel>
            <Action
              title="Suspend"
              onAction={() => runCommand("systemctl suspend", "suspend")}
            />
          </ActionPanel>
        }
      />
    </List>
  );
}
