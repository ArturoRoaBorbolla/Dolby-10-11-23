import subprocess
import sys
import os


ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ROOT_DIR = f'{ROOT_DIR}\\common'
def generate_requirements_file():
    try:
        subprocess.check_call(['pipreqs', '.'])
        print("requirements.txt file has been generated successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error generating requirements.txt: {e}")

def install_required_libraries():
    try:
        with open(f'{ROOT_DIR}\\watcher.txt', 'w') as watcher_file:
            with open(f'{ROOT_DIR}\\requirements.txt') as f:
                libraries = f.read().splitlines()
                with open(f'{ROOT_DIR}\\installed.txt') as f:
                    installed = f.read().splitlines()
                with open(f'{ROOT_DIR}\\installed.txt', 'w') as output_file:
                    for lib in libraries:
                        try:
                            if lib in installed:
                                output_file.write(f"{lib}\n")
                            else:
                                subprocess.check_call(['python','-m','pip', 'install', lib])
                                output_file.write(f"{lib}\n")
                        except:
                            sys.exit(1)
            watcher_file.write("All required libraries have been installed successfully.")
    except Exception as e:
        print(f"Some errors occurred {e}")
        sys.exit(1)

#generate_requirements_file()
install_required_libraries()
