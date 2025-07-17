import subprocess
from watchdog.observers import Observer
from watchdog.events import PatternMatchingEventHandler
import time
import os

class MdChangeHandler(PatternMatchingEventHandler):
    def __init__(self, make_script_path):
        super().__init__(patterns=["*.md"], ignore_directories=True)
        self.make_script_path = make_script_path

    def on_modified(self, event):
        print(f"Detected change in: {event.src_path}")
        self.run_make()

    def on_created(self, event):
        print(f"Detected new file: {event.src_path}")
        self.run_make()

    def run_make(self):
        print("Running make.sh...")
        subprocess.run(["bash", self.make_script_path], cwd=os.path.dirname(self.make_script_path))

if __name__ == "__main__":
    path_to_watch = "./draft"
    make_script = "./make.sh"
    event_handler = MdChangeHandler(make_script)
    observer = Observer()
    observer.schedule(event_handler, path=path_to_watch, recursive=True)
    observer.start()
    print(f"Watching for changes in {path_to_watch}/*.md ...")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()