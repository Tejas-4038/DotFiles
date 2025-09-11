import { showToast, Toast, clearSearchBar } from '@vicinae/api';
import { exec } from "child_process";

export default async function Command() {
  // Adjust Ghostty binary path if it’s different on your system.
  // `-e` tells Ghostty to execute the command in the shell.
  const cmd = "ghostty -e 'sudo dnf update; exec zsh'";

  exec(cmd, (error, stdout, stderr) => {
    if (error) {
      showToast({
        style: Toast.Style.Failure,
        title: "Failed to launch Ghostty",
        message: error.message,
      });
    } else if (stderr.trim()) {
      // Ghostty sometimes writes warnings to stderr; show them if present
      showToast({
        style: Toast.Style.Animated,
        title: "Ghostty launched",
        message: stderr,
      });
    }
  });
}
