import { useState } from "react";
import { List, ActionPanel, Action, showToast, Toast } from "@vicinae/api";
import { spawn } from "child_process";

export default function Command() {
  // State that tracks what's typed in the Raycast search bar
  const [searchText, setSearchText] = useState("");

  function runFirefoxSearch() {
    if (!searchText.trim()) {
      showToast({ style: Toast.Style.Failure, title: "Empty query" });
      return;
    }

    // Use spawn so arguments are passed safely
    const child = spawn("firefox", ["--search", searchText], {
      detached: true,
      stdio: "ignore",
    });
    child.unref();

    showToast({
      style: Toast.Style.Success,
      title: `Searching Firefox for “${searchText}”`,
    });
  }

  return (
    <List
      searchText={searchText}
      onSearchTextChange={setSearchText}
      navigationTitle="Firefox Search"
      searchBarPlaceholder="Type something to search in Firefox…"
    >
      {/* One list item whose action runs the search */}
      <List.Item
        title={searchText ? `Search Firefox for “${searchText}”` : "Enter a query"}
        actions={
          <ActionPanel>
            <Action
              title="Search in Firefox"
              onAction={runFirefoxSearch}
            />
          </ActionPanel>
        }
      />
    </List>
  );
}

