import subprocess
from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler
import time
import os
import threading

class MdChangeHandler(PatternMatchingEventHandler):
    def __init__(self, make_script_path):
        super().__init__(patterns=["*.md"], ignore_directories=True)
        self.make_script_path = make_script_path
        self._lock = threading.Lock()
        self._last_run = 0
        self._debounce_seconds = 2  # Prevent rapid repeated builds

    def on_any_event(self, event):
        # Only respond to file modifications or creations
        if event.event_type in ("modified", "created"):
            print(f"Detected {event.event_type} in: {event.src_path}")
            self.debounced_run_make()

    def debounced_run_make(self):
        with self._lock:
            now = time.time()
            if now - self._last_run > self._debounce_seconds:
                self._last_run = now
                self.run_make()
            else:
                print("Change detected, but build skipped due to debounce interval.")

    def run_make(self):
        print("Running make.sh...")
        try:
            result = subprocess.run(
                ["bash", self.make_script_path],
                cwd=os.path.dirname(self.make_script_path),
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                print("make.sh completed successfully.")
            else:
                print(f"make.sh failed with exit code {result.returncode}.")
                print(result.stderr)
        except Exception as e:
            print(f"Error running make.sh: {e}")

if __name__ == "__main__":
    path_to_watch = "./draft"
    make_script = "./make.sh"
    event_handler = MdChangeHandler(make_script)
    observer = Observer()
    observer.schedule(event_handler, path=path_to_watch, recursive=True)
    observer.start()
    print(f"Watching for changes in {path_to_watch}/*.md ... Press Ctrl+C to stop.")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Stopping observer...")
        observer.stop()
    observer.join()